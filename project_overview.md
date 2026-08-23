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
- **UI**: `liquid_glass_widgets` (iOS 26-style liquid glass) — "net cam" (blur 0, şeffaf glassColor) presets, `LiquidGlassWidgets.wrap()` ile global glass theme.
- **Architecture**: The project follows a service-oriented architecture where functionalities are separated into different services (e.g., `AuthService`, `FirebaseService`, `UserService`). The UI (View) is separated from the business logic.

## 5. Project Structure

```
EventizerFlutterApp/
├── lib/
│   ├── assets/         # App-specific assets like colors
│   ├── components/     # Glass UI components (GlassActionButton, GlassInputField, GlassPasswordInput, MyLiquidGlass presets)
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

## 8. Recent Changes
- **Liquid glass UI geçişi**: `liquid_glass_renderer` kaldırıldı, `liquid_glass_widgets ^0.29.6` eklendi. `LiquidGlassWidgets.initialize()` + `wrap()` (adaptiveQuality, brightnessResolver, GlassThemeData blur 0) `main.dart`'ta kuruldu.
- **Net cam presets**: `MyLiquidGlass` (lib/components/liquidglass_widgets.dart) — katalog projesindeki `kClearGlass*` değerleriyle: blur 0, şeffaf glassColor, rim/refraction vurgulu (standard, interactive, overlay, input, button).
- **Yeni glass component'leri**: `GlassActionButton` (GestureDetector + GlassContainer, Material/InkWell yok), `GlassInputField`, `GlassPasswordInput` (kilit + göz ikonları beyaz, label destekli).
- **Login/Register yeniden yazıldı**: component tabanlı mimari, koyu lacivert zemin (kDarkBackdrop) + cyan/mor glow küreleri + `login_background.jpg`, etiketli alanlar, metinler olabildiğince beyaz (koyu tema).
- **Paket güncellemeleri**: firebase_* serisi, dropdown_search 6→7 (`onChanged`→`onSelected`), font_awesome 10→11, package_info_plus 9→10.2.1, fluttertoast 10, sizer 3.1.3 vb. (`intl` 0.19.0'da kaldı — dash_chat_2 kısıtı).
- **Glass input focus düzeltmesi**: `GlassTextField`'ın dokunma hedefi yalnızca içteki dar `CupertinoTextField` olduğu için cam boşluğuna dokununca klavye açılmıyordu. `GlassInputField`/`GlassPasswordInput` artık kendi `FocusNode`'unu pakete verip alanı `GestureDetector(HitTestBehavior.opaque, onTap: requestFocus)` ile sarıyor — camın herhangi bir yerine dokununca alan focus alıyor (metin üstü imleç konumlama ve göz ikonu davranışı korunuyor).
- **Login sayfası overflow düzeltmesi**: `resizeToAvoidBottomInset: true` açıldı; başlık + form bloğu `Expanded > SingleChildScrollView` içine alındı (Password Reset modundaki ek satırlar ve klavye açılınca RenderFlex overflow yaşanmaz), butonlar altta sabit kaldı.
- **Login chip'leri**: "Forgot Password?" yalnızca login modunda, "Already have an account?" yalnızca reset modunda görünür — iki chip'in üst üste binip buton arkasında kalması engellendi.
- **Login başlığı belirginleştirildi**: "Password Reset"/"Welcome Back" metni Zona w600 + 16.sp + güçlü gölge ile okunur hale getirildi.