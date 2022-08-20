import 'package:flutter/material.dart';

class Result<T> {
  late bool isOk;
  T? value;

  Result(this.isOk, this.value);

  Result.ok(this.value) {
    isOk = true;
  }

  Result.err() {
    isOk = false;
  }

  bool handleIfNotOk(BuildContext context) {
    if(isOk) {
      return true;
    }

    _showSnackbar(context, "Er is iets fout gegaan.");
    return false;
  }

  void _showSnackbar(BuildContext context, String text) {
    Future<void>.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    });
  }
}