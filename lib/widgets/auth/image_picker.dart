import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File image) getImage;
  Key key;
  ImagePickerWidget(this.getImage, {this.key});
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final image = await showDialog<PickedFile>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('choose image source'),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.photo_camera),
              label: Text('Camera'),
              onPressed: () async {
                final _image = await picker.getImage(
                    source: ImageSource.camera,
                    maxWidth: 150,
                    imageQuality: 50);
                Navigator.of(context).pop(_image);
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text('Galery'),
              onPressed: () async {
                final _image = await picker.getImage(
                    source: ImageSource.gallery,
                    maxWidth: 150,
                    imageQuality: 50);
                Navigator.of(context).pop(_image);
              },
            ),
          ],
        ),
      );
      setState(() {
        _pickedImage = File(image.path);
      });
      widget.getImage(_pickedImage);
    } catch (error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('image isn\'t choosen'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _radius = MediaQuery.of(context).size.width * 0.3;
    return Material(
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: _radius,
        child: InkWell(
          onTap: _pickImage,
          child: _pickedImage != null
              ? Image.file(
                  _pickedImage,
                  fit: BoxFit.cover,
                  width: _radius,
                )
              : Container(
                  height: _radius,
                  width: _radius,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Text(
                    'Upload image here',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
        ),
      ),
    );
  }
}
