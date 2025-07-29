import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  // Memory-based storage for now (SharedPreferences alternative)
  static String _currentLanguageCode = 'tr';

  LanguageBloc() : super(const LanguageInitial()) {
    on<LoadCurrentLanguage>(_onLoadCurrentLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  void _onLoadCurrentLanguage(
    LoadCurrentLanguage event,
    Emitter<LanguageState> emit,
  ) {
    final locale = _currentLanguageCode == 'en' 
        ? const Locale('en', 'US')
        : const Locale('tr', 'TR');
    
    emit(LanguageLoaded(locale));
    print('🌍 Loaded language: $_currentLanguageCode');
  }

  void _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) {
    try {
      _currentLanguageCode = event.locale.languageCode;
      emit(LanguageLoaded(event.locale));
      
      print('🌍 Language changed to: ${event.locale.languageCode}');
    } catch (e) {
      print('❌ Error changing language: $e');
    }
  }
} 