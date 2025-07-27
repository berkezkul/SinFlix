import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_photo_event.dart';
import 'profile_photo_state.dart';

class ProfilePhotoBloc extends Bloc<ProfilePhotoEvent, ProfilePhotoState> {
  ProfilePhotoBloc() : super(const ProfilePhotoState()) {
    on<PhotoSelected>((event, emit) {
      emit(state.copyWith(photo: event.photo, error: null));
    });

    on<ContinuePressed>((event, emit) async {
      if (state.photo == null) {
        emit(state.copyWith(error: "Lütfen bir fotoğraf seçin."));
        return;
      }
      emit(state.copyWith(isLoading: true, error: null));
      // Burada fotoğraf yükleme işlemi yapılabilir (API çağrısı vs.)
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isLoading: false));
      // Başarılı ise yönlendirme işlemini view'da yapabilirsin
    });
  }
}