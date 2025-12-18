# Cache-First Strategy Implementation

This document describes the cache-first data loading strategy implemented in the application.

## Overview

The application now uses a **cache-first strategy** with Hive for local storage, providing:

- ⚡ **Instant UI updates** when cached data is available
- 🔄 **Background refresh** to keep data fresh
- 📱 **Offline support** with cached data fallback
- 🎨 **Shimmer loading** for better UX

## Architecture

The implementation follows **Clean Architecture** principles:

```
Presentation Layer (Cubit)
    ↓
Domain Layer (Use Cases)
    ↓
Data Layer
    ├── Repository (Cache-First Logic)
    ├── RemoteDataSource (API)
    └── LocalDataSource (Hive Cache)
```

## Key Components

### 1. Local Data Source (`AuthLocalDataSource`)

**Location**: `lib/features/auth/data/datasources/auth_local_data_source.dart`

Interface for local data operations:

- `getCachedCategories()` - Get cached categories
- `cacheCategories()` - Save categories to cache
- `getCachedGovernorates()` - Get cached governorates
- `cacheGovernorates()` - Save governorates to cache
- Similar methods for category children and user data

**Implementation**: `AuthLocalDataSourceImpl` uses Hive boxes to store JSON-encoded data.

### 2. Repository (`AuthRepositoryImpl`)

**Location**: `lib/features/auth/data/repositories/auth_repository_impl.dart`

Implements cache-first strategy:

```dart
// Cache-first flow:
1. Check local cache
2. If cache exists:
   - Return cached data immediately
   - Fetch fresh data in background
   - Update cache if data changed
3. If no cache:
   - Fetch from remote
   - Cache the result
   - Return data
```

### 3. State Management (`AuthCubit`)

**Location**: `lib/features/auth/presentation/cubit/auth_cubit.dart`

- Emits `AuthStatus.cached` when data comes from cache
- Emits `AuthStatus.success` when fresh data arrives
- Only shows `AuthStatus.loading` when no cache exists
- Prevents duplicate API calls with internal flags

### 4. Hive Setup

**Location**: `lib/core/cache/hive_helper.dart`

- Initializes Hive in `main.dart` before `runApp()`
- Opens boxes for categories, governorates, and user data
- Uses JSON string storage (no type adapters needed)

## Usage Examples

### Using Shimmer Loading

```dart
import 'package:jesoor_pro/core/widgets/shimmer_loading.dart';

// Simple shimmer
ShimmerLoading(
  width: 200,
  height: 50,
  borderRadius: BorderRadius.circular(8),
)

// List shimmer
ShimmerList(
  itemCount: 5,
  itemHeight: 60,
)

// Card shimmer
ShimmerCard()
```

### Cache-Aware Loading Widget

```dart
import 'package:jesoor_pro/core/widgets/cache_aware_loader.dart';

CacheAwareLoader(
  status: state.getCategoriesStatus,
  child: CategoriesList(categories: state.categories),
  loadingWidget: ShimmerList(),
  errorWidget: ErrorWidget(message: state.errorMessage),
)
```

### Checking Cache Status

```dart
// In your widget
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state.getCategoriesStatus == AuthStatus.cached) {
      // Data is from cache, might be refreshing in background
      return Column(
        children: [
          CategoriesList(categories: state.categories),
          if (state.isCategoriesFromCache)
            Text('جاري التحديث...', style: TextStyle(fontSize: 12)),
        ],
      );
    }
    // ... handle other states
  },
)
```

## Data Preloading

Critical data (categories and governorates) is preloaded during splash screen:

**Location**: `lib/features/splash/splash_screen.dart`

- Preloads in background (non-blocking)
- Uses cache-first strategy
- Silently fails if preload fails (not critical)

## Performance Optimizations

1. **Duplicate Call Prevention**: Cubit uses flags to prevent multiple simultaneous API calls
2. **Background Refresh**: Fresh data fetched in background without blocking UI
3. **Smart Loading States**: Only shows loading when no cache exists
4. **Offline Support**: Returns cached data when network is unavailable

## Cache Management

### Clearing Cache

```dart
// In LocalDataSource
await localDataSource.clearAllCache();
await localDataSource.clearUser();
```

### Checking Cache Availability

```dart
final hasCategories = await localDataSource.hasCachedCategories();
final hasGovernorates = await localDataSource.hasCachedGovernorates();
```

## State Flow

```
User Action
    ↓
Cubit.getCategories()
    ↓
Repository.getCategories()
    ↓
[Cache Check]
    ├─ Cache exists → Return immediately (cached status)
    │                  ↓
    │              Background: Fetch fresh data
    │                  ↓
    │              Update cache if different
    │                  ↓
    │              Emit success if changed
    │
    └─ No cache → Fetch from remote
                      ↓
                  Cache result
                      ↓
                  Return (success status)
```

## Error Handling

- **Cache errors**: Silently fail (cache is not critical)
- **Network errors with cache**: Return cached data, don't show error
- **Network errors without cache**: Show error state
- **Background refresh errors**: Silently fail (doesn't affect UI)

## Testing Considerations

When testing:

1. Clear cache between tests: `await localDataSource.clearAllCache()`
2. Mock `LocalDataSource` to test cache-first logic
3. Test offline scenarios with cached data
4. Verify background refresh doesn't block UI

## Future Enhancements

- [ ] Add cache expiration (TTL)
- [ ] Implement cache invalidation strategies
- [ ] Add cache size limits
- [ ] Implement pagination caching
- [ ] Add cache analytics

## Dependencies Added

- `hive: ^2.2.3` - Local database
- `hive_flutter: ^1.1.0` - Flutter integration
- `shimmer: ^3.0.0` - Loading animations

## Notes

- Cache uses JSON string storage (no type adapters required)
- All cache operations are non-blocking
- Background refreshes are fire-and-forget
- Cache is automatically updated when fresh data arrives
