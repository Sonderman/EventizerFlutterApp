import 'package:flutter/material.dart';

/*Bu class, sayfalarda kaydırma efekti yapmaya çalışırken yukarıda ve aşağıda çıkan
gereksiz görüntüyü kaldırma için oluşturuldu*/

class NoScrollEffectBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

/**
 Örnek kullanım :
 ScrollConfiguration(
                            behavior: MyBehavior(),
                            child:....
                            
                            )
 */
