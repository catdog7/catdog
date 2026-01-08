import 'dart:io';

import 'package:catdog/domain/repository/fcm_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmUseCase {
  FcmUseCase(this._repository);
  final FcmRepository _repository;
  Future<void> execute() => _repository.init();
}
