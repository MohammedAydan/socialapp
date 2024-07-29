# SocialApp

A new SOCIAL project built using Flutter.

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

Ensure you have the following installed on your machine:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with Flutter and Dart plugins
- A code editor of your choice (e.g., VS Code, Android Studio)

### Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/MohammedAydan/socialapp.git
    ```
2. **Navigate to the project directory:**
    ```sh
    cd socialapp
    ```
3. **Get the dependencies:**
    ```sh
    flutter pub get
    ```

### Running the App

1. **Connect a device or start an emulator.**
2. **Run the app:**
    ```sh
    flutter run
    ```

## Project Structure

    ├── android                          # Android-specific files
    ├── ios                              # iOS-specific files
    ├── lib                              # Main Dart codebase
    │   ├── main.dart                    # Entry point of the app
    │   ├── local_notifications.dart     # Local notifications configuration
    │   ├── onesignal_notification.dart  # OneSignal notification configuration
    │   ├── api                          # API-related files
    │   ├── common                       # Common resources
    │   ├── core                         # Core functionality
    │   ├── di                           # Dependency Injection
    │   │   └── di.dart
    │   ├── features                     # Features of the app
    │   │   └── auth                     # Authentication feature
    │   │       ├── controllers          # Authentication controllers
    │   │       ├── models               # Authentication models
    │   │       ├── pages                # Authentication pages
    │   │       └── services             # Authentication services
    │   │           ├── repositories     # Service repositories
    │   │           └── implementation   # Service implementations
    │   ├── global                       # Global screens
    │   ├── widgets                      # Custom widgets
    ├── pubspec.yaml                     # Project dependencies and assets

  <!--   └── README.md              # Project documentation -->

## Useful Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

For more help with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request for any changes you would like to make.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions or suggestions, feel free to reach out:

- [Mohammed Aydan](https://github.com/MohammedAydan)
- [mohammedaydan@gmail.com](mailto:mohammedaydan@gmail.com)
