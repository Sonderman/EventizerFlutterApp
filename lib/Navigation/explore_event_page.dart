import 'package:eventizer/navigation/components/Event_Item.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/navigation/components/custom_scroll.dart';
import 'package:eventizer/tools/page_components.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ExploreEventPage extends StatefulWidget {
  const ExploreEventPage({super.key});

  @override
  State<ExploreEventPage> createState() => _ExploreEventPageState();
}

class _ExploreEventPageState extends State<ExploreEventPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  String? category;

  // Zemin renkleri — login ekranıyla aynı koyu navy paleti
  static const List<Color> _bgColors = [
    Color(0xFF0C1220),
    Color(0xFF16243A),
    Color(0xFF253B59),
  ];

  // Kategori tanımları: ad + simge asset'i. "Hepsi" seçiliyken category null.
  static const List<({String? value, String label, String icon})>
      _categories = [
    (value: null, label: "Hepsi", icon: ""),
    (value: "Doğum Günü", label: "Doğum Günü", icon: "assets/icons/birthdayCategory.png"),
    (value: "Yurtiçi Gezisi", label: "Yurtiçi Gezi", icon: "assets/icons/travelCategory.png"),
    (value: "Yurtdışı Gezisi", label: "Yurtdışı Gezi", icon: "assets/icons/worldtravelCategory.png"),
    (value: "Doğa Fotoğraflama", label: "Doğa Fotoğraflama", icon: "assets/icons/cameraCategory.png"),
    (value: "Konferans&Seminer", label: "Konferans", icon: "assets/icons/conferenceCategory.png"),
    (value: "Kamp", label: "Kamp", icon: "assets/icons/campCategory.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // Koyu lacivert zemin — appShell'in açık mavi zeminini kaplar
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _bgColors,
          ),
        ),
        child: Stack(
          children: [
            // Cyan glow — sol üst
            const _GlowSphere(
              top: -120,
              left: -140,
              size: 380,
              color: Color(0xFF1BC8D9),
              baseOpacity: 0.18,
            ),
            // Mor glow — sağ alt
            const _GlowSphere(
              bottom: -140,
              right: -120,
              size: 420,
              color: Color(0xFF8358D8),
              baseOpacity: 0.14,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildHeader(),
                    SizedBox(height: 2.h),
                    subCategoryList(),
                    Expanded(child: eventList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Başlık: "Keşfet" + alt açıklama
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Keşfet",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 0.6.h),
          Text(
            "Sana uygun etkinlikleri bul, katıl, anı biriktir",
            style: TextStyle(
              fontFamily: "ZonaLight",
              fontSize: 13.sp,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventList() {
    var eventManager = Provider.of<EventService>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 1.5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: displayedCategoryTitle(),
          ),
          SizedBox(height: 1.2.h),
          //ANCHOR event list start are here---------------------------------------------
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>?>(
              future: (category == null || category == "Hepsi")
                  ? eventManager.fetchActiveEventLists()
                  : eventManager.fetchActiveEventListsByCategory(category!),
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>?> fetchedlist,
                  ) {
                    if (fetchedlist.connectionState != ConnectionState.done) {
                      return Center(
                        child: PageComponents(
                          context,
                        ).loadingCustomOverlay(spinColor: Colors.white),
                      );
                    }

                    if (fetchedlist.hasError) {
                      return Center(
                        child: Text(
                          "Etkinlikler yüklenemedi.\nLütfen tekrar deneyin.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: widthSize(4.2),
                          ),
                        ),
                      );
                    }

                    // Generated safety guard: Firestore null/error response should not crash UI.
                    final List<Map<String, dynamic>> listofMaps =
                        fetchedlist.data ?? <Map<String, dynamic>>[];

                    if (listofMaps.isEmpty) {
                      return Center(
                        child: Text(
                          "Bu kategoride etkinlik yok",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w600,
                            fontSize: widthSize(4.5),
                          ),
                        ),
                      );
                    }

                    return ScrollConfiguration(
                      behavior: NoScrollEffectBehavior(),
                      child: ListView.separated(
                        separatorBuilder:
                            //ANCHOR ayıraç burada
                            (BuildContext context, int index) =>
                                SizedBox(height: 2.h),
                        itemCount: listofMaps.length,
                        itemBuilder: (context, index) {
                          return eventItem(context, listofMaps[index], true);
                        },
                      ),
                    );
                  },
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget displayedCategoryTitle() {
    return Row(
      children: <Widget>[
        Text(
          category ?? "En Yeni",
          style: TextStyle(
            fontFamily: "Zona",
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          category != null ? " etkinlikleri" : " etkinlikler",
          style: TextStyle(
            fontFamily: "ZonaLight",
            fontSize: 17.sp,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
        const Spacer(),
        // Küçük cam rozet — toplam etkinlik sayısı hissi
        GlassContainer(
          shape: const LiquidRoundedSuperellipse(borderRadius: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          settings: MyLiquidGlass.interactive,
          useOwnLayer: true,
          child: Icon(Icons.explore, size: 16, color: const Color(0xFF1BC8D9)),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Kategori şeridi — ikonlu net cam chip'ler. Seçili olan cyan tint alır.
  // ---------------------------------------------------------------------------
  Widget subCategoryList() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.5.w),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final bool selected =
              (cat.value == null && (category == null || category == "Hepsi")) ||
              (cat.value != null && category == cat.value);
          return _CategoryChip(
            label: cat.label,
            icon: cat.icon,
            selected: selected,
            onTap: () {
              setState(() {
                category = cat.value;
              });
            },
          );
        },
      ),
    );
  }
}

/// Tek kategori chip'i — net cam; seçiliyken cyan tint + kalın rim.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        shape: const LiquidRoundedSuperellipse(borderRadius: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        settings: selected
            ? const LiquidGlassSettings(
                blur: 0,
                thickness: 11,
                glassColor: Color(0x241BC8D9),
                refractiveIndex: 0.86,
                lightAngle: 0.75 * 3.141592653589793,
                lightIntensity: 0.98,
                ambientStrength: 0.18,
                saturation: 1.0,
                chromaticAberration: 0.01,
                specularSharpness: GlassSpecularSharpness.medium,
              )
            : MyLiquidGlass.interactive,
        useOwnLayer: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon.isNotEmpty) ...[
              Image.asset(icon, height: 20, width: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Statik glow küresi — nefes animasyonu yok (liste kaydırma budget'ı).
class _GlowSphere extends StatelessWidget {
  const _GlowSphere({
    this.top,
    this.left,
    this.bottom,
    this.right,
    required this.size,
    required this.color,
    required this.baseOpacity,
  });

  final double? top;
  final double? left;
  final double? bottom;
  final double? right;
  final double size;
  final Color color;
  final double baseOpacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: baseOpacity),
              color.withValues(alpha: baseOpacity * 0.25),
              const Color(0x00000000),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}