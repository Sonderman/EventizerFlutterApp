import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileListItem extends StatefulWidget {
  final Map<String, dynamic> jsonData;

  const ProfileListItem({Key key, this.jsonData}) : super(key: key);

  @override
  _ProfileListItemState createState() => _ProfileListItemState();
}

class _ProfileListItemState extends State<ProfileListItem> {
  Map<String, dynamic> get data => widget.jsonData;

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context, listen: false);
    return FutureBuilder(
      //ANCHOR Her bir list itemi için kullanıcı bilgisi getirir
      future: userService.findUserByID(data['CommentOwnerID']),
      builder: (BuildContext context, AsyncSnapshot user) {
        if (user.connectionState == ConnectionState.done) {
          return buildItem(user.data);
        } else {
          return PageComponents(context).loadingCustomOverlay(32, Colors.white);
        }
      },
    );
  }

  Widget buildItem(Map<String, dynamic> user) {
    return _ProfileListItemInternal(
      image: user['ProfilePhotoUrl'],
      name: user['Name'] + " " + user['Surname'],
      comment: data['Comment'],
    );
  }
}

class _ProfileListItemInternal extends StatefulWidget {
//  final Map<String,dynamic> user;
  final String name;
  final String image;
  final String comment;

  _ProfileListItemInternal({this.name, this.image, this.comment});

  @override
  _ProfileListItemInternalState createState() =>
      _ProfileListItemInternalState();
}

class _ProfileListItemInternalState extends State<_ProfileListItemInternal> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  bool isOpen = false;
  double _height = 200;

  @override
  Widget build(BuildContext context) {
    _height = isOpen ? 400 : 200;
    return GestureDetector(
      onTap: () {
        print("Item is open? $isOpen ${DateTime.now()}");
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
//        height: _height,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: MyColors().lightGreen,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                height: heightSize(7),
                width: widthSize(14),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        ExtendedNetworkImageProvider(widget.image, cache: true),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: widthSize(3),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //username
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2.5),
                      color: MyColors().darkblueText,
                    ),
                  ),
                  Divider(
                    endIndent: 15,
                    height: 15,
                    color: MyColors().darkblueText,
                    thickness: 1,
                  ),
                  Text(
                    widget.comment,
                    maxLines: isOpen ? 2000 : 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: "ZonaLight",
                      fontSize: heightSize(2),
                      color: MyColors().darkblueText,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
