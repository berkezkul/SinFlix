import 'package:equatable/equatable.dart';
import 'dart:io';

class ProfilePhotoState extends Equatable {
  final File? photo;
  final bool isLoading;
  final String? error;
  final String? photoUrl;

  const ProfilePhotoState({
    this.photo,
    this.isLoading = false,
    this.error,
    this.photoUrl,
  });

  ProfilePhotoState copyWith({
    File? photo,
    bool? isLoading,
    String? error,
    String? photoUrl,
  }) {
    return ProfilePhotoState(
      photo: photo ?? this.photo,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [photo ?? '', isLoading, error ?? '', photoUrl ?? ''];
}