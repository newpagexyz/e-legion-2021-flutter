import 'package:elegionhack/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:elegionhack/auth/auth_provider.dart';
import 'package:elegionhack/auth/auth_rep.dart';
import 'package:elegionhack/profile/profile_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileState {
  final phone = TextEditingController();
  final addPhone = TextEditingController();
  final birthdateController = TextEditingController();
  final skypeController = TextEditingController();
  final telegramController = TextEditingController();
  final startVacationDateController = TextEditingController();
  final endVacationDateController = TextEditingController();

  String? fetchedAvatar;
  String? fetchedCv;

  File? selectedAvatar;
  File? selectedCv;

  static Future<File?> selectAvatar({bool fromCamera = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile == null) return null;
    final croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxHeight: 512,
        maxWidth: 512,
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Редактирование',
            hideBottomControls: true,
            lockAspectRatio: true),
        aspectRatioPresets: [CropAspectRatioPreset.square]);
    return croppedFile;
  }

  static Future<File?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return File(result.files.first.path!);
    }
    return null;
  }
}

class EditProfileStateNotifier
    extends ValueNotifier<AsyncValue<EditProfileState>> {
  EditProfileStateNotifier(this.ref) : super(const AsyncLoading()) {
    _init();
  }

  final ProviderRefBase ref;

  void changeAvatar() async {
    final selectedFile = await EditProfileState.selectAvatar();
    value.whenData((value) {
      value.selectedAvatar = selectedFile;
      notifyListeners();
    });
  }

  void changeCV() async {
    final selectedFile = await EditProfileState.selectFile();
    value.whenData((value) {
      value.selectedCv = selectedFile;
      notifyListeners();
    });
  }

  void _init() async {
    final profile = ref.read(userProfileProvider(-1));

    profile.whenData((data) {
      value = AsyncData(EditProfileState()
        ..addPhone.text = data.addPhone ?? ''
        ..phone.text = data.phone ?? ''
        ..birthdateController.text = data.birthdate ?? ''
        ..skypeController.text = data.skype ?? ''
        ..telegramController.text = data.telegram ?? ''
        ..fetchedAvatar = data.avatar
        ..fetchedCv = data.cv);
    });

    notifyListeners();
  }

  void save() async {
    value.whenData((changedData) async {
      final realData = ref.read(userProfileProvider(-1));
      final client = ref.watch(httpClientRepository);
      final credsState = ref.watch(authStateNotifierProvider);

      realData.whenData((realData) async {
        if (changedData.selectedCv != null) {
          await client.send(
              http.MultipartRequest('POST', Uri.parse(UserApi.editProfile))
                ..fields['token'] = credsState.credentials!.token
                ..files.add(await http.MultipartFile.fromPath(
                    'CV', changedData.selectedCv!.path)));
        }
        if (changedData.selectedAvatar != null) {
          await client.send(
              http.MultipartRequest('POST', Uri.parse(UserApi.changeAvatar))
                ..fields['token'] = credsState.credentials!.token
                ..files.add(await http.MultipartFile.fromPath(
                    'file', changedData.selectedAvatar!.path)));
        }

        ref.read(userProfileProvider(-1).notifier).reload();
      });
      
    });
  }
}

final editProfileProvider = ChangeNotifierProvider<EditProfileStateNotifier>(
    (ref) => EditProfileStateNotifier(ref));
