import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'about_state.dart';

class AboutCubit extends Cubit<AboutState> with LoggerMixin {
  AboutCubit() : super(const AboutState());

  void updateMessage(String? message) {
    emit(state.copyWith(message: message));
  }

  Future<void> sendEmail() async {
    const String mailtrapKey = String.fromEnvironment('MAILTRAP_IO');
    if (mailtrapKey.isEmpty) {
      throw AssertionError('MAILTRAP_IO Api key is not set');
    }

    Map<String, dynamic> payload = {
      'from': {
        'email': 'cabo@app.com',
        'name': 'Cabo App',
      },
      'to': [
        {'email': 'salzi_andre@web.de'},
      ],
      'subject': 'Cabo Feedback',
      'text': state.message,
    };

    http
        .post(
      Uri.parse('https://sandbox.api.mailtrap.io/api/send/1153778'),
      headers: {
        "Authorization": "Bearer $mailtrapKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    )
        .then((http.Response response) {
      log.info(response.body);
    });
  }
}
