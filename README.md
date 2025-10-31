# Weather App

A Flutter weather application demonstrating clean architecture principles and modern best practices for mobile development.

## Features

- **User Authentication**: Simple email/password authentication with session management
- **Real-time Weather Data**: Fetches current weather information based on device location
- **Offline Support**: Caches weather data for offline access
- **Pull-to-Refresh**: Manually refresh weather data
- **Auto-Refresh**: Automatically updates weather every 15 minutes
- **Location Services**: Automatically detects user location for weather information
- **Responsive Design**: Adapts to different screen sizes (mobile, tablet, desktop)
- **Form Validation**: Comprehensive password requirements with visibility toggle
- **Error Handling**: Graceful error handling with user-friendly messages

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Shared infrastructure
│   ├── config/             # App configuration and routes
│   ├── di/                 # Dependency injection setup
│   ├── interfaces/         # Abstract interfaces
│   ├── mixins/             # Reusable mixins
│   └── services/           # Core services (HTTP, Storage, Location)
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Repositories
│   │   ├── domain/        # Entities
│   │   └── presentation/  # UI & State management
│   └── weather/           # Weather feature
│       ├── data/          # Repositories
│       ├── domain/        # Entities
│       └── presentation/  # UI & State management
└── shared/                # Shared utilities
```

### Key Patterns

- **Clean Architecture**: Separation of domain, data, and presentation layers
- **BLoC/Cubit**: State management using flutter_bloc
- **Repository Pattern**: Abstraction of data sources
- **Dependency Injection**: Using Provider for DI
- **Interface Segregation**: Abstract interfaces for testability
- **Singleton Pattern**: For storage and configuration

## Tech Stack

- **Flutter**: 3.35.7 (managed via FVM)
- **State Management**: flutter_bloc ^9.1.1
- **Dependency Injection**: provider ^6.1.5
- **HTTP Client**: dio ^5.9.0
- **Local Storage**: shared_preferences ^2.5.3
- **Location Services**: geolocator ^14.0.2
- **Form Validation**: validatorless ^1.2.5
- **Testing**: mocktail ^1.0.4, bloc_test ^10.0.0

## Prerequisites

- [FVM (Flutter Version Manager)](https://fvm.app/) (recommended) or Flutter SDK 3.35.7+
- OpenWeatherMap API key ([Get one here](https://openweathermap.org/api))

## Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd weather
   ```

2. **Install Flutter version** (if using FVM)

   ```bash
   # FVM will automatically use the version specified in .fvmrc (3.35.7)
   fvm install
   fvm use
   ```

   If not using FVM, ensure you have Flutter 3.35.7 or higher installed.

3. **Install dependencies**

   ```bash
   # With FVM
   fvm flutter pub get

   # Without FVM
   flutter pub get
   ```

4. **Configure environment variables**

   - Copy `.env.example` to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Sign up at [OpenWeatherMap](https://openweathermap.org/api)
   - Get your free API key
   - Edit `.env` and add your API key:
     ```
     OPENWEATHER_API_KEY=your_actual_api_key_here
     ```

5. **Run the app**

   ```bash
   # With FVM
   fvm flutter run --dart-define-from-file=.env

   # Without FVM
   flutter run --dart-define-from-file=.env

   # Or simply run from VS Code (launch.json is already configured)
   ```

## Configuration

### VS Code Launch Configuration

The repository includes `.vscode/launch.json` with three configurations:

- **weather**: Standard debug mode
- **weather (profile mode)**: Profile mode for performance testing
- **weather (release mode)**: Release mode

All configurations are pre-configured to use `--dart-define-from-file=.env` to load your API key.

**Note**: If using FVM, ensure you have the FVM VS Code extension installed and configured to use the project's Flutter SDK version.

### Android Permissions

The app requires location permissions. These are already configured in:

- `android/app/src/main/AndroidManifest.xml`

### iOS Permissions

Location usage description is configured in:

- `ios/Runner/Info.plist`

## Running Tests

```bash
# Run all tests
fvm flutter test        # With FVM
flutter test            # Without FVM

# Run tests with coverage
fvm flutter test --coverage
flutter test --coverage

# Run specific test file
fvm flutter test test/features/auth/presentation/auth_cubit_test.dart
flutter test test/features/auth/presentation/auth_cubit_test.dart
```

## Project Structure Details

### Core Layer

- **interfaces/**: Abstract contracts (LocalStorage, RestClient)
- **services/**: Implementations (DioRestClient, SharedPreferencesStorage, LocationService)
- **di/**: Dependency injection setup with Provider

### Features Layer

- **auth/**: User authentication and session management
- **weather/**: Weather data fetching and display

### Data Flow

1. UI triggers action (e.g., login, fetch weather)
2. Cubit/Bloc handles business logic
3. Repository coordinates data sources
4. Services handle API calls and local storage
5. Data flows back up to UI

## Security Considerations

### API Key Exposure

⚠️ **Important**: For production web builds, API keys loaded via `--dart-define-from-file` are exposed in the JavaScript bundle. For production applications, you should:

1. **Use a Backend Proxy**: Create a backend service to handle API calls

   ```
   Mobile App → Your Backend → OpenWeatherMap API
   ```

2. **Implement Rate Limiting**: Prevent API abuse on your backend

3. **Use Environment-Specific Keys**: Different keys for dev/staging/prod

4. **Example Backend Approach**:

   ```
   // Your backend endpoint
   GET /api/weather?lat=40.7128&lon=-74.0060

   // Backend internally calls OpenWeatherMap
   // with API key stored securely in environment variables
   ```

For mobile-only deployments (Android/iOS), the `.env` approach is reasonably secure as the values are compiled into the binary and harder to extract than web bundles.

**Note**: The `.env` file is already in `.gitignore` to prevent accidental commits of sensitive data.

## Login Credentials

The app accepts any email/password combination that meets the validation requirements:

**Password Requirements:**

- At least 6 characters
- At least 1 uppercase letter (A-Z)
- At least 1 lowercase letter (a-z)
- At least 1 number (0-9)
- At least 1 special character (!@#$%^&\*(),.?":{}|<>)

**Example**: `test@example.com` / `Password123!`

## Features in Detail

### Authentication

- Session-based authentication using local storage
- Persistent login across app restarts
- Automatic logout on session expiry
- Protected routes with auth middleware

### Weather Display

- Current temperature and feels-like temperature
- Weather description and icon
- Humidity and wind speed
- Sunrise and sunset times
- City/location name
- Last updated timestamp
- Automatic background refresh every 15 minutes

### Offline Support

- Weather data cached locally
- Shows cached data when offline
- Visual indicator when showing cached data
- Automatic retry when connection restored

### Error Handling

- Network errors with user-friendly messages
- Location permission handling
- API rate limiting detection
- Graceful degradation with cached data

## Known Limitations

1. **Authentication**: Currently uses local storage for authentication. For production use, integrate with a real authentication backend (e.g., Firebase Auth, OAuth, etc.)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using Flutter**
