import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_photo_event.dart';
import 'profile_photo_state.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../utils/helpers/token_storage.dart';
import '../../utils/helpers/image_helper.dart';
import '../../services/navigation_service.dart';
import '../../utils/extensions/navigation_extensions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePhotoBloc extends Bloc<ProfilePhotoEvent, ProfilePhotoState> {
  ProfilePhotoBloc() : super(const ProfilePhotoState()) {
    on<PhotoSelected>((event, emit) {
      // Loading state'tayken yeni fotoğraf seçilmesini engelledim
      if (state.isLoading) return;
      emit(state.copyWith(photo: event.photo, error: null));
    });

    on<ContinuePressed>((event, emit) async {
      if (state.photo == null) {
        emit(state.copyWith(error: "Lütfen bir fotoğraf seçin."));
        return;
      }
      emit(state.copyWith(isLoading: true, error: null));
      try {
        // Token kontrolü
        final token = await TokenStorage.getToken();
        print('Kullanılan token: $token');
        if (token == null || token.isEmpty) {
          emit(state.copyWith(isLoading: false, error: "Oturum bulunamadı, lütfen tekrar giriş yapın."));
          return;
        }

        // Önce fotoğrafı sıkıştır (API limiti çok düşük denemeler yaptım - target 200KB)
        print(' Fotoğraf sıkıştırılıyor...');
        final compressedPhoto = await ImageHelper.compressImage(
          state.photo!,
          quality: 40,
          maxWidth: 600,
          maxHeight: 600,
        );
        
        // Direkt API'ye dosya gönder (multipart/form-data)
        print('API\'ye dosya upload başlıyor...');
        var request = http.MultipartRequest('POST', Uri.parse('https://caseapi.servicelabs.tech/user/upload_photo'));
        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(await http.MultipartFile.fromPath('file', compressedPhoto.path));
        
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print('Upload photo API response: ${response.statusCode} - $responseBody');
        
        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          String? photoUrl;
          if (data['data'] != null && data['data']['photoUrl'] != null) {
            photoUrl = data['data']['photoUrl'];
          }
          emit(state.copyWith(isLoading: false, error: null, photoUrl: photoUrl ?? 'uploaded'));
          // Context gerektirmeden navigation ve feedback
                      NavigationService.instance.showSuccess("Profil fotoğrafı başarıyla yüklendi!");
            NavigationService.instance.goToHome();
        } else {
          String errorMessage;
          if (response.statusCode == 413) {
            errorMessage = " Fotoğraf çok büyük!\n\nLütfen daha küçük bir fotoğraf seçin veya fotoğrafınızı sıkıştırın.\n\n💡 İpucu: Telefonunuzdan çekilmiş normal fotoğraflar genelde uygun boyuttadır.";
          } else if (response.statusCode == 401) {
            errorMessage = " Oturum süresi dolmuş!\n\nLütfen tekrar giriş yapın.";
          } else if (response.statusCode >= 500) {
            errorMessage = " Sunucu hatası!\n\nLütfen daha sonra tekrar deneyin.";
          } else {
            errorMessage = " Fotoğraf yüklenemedi!\n\nLütfen tekrar deneyin. Hata kodu: ${response.statusCode}";
          }
          
          emit(state.copyWith(isLoading: false, error: errorMessage));
        }
      } catch (e) {
        if (kDebugMode) {
          print('Upload error: $e');
        }
        emit(state.copyWith(isLoading: false, error: "Fotoğraf yüklenemedi: $e"));
      }
    });
  }
}