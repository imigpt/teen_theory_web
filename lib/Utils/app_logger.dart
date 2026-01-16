import 'package:flutter/foundation.dart';
import "package:logger/logger.dart";

class AppLogger {
  static var loggerTag = "Teen Theory :: AppLogger ";
  static var logger = Logger(printer: PrettyPrinter());

  static debug({required message}) {
    // logger.d("${LoggerTag} ::: ${message}");
    if (kDebugMode) {
      print("$loggerTag ::: $message");
    }
  }

  static error({required message}) {
    //logger.e("${LoggerTag} ::: ${message}");
    if (kDebugMode) {
      print("$loggerTag ::: $message");
    }
  }

  static warning({required message}) {
    // logger.e("${LoggerTag} ::: ${message}");
    if (kDebugMode) {
      print("$loggerTag ::: $message");
    }
  }

  static verbose({required message}) {
    // logger.v("${LoggerTag} ::: ${message}");
    if (kDebugMode) {
      print("$loggerTag ::: $message");
    }
  }

  static info({required message}) {
    logger.i("$loggerTag ::: $message");
  }
}