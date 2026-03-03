import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  static const String _keyName = 'profile_name';
  static const String _keyPhotoPath = 'profile_photo_path';

  String _userName = '';
  String? _photoPath;

  String get userName => _userName;
  String? get photoPath => _photoPath;

  bool get hasPhoto => _photoPath != null && _photoPath!.isNotEmpty;

  ProfileProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString(_keyName) ?? '';
    _photoPath = prefs.getString(_keyPhotoPath);
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    notifyListeners();
  }

  Future<void> setPhotoFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image != null) {
      await _savePhoto(image.path);
    }
  }

  Future<void> setPhotoFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image != null) {
      await _savePhoto(image.path);
    }
  }

  Future<void> _savePhoto(String sourcePath) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final destPath = '${dir.path}/$fileName';

      final file = File(sourcePath);
      await file.copy(destPath);

      _photoPath = destPath;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyPhotoPath, destPath);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving photo: $e');
    }
  }

  Future<void> removePhoto() async {
    if (_photoPath != null) {
      try {
        final file = File(_photoPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
      _photoPath = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyPhotoPath);
      notifyListeners();
    }
  }
}
