import 'package:equatable/equatable.dart';

abstract class OfferEvent extends Equatable {
  const OfferEvent();

  @override
  List<Object> get props => [];
}

class ShowOffer extends OfferEvent {}

class HideOffer extends OfferEvent {}

class SelectPackage extends OfferEvent {
  final int packageIndex;

  const SelectPackage(this.packageIndex);

  @override
  List<Object> get props => [packageIndex];
} 