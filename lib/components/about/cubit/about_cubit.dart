import 'package:bloc/bloc.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'about_state.dart';

class AboutCubit extends Cubit<AboutState> with LoggerMixin {
  AboutCubit() : super(const AboutState());
}
