# Flutter CRUD Demo

This project is a Flutter application that demonstrates a simple CRUD (Create, Read, Update, Delete) functionality for managing users, products, and categories. 

## Project Structure

- **android/**: Contains the Android-specific files and configurations.
  - **app/**: Contains the Gradle build configuration and source files for the Android app.
  - **src/**: Contains the main source files for the Android application.
  
- **ios/**: Contains the iOS-specific files and configurations.
  - **Runner/**: Contains the iOS app's configuration settings and project files.

- **lib/**: Contains the main Dart code for the Flutter application.
  - **main.dart**: The entry point of the application.
  - **providers/**: Contains provider classes for state management.
  - **screens/**: Contains various screen widgets for the app.
  - **models/**: Contains data models used throughout the application.
  - **services/**: Contains service classes for handling business logic and API calls.

- **test/**: Contains widget tests for the Flutter application.

- **pubspec.yaml**: The configuration file for the Flutter project, specifying dependencies and assets.

- **pubspec.lock**: Locks the versions of the dependencies used in the project.

## Features

- User authentication (login and registration)
- CRUD operations for users, products, and categories
- Responsive UI with navigation using GoRouter

## Setup Instructions

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd flutter-app
   ```

3. Install the dependencies:
   ```
   flutter pub get
   ```

4. Run the application:
   ```
   flutter run
   ```

## Usage

- To access the application, use the login screen to authenticate or register a new user.
- Once logged in, you can navigate to the home screen and manage users, products, and categories.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or features you'd like to add.