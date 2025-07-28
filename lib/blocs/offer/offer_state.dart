import 'package:equatable/equatable.dart';

class OfferState extends Equatable {
  final bool isVisible;
  final int selectedPackageIndex;

  const OfferState({
    this.isVisible = false,
    this.selectedPackageIndex = 1, // Ortadaki paket default seçili
  });

  OfferState copyWith({
    bool? isVisible,
    int? selectedPackageIndex,
  }) {
    return OfferState(
      isVisible: isVisible ?? this.isVisible,
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
    );
  }

  @override
  List<Object> get props => [isVisible, selectedPackageIndex];
} 