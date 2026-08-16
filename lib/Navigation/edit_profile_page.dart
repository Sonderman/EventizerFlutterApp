import 'package:eventizer/tools/page_components.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: MyLiquidGlass.standartContainer(
          child: PageComponents(context).underConstruction(),
        ),
      ),
    );
  }
}
