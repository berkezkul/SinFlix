import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_photo_event.dart';
import 'profile_photo_state.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../utils/helpers/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePhotoBloc extends Bloc<ProfilePhotoEvent, ProfilePhotoState> {
  ProfilePhotoBloc() : super(const ProfilePhotoState()) {
    on<PhotoSelected>((event, emit) {
      // Loading state'tayken yeni fotoğraf seçilmesini engelle
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

        // Direkt API'ye dosya gönder (multipart/form-data)
        print('API\'ye dosya upload başlıyor...');
        var request = http.MultipartRequest('POST', Uri.parse('https://caseapi.servicelabs.tech/user/upload_photo'));
        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(await http.MultipartFile.fromPath('file', state.photo!.path));
        
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print('Upload photo API response: ${response.statusCode} - $responseBody');
        
        if (response.statusCode == 200) {
          // Backend'den dönen response'ta photoUrl olabilir
          final data = jsonDecode(responseBody);
          String? photoUrl;
          if (data['data'] != null && data['data']['photoUrl'] != null) {
            photoUrl = data['data']['photoUrl'];
          }
          emit(state.copyWith(isLoading: false, error: null, photoUrl: photoUrl ?? 'uploaded'));
        } else {
          final errorMsg = "API'ye fotoğraf yüklenemedi. Status: ${response.statusCode}";
          emit(state.copyWith(isLoading: false, error: errorMsg));
        }
      } catch (e) {
        print('Upload error: $e');
        emit(state.copyWith(isLoading: false, error: "Fotoğraf yüklenemedi: $e"));
      }
    });
  }
}