import 'package:flutter_bloc/flutter_bloc.dart';
import 'offer_event.dart';
import 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  OfferBloc() : super(const OfferState()) {
    on<ShowOffer>((event, emit) {
      emit(state.copyWith(isVisible: true));
    });

    on<HideOffer>((event, emit) {
      emit(state.copyWith(isVisible: false));
    });

    on<SelectPackage>((event, emit) {
      emit(state.copyWith(selectedPackageIndex: event.packageIndex));
    });
  }
} 