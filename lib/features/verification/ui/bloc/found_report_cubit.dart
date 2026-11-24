import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/verification/domain/usecases/verification_usecases.dart';

enum FoundReportStatus { editing, sending, done, failure }

class FoundReportState {
  const FoundReportState({
    this.status = FoundReportStatus.editing,
    this.conversationId,
  });

  final FoundReportStatus status;
  final String? conversationId;
}

class FoundReportCubit extends Cubit<FoundReportState> {
  FoundReportCubit(this._reportarHallazgo) : super(const FoundReportState());

  final ReportarHallazgo _reportarHallazgo;

  Future<void> send({
    required String postId,
    required String where,
    required String condition,
    required List<Uint8List> photos,
  }) async {
    emit(const FoundReportState(status: FoundReportStatus.sending));
    try {
      final id = await _reportarHallazgo(
        postId: postId,
        where: where,
        condition: condition,
        photos: photos,
      );
      emit(
        FoundReportState(status: FoundReportStatus.done, conversationId: id),
      );
    } catch (_) {
      emit(const FoundReportState(status: FoundReportStatus.failure));
    }
  }
}
