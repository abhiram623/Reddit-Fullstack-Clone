import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future <File?> pickImageFromGallery ()async{
 File? image;
 
  try {
     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedImage !=null) {
    image = File(pickedImage.path);
  }
  } catch (e) {
    print(e.toString());
  }
 
  return image;
}