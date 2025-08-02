# GetX Routing Sistemi - Eventizer App

Bu dokümantasyon, Eventizer Flutter uygulamasına entegre edilen GetX routing sistemini açıklamaktadır.

## 📋 İçerik

- [Kurulum](#kurulum)
- [Dosya Yapısı](#dosya-yapısı)
- [Temel Kullanım](#temel-kullanım)
- [Navigation Utils](#navigation-utils)
- [Route Tanımları](#route-tanımları)
- [Controller Entegrasyonu](#controller-entegrasyonu)
- [Örnek Kullanımlar](#örnek-kullanımlar)

## 🚀 Kurulum

GetX routing sistemi şu dosyalar ile uygulamaya entegre edilmiştir:

### Eklenen Dosyalar:
- `lib/routes/app_routes.dart` - Route path tanımları
- `lib/routes/app_pages.dart` - GetPage tanımları ve binding'ler
- `lib/controllers/home_controller.dart` - Home sayfası controller'ı
- `lib/utils/navigation_utils.dart` - Navigation helper fonksiyonları
- `lib/tools/getx_bottom_navigation.dart` - GetX uyumlu bottom navigation
- `lib/examples/getx_routing_examples.dart` - Kullanım örnekleri

### Güncellenen Dosyalar:
- `lib/main.dart` - GetX routing yapılandırması
- `lib/navigation/home_page.dart` - GetX uyumlu hale getirildi

## 📁 Dosya Yapısı

```
lib/
├── routes/
│   ├── app_routes.dart          # Route path tanımları
│   └── app_pages.dart           # GetPage tanımları
├── controllers/
│   └── home_controller.dart     # Home controller
├── utils/
│   └── navigation_utils.dart    # Navigation helper'ları
├── tools/
│   └── getx_bottom_navigation.dart  # GetX bottom navigation
├── examples/
│   └── getx_routing_examples.dart   # Kullanım örnekleri
└── main.dart                    # GetX yapılandırması
```

## 🎯 Temel Kullanım

### 1. Basit Sayfa Geçişi

```dart
import 'package:eventizer/utils/navigation_utils.dart';

// Login sayfasına git
NavigationUtils.toLogin();

// Ana sayfaya git (tüm önceki sayfaları temizleyerek)
NavigationUtils.toHome();

// Geri git
NavigationUtils.back();
```

### 2. Parametreli Navigation

```dart
// Profil sayfasına user ID ile git
NavigationUtils.toProfile(
  userId: "user123",
  isFromEvent: true,
);

// Event sayfasına complex data ile git
NavigationUtils.toEventPage(
  eventData: {'eventID': 'event123'},
  userData: {'UserID': 'user123'},
  amIparticipant: true,
);
```

### 3. Direkt GetX Kullanımı

```dart
import 'package:get/get.dart';
import 'package:eventizer/routes/app_routes.dart';

// Basit navigation
Get.toNamed(AppRoutes.login);

// Parametreli navigation
Get.toNamed('${AppRoutes.profile}?userId=123&isFromEvent=true');

// Arguments ile navigation
Get.toNamed(
  AppRoutes.eventPage,
  arguments: {
    'eventData': {'eventID': 'event123'},
    'userData': {'UserID': 'user123'},
  },
);
```

## 🛠 Navigation Utils

`NavigationUtils` sınıfı, routing işlemlerini kolaylaştıran helper fonksiyonları içerir:

### Authentication Navigation
- `toLogin()` - Login sayfasına git
- `toSignUp()` - Kayıt sayfasına git
- `toForgotPassword()` - Şifre sıfırlama sayfasına git

### Main App Navigation
- `toHome()` - Ana sayfaya git
- `toChat()` - Chat sayfasına git
- `toCreateEvent()` - Event oluşturma sayfasına git
- `toExploreEvents()` - Event keşfet sayfasına git
- `toProfile({userId, isFromEvent})` - Profil sayfasına git
- `toSettings()` - Ayarlar sayfasına git

### Utility Functions
- `back()` - Geri git
- `showSnackbar({title, message, isError})` - Snackbar göster
- `showBottomSheet(widget)` - Bottom sheet göster
- `showDialog(widget)` - Dialog göster

## 🗺 Route Tanımları

`AppRoutes` sınıfında tüm route path'leri tanımlanmıştır:

```dart
class AppRoutes {
  // Authentication routes
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  
  // Main app routes
  static const String home = '/home';
  static const String chat = '/chat';
  static const String createEvent = '/create-event';
  static const String exploreEvents = '/explore-events';
  static const String profile = '/profile';
  
  // ... diğer route'lar
}
```

## 🎮 Controller Entegrasyonu

### HomeController Kullanımı

```dart
import 'package:get/get.dart';
import 'package:eventizer/controllers/home_controller.dart';

// Controller'a erişim
final homeController = Get.find<HomeController>();

// Bottom navigation index değiştirme
homeController.setBottomNavIndex(2);

// Mevcut index'i alma
int currentIndex = homeController.bottomNavIndex;
```

### Reactive UI (Obx Kullanımı)

```dart
Obx(() => Text('Current tab: ${homeController.bottomNavIndex}'))
```

## 📖 Örnek Kullanımlar

### Widget İçerisinde Navigation

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => NavigationUtils.toProfile(userId: "123"),
      child: Text("Profile Git"),
    );
  }
}
```

### Route Parameters Alma

```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // URL parametrelerini alma
    String? userId = Get.parameters['userId'];
    bool isFromEvent = Get.parameters['isFromEvent'] == 'true';
    
    // Arguments alma
    Map<String, dynamic>? data = Get.arguments;
    
    return Scaffold(
      appBar: AppBar(title: Text('Profile: $userId')),
      body: Center(child: Text('Is from event: $isFromEvent')),
    );
  }
}
```

### Conditional Navigation

```dart
void navigateBasedOnAuth() {
  bool isLoggedIn = AuthService.isLoggedIn;
  
  if (isLoggedIn) {
    NavigationUtils.toHome();
  } else {
    NavigationUtils.toLogin();
  }
}
```

### Success/Error Handling

```dart
Future<void> saveData() async {
  try {
    await dataService.save();
    NavigationUtils.showSnackbar(
      title: "Başarılı",
      message: "Veriler kaydedildi",
    );
    NavigationUtils.toHome();
  } catch (e) {
    NavigationUtils.showSnackbar(
      title: "Hata",
      message: "Kaydetme işlemi başarısız",
      isError: true,
    );
  }
}
```

## 🔧 Migration Rehberi

Mevcut navigation kodlarını GetX'e geçirmek için:

### Eski Kod:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ProfilePage()),
);
```

### Yeni Kod:
```dart
NavigationUtils.toProfile(userId: "123");
```

### Eski NavigationManager Kullanımı:
```dart
NavigationManager(context).pushPage(ProfilePage());
```

### Yeni GetX Kullanımı:
```dart
NavigationUtils.toProfile(userId: "123");
```

## 🎨 Transition Ayarları

Varsayılan transition ayarları `main.dart`'ta yapılandırılmıştır:

```dart
GetMaterialApp(
  defaultTransition: Transition.rightToLeft,
  transitionDuration: Duration(milliseconds: 300),
  // ...
)
```

Her route için özel transition tanımlanabilir:

```dart
GetPage(
  name: AppRoutes.profile,
  page: () => ProfilePage(),
  transition: Transition.fadeIn,
  transitionDuration: Duration(milliseconds: 500),
)
```

## 📝 Notlar

1. **Controller Lifecycle**: HomeController otomatik olarak `HomePage`'de initialize edilir
2. **Memory Management**: GetX otomatik olarak unused controller'ları temizler
3. **Hot Reload**: GetX routing hot reload ile uyumludur
4. **Deep Linking**: Route'lar deep linking için hazır hale getirilmiştir
5. **Web Support**: Web platformu için URL routing desteklenir

## 🔍 Debug ve Test

Debug modda route geçişlerini izlemek için:

```dart
// main.dart'ta
GetMaterialApp(
  enableLog: true, // Route değişikliklerini loglar
  logWriterCallback: (text, {bool isError = false}) {
    print('GetX Log: $text');
  },
  // ...
)
```

Bu dokümantasyon GetX routing sisteminin temel kullanımını kapsar. Daha detaylı bilgi için `lib/examples/getx_routing_examples.dart` dosyasını inceleyebilirsiniz. 