import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUploadCard extends StatefulWidget {
  final Character character;
  final TextEditingController controller;
  final Function(Character) onSave;

  const AvatarUploadCard({
    Key key,
    @required this.controller,
    @required this.character,
    @required this.onSave,
  }) : super(key: key);

  @override
  _AvatarUploadCardState createState() => _AvatarUploadCardState();
}

class _AvatarUploadCardState extends State<AvatarUploadCard> {
  File imageFile;
  Alignment photoAlignment;

  @override
  void initState() {
    imageFile = null;
    photoAlignment =
        widget.character.settings?.photoAlignment ?? Alignment.topCenter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              avatar,
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: RaisedButton.icon(
                      color: Colors.white,
                      label: Text('Upload Image'),
                      icon: imageFile == null
                          ? Icon(Icons.file_upload)
                          : Loader.button(),
                      onPressed: imageFile == null ? _pickImage : null,
                    ),
                  ),
                ),
              ),
              if (imageUrl.isNotEmpty)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.rotate(
                          angle: pi,
                          child: IconButton(
                            tooltip: 'Align to top',
                            icon: IconShadowWidget(
                              Icon(
                                Icons.file_download,
                                color: Colors.white,
                              ),
                              shadowColor: Colors.black,
                            ),
                            onPressed: () =>
                                setPhotoAlignment(Alignment.topCenter),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Align to center',
                          icon: IconShadowWidget(
                            Icon(
                              Icons.center_focus_strong,
                              color: Colors.white,
                            ),
                            shadowColor: Colors.black,
                          ),
                          onPressed: () => setPhotoAlignment(Alignment.center),
                        ),
                        IconButton(
                          tooltip: 'Align to bottom',
                          icon: IconShadowWidget(
                            Icon(
                              Icons.file_download,
                              color: Colors.white,
                            ),
                            shadowColor: Colors.black,
                          ),
                          onPressed: () =>
                              setPhotoAlignment(Alignment.bottomCenter),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    enableInteractiveSelection: true,
                    decoration: InputDecoration(
                      hintText: 'Enter any valid image URL here',
                      labelText: 'Avatar Image URL',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get imageUrl => widget.controller.text;

  Widget get avatar {
    return AspectRatio(
      aspectRatio: 14.0 / 9.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: imageUrl.isNotEmpty
            ? imageBuilder()
            : _emptyState(
                'Please type a URL of your image, '
                'or upload one using the button on the top right.',
              ),
      ),
    );
  }

  Container _emptyState(String text) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  CachedNetworkImage imageBuilder() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, image) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: photoAlignment,
            image: image,
          ),
        ),
      ),
      errorWidget: (context, url, e) => _emptyState(
        "We couldn't load your image, please check the URL and try again.",
      ),
    );
  }

  void setPhotoAlignment(Alignment align) {
    setState(() {
      photoAlignment = align;
    });
    _onSave();
  }

  void _onSave() {
    widget.onSave?.call(
      widget.character.copyWith(
        photoURL: widget.controller.text,
        customSettings: widget.character.settings.copyWith(
          photoAlignment: photoAlignment,
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(pickedFile.path);
    });

    _upload();
  }

  void _upload() async {
    if (imageFile == null) {
      return;
    }
    final downloadURL = await uploadImage(
      imageFile,
      directory: 'avatars',
      extraMetadata: {'characterId': widget.character.documentID},
      analyticsSource: Routes.characterEdit,
    );
    setState(() {
      imageFile = null;
    });
    widget.controller.text = downloadURL;
    _onSave();
  }
}
