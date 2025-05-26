import 'dart:async';
import 'dart:io';

import 'package:app/models/businessLayer/api_helper.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessRule {
  APIHelper? apiHelper;

  BusinessRule(APIHelper? apiHelper) {
    apiHelper = apiHelper;
  }
  String? calculateDurationDiff(DateTime? date) {
    String? durationText;
    try {
      if(date != null) {
        if (Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.year) > 0) {
          durationText = '${Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.year)} year ago';
        } else if (Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.month) > 0) {
          durationText = '${Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.month)} mon ago';
        } else if (Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.week) > 0) {
          durationText = '${Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.week)} week ago';
        } else if (Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.day) > 0) {
          durationText = '${Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.day)} day ago';
        } else if (Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.hour) > 0) {
          durationText = '${Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.hour)} hour ago';
        } else if (Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.minute) > 0) {
          durationText = '${Jiffy.now().diff(Jiffy.parseFromDateTime(date), unit: Unit.minute)} min ago';
        } else {
          durationText = 'now';
        }

        return durationText;
      }
      return null;
    } catch (e) {
      debugPrint("Exception - barberDescriptionScreen.dart - _calculateDurationDiff(): $e");
      return durationText;
    }
  }

  Future<bool> checkConnectivity() async {
    try {
      bool isConnected;
      var connectivity = (await Connectivity().checkConnectivity()).first;
      if (connectivity == ConnectivityResult.mobile) {
        isConnected = true;
      } else if (connectivity == ConnectivityResult.wifi) {
        isConnected = true;
      } else {
        isConnected = false;
      }

      if (isConnected) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            isConnected = true;
          }
        } on SocketException catch (_) {
          isConnected = false;
        }
      }

      return isConnected;
    } catch (e) {
      debugPrint('Exception - business_rule.dart - checkConnectivity(): $e');
    }
    return false;
  }

  getSharedPreferences() async {
    try {
      global.sp = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint("Exception - otp_verification_screen.dart - _saveUser():$e");
    }
  }

  inviteFriendShareMessage() {
    try {
      Share.share(global.appShareMessage.replaceAll("[CODE]", "${global.user!.referralCode}"));
    } catch (e) {
      debugPrint("Exception -  business_rule.dart - inviteFriendShareMessage():$e");
    }
  }

  Future<File?> openCamera() async {
    try {
      PermissionStatus permissionStatus = await Permission.camera.status;
      if (permissionStatus.isLimited || permissionStatus.isDenied) {
        permissionStatus = await Permission.camera.request();
      }
      XFile selectedImage = await (ImagePicker().pickImage(source: ImageSource.camera) as FutureOr<XFile>);
      File imageFile = File(selectedImage.path);
      File finalImage = await (_cropImage(imageFile.path) as FutureOr<File>);

      File? finalImage1 = await _imageCompress(finalImage, imageFile.path);

      return finalImage1;
    } catch (e) {
      debugPrint("Exception - business_rule.dart - openCamera():$e");
    }
    return null;
  }

  Future<File?> selectImageFromGallery() async {
    try {
      PermissionStatus permissionStatus = await Permission.photos.status;
      if (permissionStatus.isLimited || permissionStatus.isDenied) {
        permissionStatus = await Permission.photos.request();
      }
      File imageFile;
      XFile selectedImage = await (ImagePicker().pickImage(source: ImageSource.gallery) as FutureOr<XFile>);
      imageFile = File(selectedImage.path);
      File byteData = await (_cropImage(imageFile.path) as FutureOr<File>);
      byteData = await (_imageCompress(byteData, imageFile.path) as FutureOr<File>);
      return byteData;
    } catch (e) {
      debugPrint("Exception - business_rule.dart - selectImageFromGallery()$e");
    }
    return null;
  }

  Future<File?> _cropImage(String sourcePath) async {
    try {
      File? croppedFile = (await ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: CropAspectRatioPreset.original,
              backgroundColor: Colors.white,
              toolbarColor: Colors.black,
              dimmedLayerColor: Colors.white,
              toolbarWidgetColor: Colors.white,
              cropGridColor: Colors.white,
              activeControlsWidgetColor: const Color(0xFF46A9FC),
              cropFrameColor: const Color(0xFF46A9FC),
              lockAspectRatio: true,
            ),
          ])) as File?;
      if (croppedFile != null) {
        return croppedFile;
      }
    } catch (e) {
      debugPrint("Exception - business_rule.dart - _cropImage():$e");
    }
    return null;
  }

  Future<File?> _imageCompress(File file, String targetPath) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        minHeight: 500,
        minWidth: 500,
        quality: 60,
      );

      if (result != null) {
        return File(result.path);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Exception - business_rule.dart - _cropImage():$e");
      return null;
    }
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(\/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasDateExpired(int month, int year) {
    return isNotExpired(year, month);
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) || convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class Strings {
  static const String appName = 'Payment Card Demo';
  static const String fieldReq = 'This field is required';
  static const String numberIsInvalid = 'Card is invalid';
  static const String pay = 'Pay';
}
