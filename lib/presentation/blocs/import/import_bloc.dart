import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/import_instagram_data_usecase.dart';

// Events
abstract class ImportEvent extends Equatable {
  const ImportEvent();

  @override
  List<Object?> get props => [];
}

class ImportFileSelected extends ImportEvent {
  final String filePath;

  const ImportFileSelected(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class ImportReset extends ImportEvent {
  const ImportReset();
}

// State
enum ImportStatus { initial, loading, success, error }

class ImportState extends Equatable {
  final ImportStatus status;
  final InstagramData? data;
  final String? errorMessage;
  final double progress;

  const ImportState({
    this.status = ImportStatus.initial,
    this.data,
    this.errorMessage,
    this.progress = 0,
  });

  ImportState copyWith({
    ImportStatus? status,
    InstagramData? data,
    String? errorMessage,
    double? progress,
  }) {
    return ImportState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage, progress];
}

// BLoC
class ImportBloc extends Bloc<ImportEvent, ImportState> {
  final ImportInstagramDataUseCase importDataUseCase;

  ImportBloc({required this.importDataUseCase}) : super(const ImportState()) {
    on<ImportFileSelected>(_onFileSelected);
    on<ImportReset>(_onReset);
  }

  Future<void> _onFileSelected(
    ImportFileSelected event,
    Emitter<ImportState> emit,
  ) async {
    emit(state.copyWith(status: ImportStatus.loading, progress: 0.05));

    try {
      // Simulate progress while importing
      Timer? progressTimer;
      double currentProgress = 0.05;
      
      progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (currentProgress < 0.85) {
          currentProgress += 0.03 + (0.85 - currentProgress) * 0.02;
          emit(state.copyWith(progress: currentProgress));
        }
      });

      final data = await importDataUseCase(event.filePath);
      
      progressTimer.cancel();
      
      // Animate to 100%
      for (double p = currentProgress; p <= 1.0; p += 0.05) {
        emit(state.copyWith(progress: p > 1.0 ? 1.0 : p));
        await Future.delayed(const Duration(milliseconds: 30));
      }
      emit(state.copyWith(progress: 1.0));
      
      await Future.delayed(const Duration(milliseconds: 300));
      
      emit(state.copyWith(
        status: ImportStatus.success,
        data: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ImportStatus.error,
        errorMessage: 'Error al importar los datos. Asegúrate de que el archivo ZIP es válido.',
      ));
    }
  }

  void _onReset(ImportReset event, Emitter<ImportState> emit) {
    emit(const ImportState());
  }
}

