import 'package:eventizer/Services/Repository.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

class ProfilePage2 extends StatelessWidget {
  final userId;
  final isFromEvent;
  ProfilePage2(this.userId, this.isFromEvent);

  final List<String> assetNames = [
    'assets/images/brady-bellini-212790-unsplash.jpg',
    'assets/images/stefan-stefancik-105587-unsplash.jpg',
    'assets/images/simon-fitall-530083-unsplash.jpg',
    'assets/images/anton-repponen-99530-unsplash.jpg',
    'assets/images/kevin-cochran-524957-unsplash.jpg',
    'assets/images/samsommer-72299-unsplash.jpg',
    'assets/images/simon-matzinger-320332-unsplash.jpg',
    'assets/images/meng-ji-102492-unsplash.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    print("-----------USERID --------" + userId);
    return MaterialApp(
      home: Scaffold(
        body: _scrollView(context),
      ),
    );
  }

  Widget _scrollView(BuildContext context) {
    // Use LayoutBuilder to get the hero header size while keeping the image aspect-ratio
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: HeroHeader(
              minExtent: 150.0,
              maxExtent: 380.0,
              userId: userId,
              myContext: context,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => print('Etkinlik tiklandi'),
                  child: Container(
                    alignment: Alignment.center,
                    padding: _edgeInsetsForIndex(index),
                    child: _singleEvent(index),
                  ),
                );
              },
              childCount: assetNames.length * 2,
            ),
          ),
        ],
      ),
    );
  }

  // ANCHOR Bu fonksiyon her event icin foto yazi ve golgelinderme bulundurur.
  Widget _singleEvent(int index) {
    return Stack(children: [
      Image.asset(
        assetNames[index % assetNames.length],
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black54,
            ],
            stops: [0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.repeated,
          ),
        ),
      ),
      Positioned(
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
        child: Text(
          'Etkinlik Kategori',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    ]);
  }

  EdgeInsets _edgeInsetsForIndex(int index) {
    if (index % 2 == 0) {
      return EdgeInsets.only(top: 4.0, left: 8.0, right: 4.0, bottom: 8.0);
    } else {
      return EdgeInsets.only(top: 4.0, left: 4.0, right: 8.0, bottom: 8.0);
    }
  }
}

// ANCHOR  Profil sayfasinin ilk kismi Kullanici profil, adi, mesaj, takip et ve
// kullanicilar hakkinda bilgilerin oldugu ust kisim
class HeroHeader implements SliverPersistentHeaderDelegate {
  HeroHeader({
    this.minExtent,
    this.maxExtent,
    this.userId,
    this.myContext,
  });
  double maxExtent;
  double minExtent;
  final userId;
  BuildContext myContext;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double heightSize(double value) {
      value /= 100;
      return MediaQuery.of(context).size.height * value;
    }

    double widthSize(double value) {
      value /= 100;
      return MediaQuery.of(context).size.width * value;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -80,
          height: 400,
          width: widthSize(100),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
              ),
            ),
          ),
        ),
        Positioned(
          top: 15,
          height: 400,
          width: widthSize(100),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/bg-2.png'),
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 140,
          height: 77.0,
          width: 77.0,
          child: profilImage(userId, myContext),
        ),
        Positioned(
            // left: 20,
            top: 180,
            height: 200,
            width: widthSize(100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 110),
                  child: Text('Mehmet Ali Akbay',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Color(0xff202020),
                        letterSpacing: 0.15,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      padding: EdgeInsets.only(left: 20),
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) => HeroPage())
                        // );
                        print(
                            '---------------------MESAJ Butonnnnn----------------------');
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child: Center(
                          child: Text(
                            "Mesaj",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                      padding: EdgeInsets.all(2.0),
                      onPressed: () {},
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0.00, 2.00),
                              color: Color(0xff000000).withOpacity(0.06),
                              blurRadius: 24,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xfbfbfbfb),
                        ),
                        child: Center(
                          child: Text(
                            "Takip Et",
                            style: TextStyle(color: Color(0xff202020)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Container(
                    height: 75.00,
                    width: widthSize(100),
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      color: Color(0xffffffff),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.00, 2.00),
                          color: Color(0xff000000).withOpacity(0.06),
                          blurRadius: 24,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20.00),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('500',
                                  style: TextStyle(
                                    fontFamily: "ProductSans",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: Color(0xff202020),
                                  )),
                              Text('Etkinlikler',
                                  style: TextStyle(
                                    fontFamily: "ProductSans",
                                    fontSize: 16,
                                    color: Color(0xff949494),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('12.2K',
                                  style: TextStyle(
                                    fontFamily: "ProductSans",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: Color(0xff202020),
                                  )),
                              Text('Takipçiler',
                                  style: TextStyle(
                                    fontFamily: "ProductSans",
                                    fontSize: 16,
                                    color: Color(0xff949494),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('4.7/5',
                                  style: TextStyle(
                                    fontFamily: "ProductSans",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: Color(0xff202020),
                                  )),
                              Text('15 Puan',
                                  style: TextStyle(
                                    fontFamily: "ProductSans",
                                    fontSize: 16,
                                    color: Color(0xff949494),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
        Positioned(
          // left: 20,
          top: 270,
          height: 200,
          width: widthSize(100),
          child: Container(
            height: heightSize(5),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Etkinlikler',
                      style: TextStyle(
                        fontFamily: "ProductSans",
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xff949494),
                      )),
                  Expanded(child: SizedBox(height: 1)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container profilImage(userId, BuildContext context) {
    var userWorker = Provider.of<UserService>(context);
    return Container(
      child: FutureBuilder(
        future: userWorker.firebaseDatabaseWorks.getUserProfilePhotoUrl(userId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("Profile Image URL: " + snapshot.data);
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.grey[400],
                ),
                image: DecorationImage(
                  image:
                      ExtendedNetworkImageProvider(snapshot.data, cache: true),
                ),
                shape: BoxShape.circle,
              ),
            );
          } else {
            return Container(
                // height: 150,
                // width: 150,
                // child: CircularProgressIndicator(),
                );
          }
        },
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // ANCHOR : implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}
