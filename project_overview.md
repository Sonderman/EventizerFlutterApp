# Eventizer Project Overview

## 1. Project Name
**Eventizer**

## 2. Description
A Flutter-based mobile application that allows users to create, discover, and join various social events. The application provides a platform for users to connect with others who share similar interests by participating in a wide range of activities.

## 3. Core Functionalities
- **User Authentication**: Secure sign-up, login, and password reset functionality using Firebase Authentication.
- **Event Creation**: Users can create detailed events, specifying title, description, location, date, time, category, and an event image.
- **Event Discovery**: An "Explore" page where users can find events created by others.
- **Event Participation**: Users can join and leave events.
- **User Profiles**: View and edit user profiles, including profile picture, personal details, and a list of created/joined events.
- **Social Features**: Follow/unfollow other users.
- **Chat**: In-app chat functionality for users to communicate, likely within events.
- **Event Management**: Users can manage the events they have created (e.g., view participants, finish, or delete the event).

## 4. Tech Stack & Architecture
- **Framework**: Flutter
- **Backend**: Firebase (Authentication, Firestore Database, Storage, Analytics, Crashlytics)
- **State Management**: A combination of `Provider` for dependency injection of services, `Get` (GetX) for route management, and `GetIt` as a service locator.
- **Architecture**: The project follows a service-oriented architecture where functionalities are separated into different services (e.g., `AuthService`, `FirebaseService`, `UserService`). The UI (View) is separated from the business logic.

## 5. Project Structure

```
EventizerFlutterApp/
├── lib/
│   ├── assets/         # App-specific assets like colors
│   ├── controllers/    # GetX controllers
│   ├── models/         # Data models (UserModel, Event)
│   ├── navigation/     # UI screens/pages
│   ├── routes/         # GetX route configuration
│   ├── services/       # Business logic (Auth, Firebase, Repository)
│   ├── settings/       # Application settings
│   ├── tools/          # UI components and utility widgets
│   ├── utils/          # Utility functions
│   ├── main.dart       # App entry point
│   └── locator.dart    # GetIt service locator setup
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── images/
└── pubspec.yaml        # Dependencies and project configuration
```

## 6. Data Models

### User Model (`UserModel`)
Represents a user in the application.
- `userID` (String)
- `name` (String)
- `surname` (String)
- `nickname` (String)
- `email` (String)
- `telNo` (int)
- `birthday` (String)
- `city` (String)
- `gender` (String)
- `about` (String)
- `profilePhotoUrl` (String)
- `numberOfFollowers` (int)
- `numberOfFollowings` (int)
- `numberOfEvents` (int)
- `numberOfTrustPoints` (int)

### Event Model
While there is a basic `Event` class, the application primarily uses a `Map<String, dynamic>` to handle event data. Based on the `create_event_page.dart`, an event has the following structure:
- **Title** (String)
- **Detail** (String)
- **Location** (String)
- **City** (String)
- **Country** (String)
- **Participant Number** (int)
- **Category** (String)
- **Sub-category** (String)
- **Start Date** (String)
- **Start Time** (String)
- **Finish Date** (String)
- **Finish Time** (String)
- **Image URL** (String)
- **Organizer ID** (String)
- **Opposite Gender Only** (bool)

## 7. Setup
1. Ensure you have Flutter SDK installed.
2. Configure a Firebase project and place the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) in the appropriate directories.
3. Run `flutter pub get` to install dependencies.
4. Run `flutter run` to start the application. 