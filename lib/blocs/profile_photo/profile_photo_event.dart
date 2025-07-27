import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ProfilePhotoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhotoSelected extends ProfilePhotoEvent {
  final File photo;
  PhotoSelected(this.photo);

  @override
  List<Object?> get props => [photo];
}

class ContinuePressed extends ProfilePhotoEvent {}