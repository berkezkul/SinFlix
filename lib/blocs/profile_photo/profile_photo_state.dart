import 'package:equatable/equatable.dart';
import 'dart:io';

class ProfilePhotoState extends Equatable {
  final File? photo;
  final bool isLoading;
  final String? error;

  const ProfilePhotoState({
    this.photo,
    this.isLoading = false,
    this.error,
  });

  ProfilePhotoState copyWith({
    File? photo,
    bool? isLoading,
    String? error,
  }) {
    return ProfilePhotoState(
      photo: photo ?? this.photo,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [photo ?? '', isLoading, error ?? ''];
}