import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/signup/data/datasources/auth_local_data_source.dart';
import 'package:jesoor_pro/features/auth/signup/data/models/signup_state_cache_model.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/complete_step2_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/complete_step3_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/get_categories_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/get_category_children_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/get_governorates_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/signup_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_state.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/utils/grade_utils.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase signupUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final CompleteStep2UseCase completeStep2UseCase;
  final CompleteStep3UseCase completeStep3UseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetCategoryChildrenUseCase getCategoryChildrenUseCase;
  final GetGovernoratesUseCase getGovernoratesUseCase;
  final AuthLocalDataSource localDataSource;

  // Flags to prevent duplicate API calls
  bool _isFetchingCategories = false;
  bool _isFetchingGovernorates = false;
  bool _isRefreshingCategories = false;
  bool _isRefreshingGovernorates = false;

  SignupCubit({
    required this.signupUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.completeStep2UseCase,
    required this.completeStep3UseCase,
    required this.getCategoriesUseCase,
    required this.getCategoryChildrenUseCase,
    required this.getGovernoratesUseCase,
    required this.localDataSource,
  }) : super(const SignupState()) {
    // Preload data from cache immediately on initialization
    // This ensures data is ready when user opens signup screen
    _loadCachedData();
  }

  // Load cached data immediately (fast, non-blocking)
  Future<void> _loadCachedData() async {
    // Load signup state from cache first
    _loadCachedSignupState();

    // Load governorates from cache immediately (they're needed in step 2)
    // This is fast because it reads from local storage (cache-first strategy)
    // Use silent mode to avoid showing loading indicator on initial load
    getGovernorates(silent: true);

    // Load categories from cache if available
    getCategories(silent: true);
  }

  // Load cached signup state and restore it
  Future<void> _loadCachedSignupState() async {
    try {
      final cachedState = await localDataSource.getCachedSignupState();
      if (cachedState != null) {
        // Restore education data
        final newState = state.copyWith(
          educationSystem: cachedState.educationSystem,
          educationStage: cachedState.educationStage,
          educationGrade: cachedState.educationGrade,
          errorMessage: null, // Clear any previous error messages
        );
        emit(newState);

        // Category selection will be restored when categories are loaded
        // via _tryRestoreCategorySelectionFromCache()
      }
    } catch (e) {
      // Silently fail - cached state is not critical
    }
  }

  // Restore category selection from cache (called when categories are loaded)
  Future<void> _tryRestoreCategorySelectionFromCache() async {
    if (state.selectedCategory != null) {
      // Already have a selected category, skip
      return;
    }

    try {
      final cachedState = await localDataSource.getCachedSignupState();
      if (cachedState != null &&
          cachedState.selectedCategoryId != null &&
          state.categories.isNotEmpty) {
        // Find the category
        try {
          final category = state.categories.firstWhere(
            (cat) => cat.id == cachedState.selectedCategoryId,
          );

          // Restore selected category
          emit(state.copyWith(selectedCategory: category));

          // Load category children - they will be cached
          getCategoryChildren(category.id);
        } catch (e) {
          // Category not found, skip
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  // Save current signup state to cache
  Future<void> _saveSignupStateToCache() async {
    try {
      final cacheModel = SignupStateCacheModel(
        educationSystem: state.educationSystem,
        educationStage: state.educationStage,
        educationGrade: state.educationGrade,
        selectedCategoryId: state.selectedCategory?.id,
        selectedCategoryChildrenIds: state.selectedCategoryChildren
            .map((child) => child.id)
            .toList(),
      );
      await localDataSource.cacheSignupState(cacheModel);
    } catch (e) {
      // Silently fail - cache is not critical
    }
  }

  // UI Interactions
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void nextSignupStep() {
    // Only allow moving forward
    final nextStep = state.signupStep + 1;
    emit(state.copyWith(signupStep: nextStep));
  }

  void setSignupStep(int step) {
    // CRITICAL: Prevent reverting to earlier steps - only allow moving forward or staying same
    // Once we reach step 3 or higher, never allow going back to step 2 or lower
    if (state.signupStep >= 3 && step < 3) {
      // Don't allow going backwards from step 3+ - preserve current step
      return;
    }
    if (step < state.signupStep) {
      // Don't allow going backwards in general - preserve current step
      return;
    }
    emit(state.copyWith(signupStep: step));
  }

  void previousSignupStep() {
    // Allow going back from steps 3, 4, 5
    if (state.signupStep > 1 && state.signupStep <= 5) {
      final previousStep = state.signupStep - 1;
      emit(state.copyWith(signupStep: previousStep));
    }
  }

  void selectSystem(String system) {
    emit(
      state.copyWith(
        educationSystem: system,
        educationStage: null, // Clear stage when system changes
        educationGrade: null, // Clear grade when system changes
        availableGrades: const [], // Clear available grades
        signupStep: 4,
      ),
    );
    _saveSignupStateToCache();
  }

  void selectStage(String stage) {
    final grades = GradeUtils.getGradesForStage(stage);
    emit(
      state.copyWith(
        educationStage: stage,
        availableGrades: grades,
        educationGrade: null, // Clear old grade when stage changes
        signupStep: 5,
      ),
    );
    _saveSignupStateToCache();
  }

  void selectGrade(String grade) {
    emit(state.copyWith(educationGrade: grade));
    _saveSignupStateToCache();
  }

  // API Calls
  Future<void> sendOtp(String name, String phone) async {
    emit(state.copyWith(sendOtpStatus: SignupStatus.loading));
    final result = await sendOtpUseCase(
      SendOtpParams(name: name, phone: phone),
    );
    result.fold(
      (failure) {
        // Check if the error indicates phone is already registered
        // Be very specific - only check for clear indicators of duplicate/registered phone
        final errorMessage = failure.message.toLowerCase().trim();

        // Only consider it a registered phone error if the message clearly indicates it
        final isPhoneRegistered =
            // English patterns
            errorMessage.contains('phone number already exists') ||
            errorMessage.contains('phone already registered') ||
            errorMessage.contains('phone is already taken') ||
            errorMessage.contains('phone already exists') ||
            errorMessage.contains('phone number is already registered') ||
            errorMessage.contains('phone number already taken') ||
            (errorMessage.contains('phone') &&
                errorMessage.contains('already') &&
                (errorMessage.contains('exists') ||
                    errorMessage.contains('registered') ||
                    errorMessage.contains('taken'))) ||
            // Arabic patterns
            errorMessage.contains('الرقم مسجل') ||
            errorMessage.contains('الرقم موجود') ||
            errorMessage.contains('الرقم مكرر') ||
            errorMessage.contains('رقم الهاتف مسجل') ||
            errorMessage.contains('رقم الهاتف موجود') ||
            (errorMessage.contains('رقم') &&
                (errorMessage.contains('مسجل') ||
                    errorMessage.contains('موجود') ||
                    errorMessage.contains('مكرر')));

        final displayMessage = isPhoneRegistered
            ? Strings.phoneAlreadyRegistered
            : failure.message;

        emit(
          state.copyWith(
            sendOtpStatus: SignupStatus.error,
            errorMessage: displayMessage,
          ),
        );
      },
      (_) => emit(
        state.copyWith(
          sendOtpStatus: SignupStatus.success,
          phone: phone, // Store phone for verification
        ),
      ),
    );
  }

  Future<void> verifyOtp(
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    if (state.phone == null) {
      emit(
        state.copyWith(
          verifyOtpStatus: SignupStatus.error,
          errorMessage: "رقم الهاتف مفقود",
        ),
      );
      return;
    }
    // Clear previous error
    emit(
      state.copyWith(verifyOtpStatus: SignupStatus.loading, errorMessage: null),
    );
    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        phone: state.phone!,
        otp: otp,
        deviceToken: deviceToken,
        deviceLabel: deviceLabel,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          verifyOtpStatus: SignupStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (token) => emit(
        state.copyWith(
          verifyOtpStatus: SignupStatus.success,
          errorMessage: null,
        ),
        // Token is already stored in repository, no need to store here
      ),
    );
  }

  void clearSendOtpError() {
    if (state.sendOtpStatus == SignupStatus.error) {
      emit(
        state.copyWith(sendOtpStatus: SignupStatus.initial, errorMessage: null),
      );
    }
  }

  void clearVerifyOtpError() {
    if (state.verifyOtpStatus == SignupStatus.error) {
      emit(
        state.copyWith(
          verifyOtpStatus: SignupStatus.initial,
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required String parentPhone,
    String? schoolName,
    String? governorate,
  }) async {
    emit(state.copyWith(status: SignupStatus.loading));
    final result = await signupUseCase(
      SignupParams(
        username: username,
        email: email,
        password: password,
        parentPhone: parentPhone,
        schoolName: schoolName,
        governorate: governorate,
        educationSystem: state.educationSystem,
        educationStage: state.educationStage,
        educationGrade: state.educationGrade,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: SignupStatus.success,
          user: user,
          // Preserve education data after signup
          educationSystem: state.educationSystem,
          educationStage: state.educationStage,
          educationGrade: state.educationGrade,
        ),
      ),
    );
  }

  // Complete Step 2: Guardian info, school, governorate
  Future<void> completeStep2({
    required String email,
    required String guardianPhone,
    String? secondGuardianPhone,
    required String schoolName,
    required String governorate,
  }) async {
    emit(
      state.copyWith(
        completeStep2Status: SignupStatus.loading,
        errorMessage: null, // Clear previous error
      ),
    );
    final result = await completeStep2UseCase(
      CompleteStep2Params(
        email: email,
        guardianPhone: guardianPhone,
        secondGuardianPhone: secondGuardianPhone,
        schoolName: schoolName,
        governorate: governorate,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          completeStep2Status: SignupStatus.error,
          errorMessage: failure.message,
          // Preserve signupStep on error - don't revert
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            completeStep2Status: SignupStatus.success,
            errorMessage: null, // Clear error on success
            signupStep:
                3, // Move to step 3 (categories) - MUST be set together with success
          ),
        );
        // Load categories immediately when step 3 is reached
        // This will use cache-first strategy (fast if cached, fetch if not)
        getCategories();
      },
    );
  }

  // Get Categories with cache-first strategy
  Future<void> getCategories({bool silent = false}) async {
    // Prevent duplicate calls
    if (_isFetchingCategories) return;
    _isFetchingCategories = true;

    final stopwatch = Stopwatch()..start();

    // Only show loading if we don't have cached data and not silent mode
    final hasCachedData = state.categories.isNotEmpty;
    if (!hasCachedData && !silent) {
      emit(
        state.copyWith(
          getCategoriesStatus: SignupStatus.loading,
          errorMessage: null,
        ),
      );
    }

    final result = await getCategoriesUseCase(NoParams());
    stopwatch.stop();
    _isFetchingCategories = false;

    result.fold(
      (failure) {
        // If we have cached data and remote fails, keep showing cached data
        if (hasCachedData || silent) {
          // Don't emit error - keep cached data visible or silent load
          return;
        }
        emit(
          state.copyWith(
            getCategoriesStatus: SignupStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (categories) {
        // If data returned very quickly (< 100ms), it's likely from cache
        final isFromCache =
            stopwatch.elapsedMilliseconds < 100 || hasCachedData;

        emit(
          state.copyWith(
            categories: categories,
            getCategoriesStatus: silent || isFromCache
                ? SignupStatus.cached
                : SignupStatus.success,
            isCategoriesFromCache: isFromCache,
            errorMessage: null,
          ),
        );

        // Try to restore category selection from cache if categories are now loaded
        _tryRestoreCategorySelectionFromCache();

        // If data was from cache, refresh in background
        if (isFromCache) {
          _refreshCategoriesInBackground();
        }
      },
    );
  }

  // Background refresh for categories
  Future<void> _refreshCategoriesInBackground() async {
    // Prevent duplicate background refreshes
    if (_isRefreshingCategories) return;
    _isRefreshingCategories = true;

    final result = await getCategoriesUseCase(NoParams());
    result.fold(
      (_) {
        // Silently fail - don't update state on background refresh failure
      },
      (categories) {
        // Only update if data is different
        if (categories.length != state.categories.length ||
            categories.any((cat) => !state.categories.contains(cat))) {
          emit(
            state.copyWith(
              categories: categories,
              getCategoriesStatus: SignupStatus.success,
              isCategoriesFromCache: false,
            ),
          );
        }
      },
    );
  }

  // Get Category Children with cache-first strategy
  Future<void> getCategoryChildren(int categoryId) async {
    final stopwatch = Stopwatch()..start();

    // Always show loading when fetching children (even if cached, to show feedback)
    emit(state.copyWith(getCategoryChildrenStatus: SignupStatus.loading));

    // Check if we already have children for this category
    final hasCachedChildren =
        state.selectedCategoryChildren.isNotEmpty &&
        state.selectedCategory?.id == categoryId;

    final result = await getCategoryChildrenUseCase(
      GetCategoryChildrenParams(categoryId: categoryId),
    );
    stopwatch.stop();

    result.fold(
      (failure) {
        // If we have cached data and remote fails, keep showing cached data
        if (hasCachedChildren) {
          // Don't emit error - keep cached data visible
          return;
        }
        emit(
          state.copyWith(
            getCategoryChildrenStatus: SignupStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (children) {
        // If data returned very quickly (< 100ms), it's likely from cache
        final isFromCache =
            stopwatch.elapsedMilliseconds < 100 || hasCachedChildren;

        emit(
          state.copyWith(
            selectedCategoryChildren: children,
            getCategoryChildrenStatus: isFromCache
                ? SignupStatus.cached
                : SignupStatus.success,
            signupStep: 4, // Show children selection - moving forward is OK
          ),
        );
        _saveSignupStateToCache();

        // If data was from cache, refresh in background
        if (isFromCache) {
          _refreshCategoryChildrenInBackground(categoryId);
        }
      },
    );
  }

  // Background refresh for category children
  Future<void> _refreshCategoryChildrenInBackground(int categoryId) async {
    final result = await getCategoryChildrenUseCase(
      GetCategoryChildrenParams(categoryId: categoryId),
    );
    result.fold(
      (_) {
        // Silently fail - don't update state on background refresh failure
      },
      (children) {
        // Only update if data is different
        if (children.length != state.selectedCategoryChildren.length ||
            children.any(
              (child) => !state.selectedCategoryChildren.contains(child),
            )) {
          emit(
            state.copyWith(
              selectedCategoryChildren: children,
              getCategoryChildrenStatus: SignupStatus.success,
            ),
          );
        }
      },
    );
  }

  // Get Governorates with cache-first strategy
  Future<void> getGovernorates({bool silent = false}) async {
    // Prevent duplicate calls
    if (_isFetchingGovernorates) return;
    _isFetchingGovernorates = true;

    final stopwatch = Stopwatch()..start();

    // Only show loading if we don't have cached data and not silent mode
    final hasCachedData = state.governorates.isNotEmpty;
    if (!hasCachedData && !silent) {
      emit(state.copyWith(getGovernoratesStatus: SignupStatus.loading));
    }

    final result = await getGovernoratesUseCase(NoParams());
    stopwatch.stop();
    _isFetchingGovernorates = false;

    result.fold(
      (failure) {
        // If we have cached data and remote fails, keep showing cached data
        if (hasCachedData || silent) {
          // Don't emit error - keep cached data visible or silent load
          return;
        }
        emit(
          state.copyWith(
            getGovernoratesStatus: SignupStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (governorates) {
        // If data returned very quickly (< 100ms), it's likely from cache
        final isFromCache =
            stopwatch.elapsedMilliseconds < 100 || hasCachedData;

        emit(
          state.copyWith(
            governorates: governorates,
            getGovernoratesStatus: silent || isFromCache
                ? SignupStatus.cached
                : SignupStatus.success,
            isGovernoratesFromCache: isFromCache,
            errorMessage: null, // Clear error message on success
          ),
        );

        // If data was from cache, refresh in background
        if (isFromCache) {
          _refreshGovernoratesInBackground();
        }
      },
    );
  }

  // Background refresh for governorates
  Future<void> _refreshGovernoratesInBackground() async {
    // Prevent duplicate background refreshes
    if (_isRefreshingGovernorates) return;
    _isRefreshingGovernorates = true;

    final result = await getGovernoratesUseCase(NoParams());
    result.fold(
      (_) {
        // Silently fail - don't update state on background refresh failure
      },
      (governorates) {
        // Only update if data is different
        if (governorates.length != state.governorates.length ||
            governorates.any((gov) => !state.governorates.contains(gov))) {
          emit(
            state.copyWith(
              governorates: governorates,
              getGovernoratesStatus: SignupStatus.success,
              isGovernoratesFromCache: false,
            ),
          );
        }
      },
    );
    _isRefreshingGovernorates = false;
  }

  // Select Category (parent category, then fetch children from API)
  void selectCategory(dynamic category) {
    // category can be CategoryEntity or int (id)
    CategoryEntity? selected;
    if (category is int) {
      selected = state.categories.firstWhere(
        (cat) => cat.id == category,
        orElse: () => state.categories.first,
      );
    } else if (category is CategoryEntity) {
      selected = category;
    }

    if (selected != null) {
      // Clear previous children selection to show loading when switching categories
      emit(
        state.copyWith(
          selectedCategory: selected,
          selectedCategoryChildren: const [], // Clear children to force loading
          // Preserve signupStep - never override it
        ),
      );
      _saveSignupStateToCache();
      // Fetch children from API instead of using local children
      getCategoryChildren(selected.id);
    }
  }

  // Complete Step 3: Select final category (child category)
  Future<void> completeStep3(int categoryId) async {
    emit(
      state.copyWith(
        completeStep3Status: SignupStatus.loading,
        // Preserve signupStep - never override it
      ),
    );
    final result = await completeStep3UseCase(
      CompleteStep3Params(categoryId: categoryId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          completeStep3Status: SignupStatus.error,
          errorMessage: failure.message,
          // Preserve signupStep - never override it on error
        ),
      ),
      (_) => emit(
        state.copyWith(
          completeStep3Status: SignupStatus.success,
          status: SignupStatus.success, // Registration complete
          // Preserve signupStep - never override it
        ),
      ),
    );
  }
}
