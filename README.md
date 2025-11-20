# pokemon_explorer

A new Flutter project for exploring pokemon.


## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Testing](#-testing)
- [Offline Mode](#-offline-mode)

---

## ✨ Features

### Core Features
- ✅ **Paginated Pokemon List** - Infinite scroll with 20 items per page
- ✅ **Pokemon Detail View** - Complete stats, abilities, types, and images
- ✅ **Offline-First Architecture** - Works seamlessly without internet
- ✅ **Pull-to-Refresh** - Manual data synchronization
- ✅ **Image Optimization** - Resized, compressed, and cached images
- ✅ **Smooth Scrolling** - Optimized performance with lazy loading
- ✅ **Error Handling** - Comprehensive error states and retry mechanisms
- ✅ **Loading States** - Skeleton screens and progress indicators

### Technical Features
- 🏗️ **Clean Architecture** - Separation of concerns with 3 layers
- 🔄 **BLoC Pattern** - Predictable state management
- 💾 **Local Database** - Drift (SQLite) for offline caching
- 🖼️ **Image Processing** - Background image optimization with isolates
- 🌐 **Network Layer** - Dio with interceptors and retry logic
- 📱 **Responsive UI** - Works on various screen sizes
- 🧪 **Unit Tested** - 80%+ code coverage

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC** for state management:
```
┌─────────────────────────────────────────────────────┐
│                  Presentation Layer                 │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐  │
│  │   UI/Pages   │  │  BLoC/Events │  │   State   │  │
│  └──────────────┘  └──────────────┘  └───────────┘  │
└─────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                   Domain Layer                      │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐  │
│  │   Entities   │  │  Use Cases   │  │ Repository│  │
│  │              │  │              │  │ Interface │  │
│  └──────────────┘  └──────────────┘  └───────────┘  │
└─────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                    Data Layer                       │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐  │
│  │    Models    │  │ Data Sources │  │ Repository│  │
│  │              │  │ (API/Cache)  │  │   Impl    │  │
│  └──────────────┘  └──────────────┘  └───────────┘  │
└─────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

#### 1. **Clean Architecture Layers**
- **Presentation**: UI components, BLoCs, and state management
- **Domain**: Business logic, entities, and use cases
- **Data**: API calls, database operations, and repository implementations

#### 2. **BLoC Pattern**
- Events trigger business logic
- BLoCs emit states that UI observes
- Separation of business logic from UI

#### 3. **Offline-First Strategy**
- Check cache first before network calls
- Store all fetched data locally
- 24-hour cache validity
- Seamless offline mode

#### 4. **Image Optimization**
- Resize to appropriate dimensions (128x128, 256x256, 512x512)
- Compress to JPEG at 80-85% quality
- Process in isolates to prevent UI blocking
- Cache optimized images locally

---

## 🛠️ Tech Stack

### Core Technologies
| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | 3.35+   | UI Framework |
| Dart | 3.9+    | Programming Language |
| flutter_bloc | ^9.1.1  | State Management |
| get_it | ^9.0.5  | Dependency Injection |
| dio | ^5.9.0  | HTTP Client |
| drift | ^2.29.0 | Local Database (SQLite) |

### Key Packages
```yaml
dependencies:
  # State Management
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7

  # Dependency Injection
  get_it: ^9.0.5
  injectable: ^2.6.0

  # Network
  dio: ^5.9.0
  connectivity_plus: ^7.0.0

  # Local Database
  drift: ^2.29.0
  sqlite3_flutter_libs: ^0.5.40
  path_provider: ^2.1.5
  path: ^1.9.1

  # Image Processing
  image: ^4.5.4
  cached_network_image: ^3.4.1

  # Utilities
  dartz: ^0.10.1
  intl: ^0.20.2
  pull_to_refresh: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  bloc_test: ^10.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.7
  drift_dev: ^2.29.0
  injectable_generator: ^2.8.1
```

---


## 🚀 Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Prerequisites

- Flutter SDK: `>=3.35.6`
- Dart SDK: `>=3.9.2`
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/kmlinn5254/pokemon_explorer.git
cd pokemon_explorer
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate required files**
```bash
# Generate mocks for testing
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

---

## 📁 Project Structure

lib/
├── core/
│   ├── constants/         # App constants (Currently there is no files yet)
│   ├── database/          # Drift database setup
│   ├── error/             # Error handling (failures, exceptions)
│   ├── network/           # Network info & connectivity
│   ├── services/          # Image optimization service
│   ├── usecases/          # Base use case class
│   └── utils/             # Utility functions (Currently there is no files yet)
│
├── features/
│   └── pokemon/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── pokemon_local_datasource.dart
│       │   │   └── pokemon_remote_datasource.dart
│       │   ├── models/
│       │   │   ├── pokemon_detail_model.dart
│       │   │   └── pokemon_model.dart
│       │   └── repositories/
│       │       └── pokemon_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── pokemon.dart
│       │   │   └── pokemon_detail.dart
│       │   ├── repositories/
│       │   │   └── pokemon_repository.dart
│       │   └── usecases/
│       │       ├── get_pokemon_detail_use_case.dart
│       │       ├── get_pokemon_list_use_case.dart
│       │       └── refresh_pokemon_list_use_case.dart
│       │
│       └── presentation/
│           ├── bloc/
│           │   ├── pokemon_detail/
│           │   │   ├── pokemon_detail_bloc.dart
│           │   │   ├── pokemon_detail_event.dart
│           │   │   └── pokemon_detail_state.dart
│           │   └── pokemon_list/
│           │       ├── pokemon_list_bloc.dart
│           │       ├── pokemon_list_event.dart
│           │       └── pokemon_list_state.dart
│           ├── pages/
│           │   ├── pokemon_detail_page.dart
│           │   └── pokemon_list_page.dart
│           └── widgets/
│               ├── pokemon_ability_card.dart
│               ├── pokemon_card.dart
│               ├── pokemon_stats_widget.dart
│               └── pokemon_type_chip.dart
│
├── di_service.dart   # GetIt DI configuration
└── main.dart                   # App entry point

test/
├── core/
│   └── services/
│       └── image_optimization_service_test.dart
├── features/
│   └── pokemon/
│       ├── data/
│       │   └── repositories/
│       │       └── pokemon_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       ├── get_pokemon_detail_use_case_test.dart
│       │       ├── get_pokemon_list_use_case_test.dart
│       │       └── refresh_pokemon_list_use_case_test.dart
│       └── presentation/
│           └── bloc/
│               ├── pokemon_detail_bloc_test.dart
│               └── pokemon_list_bloc_test.dart
├── mocks/
│   ├── mock_config.dart        # Mock generation config
│   └── mock_config.mocks.dart  # Generated mocks
└── test_helper.dart            # Test utilities


---

🧪 Testing
Running Tests
bash# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/pokemon/domain/usecases/get_pokemon_list_test.dart


Viewing Coverage Report
bash# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html

# Or use Makefile
make coverage-open

Generating Mocks
bash# Generate mocks for testing
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch --delete-conflicting-outputs


---

## 📴 Offline Mode

### How It Works

The app implements a **cache-first strategy** for optimal offline experience:

1. **Data Flow**
```
   UI Request → Check Local Cache → Return if Valid
                      ↓
                  Check Network
                      ↓
               Fetch from API → Cache Locally → Return to UI
```

2. **Cache Strategy**
    - All fetched Pokemon data is cached in SQLite database
    - Cache validity: **24 hours**
    - Offline indicator displayed when using cached data
    - Auto-sync when network returns

3. **Offline Features**
    - ✅ Browse previously loaded Pokemon
    - ✅ View detailed Pokemon information
    - ✅ Scroll through cached lists
    - ✅ View cached images
    - ❌ Load new Pokemon (requires network)
    - ❌ Refresh data (requires network)

### Testing Offline Mode

1. **Enable Airplane Mode** on device/simulator
2. **Open the app** - previously loaded data will be available with offline indicator
3. **Pull to refresh** - app will show network connection required
4. **Browse cached Pokemon** - all works seamlessly
5. **Disable Airplane Mode** - app auto-syncs new data

---


🚀 Build & Release
Android
bash# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Install APK on device
flutter install


iOS
bash# Build iOS
flutter build ios --release