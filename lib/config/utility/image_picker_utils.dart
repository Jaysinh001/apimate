import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  Future<XFile?> capturePhoto() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    return file;
  }

  Future<XFile?> pickPhoto() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);
    return file;
  }
}
