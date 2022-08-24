import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePreview extends StatefulWidget {
   ImagePreview(this.picImage) ;
final void Function(File image)?picImage;
  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}


class _ImagePreviewState extends State<ImagePreview> {

  File? _imageFile;
  void _takePicture()async{

    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera,maxWidth: 200,imageQuality: 50);
    if(photo!=null){
      setState((){
        _imageFile=File(photo.path);
      });
          widget.picImage!(_imageFile!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:_imageFile!=null? FileImage(_imageFile!):null,
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
            onPressed: _takePicture,
            icon: Icon(Icons.image),
            label: Text('Add Picture'))
      ],
    );
  }
}
