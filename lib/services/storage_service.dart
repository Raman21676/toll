import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final _uuid = const Uuid();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  /// Show bottom sheet to choose image source
  Future<File?> showImageSourceBottomSheet(BuildContext context) async {
    File? selectedImage;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.blue),
                ),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  selectedImage = await pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.green),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  selectedImage = await pickImageFromGallery();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    return selectedImage;
  }

  /// Upload profile image to Firebase Storage
  Future<Map<String, dynamic>> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    try {
      // Create unique filename
      String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
      String filePath = 'profile_images/$userId/$fileName';

      // Create storage reference
      Reference ref = _storage.ref().child(filePath);

      // Upload file with metadata
      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      UploadTask uploadTask = ref.putFile(imageFile, metadata);

      // Show upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return {
        'success': true,
        'url': downloadUrl,
        'path': filePath,
      };
    } on FirebaseException catch (e) {
      debugPrint('Firebase Storage error: ${e.code} - ${e.message}');
      return {
        'success': false,
        'error': _getStorageErrorMessage(e.code),
      };
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return {
        'success': false,
        'error': 'Failed to upload image. Please try again.',
      };
    }
  }

  /// Upload post image
  Future<Map<String, dynamic>> uploadPostImage({
    required File imageFile,
    required String userId,
    required String postId,
  }) async {
    try {
      String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
      String filePath = 'post_images/$userId/$postId/$fileName';

      Reference ref = _storage.ref().child(filePath);

      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': userId,
          'postId': postId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      UploadTask uploadTask = ref.putFile(imageFile, metadata);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return {
        'success': true,
        'url': downloadUrl,
        'path': filePath,
      };
    } on FirebaseException catch (e) {
      return {
        'success': false,
        'error': _getStorageErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to upload image.',
      };
    }
  }

  /// Upload chat image
  Future<Map<String, dynamic>> uploadChatImage({
    required File imageFile,
    required String chatRoomId,
    required String senderId,
  }) async {
    try {
      String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
      String filePath = 'chat_images/$chatRoomId/$fileName';

      Reference ref = _storage.ref().child(filePath);

      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': senderId,
          'chatRoomId': chatRoomId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      UploadTask uploadTask = ref.putFile(imageFile, metadata);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return {
        'success': true,
        'url': downloadUrl,
        'path': filePath,
      };
    } on FirebaseException catch (e) {
      return {
        'success': false,
        'error': _getStorageErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to upload image.',
      };
    }
  }

  /// Delete image from storage
  Future<bool> deleteImage(String filePath) async {
    try {
      Reference ref = _storage.ref().child(filePath);
      await ref.delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Delete profile image
  Future<bool> deleteProfileImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting profile image: $e');
      return false;
    }
  }

  /// Get error message for storage errors
  String _getStorageErrorMessage(String code) {
    switch (code) {
      case 'storage/unauthorized':
        return 'You don\'t have permission to upload files.';
      case 'storage/canceled':
        return 'Upload was canceled.';
      case 'storage/unknown':
        return 'An unknown error occurred.';
      case 'storage/quota-exceeded':
        return 'Storage quota exceeded. Contact support.';
      case 'storage/invalid-checksum':
        return 'File was corrupted during upload. Please try again.';
      default:
        return 'Upload failed. Please try again.';
    }
  }
}
