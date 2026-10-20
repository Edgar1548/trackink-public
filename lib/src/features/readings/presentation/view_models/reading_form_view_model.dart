import 'package:flutter/material.dart';

import '../../domain/entities/reading.dart';

final class ReadingFormViewModel extends ChangeNotifier {
  ReadingFormViewModel();

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final progressController = TextEditingController();
  final tagsController = TextEditingController();
  final descriptionController = TextEditingController();
  final alternativeTitlesController = TextEditingController();

  ReadingType _type = ReadingType.manga;
  ReadingStatus _status = ReadingStatus.inProgress;
  double? _score;

  ReadingType get type => _type;
  ReadingStatus get status => _status;
  double? get score => _score;

  void setType(ReadingType value) {
    if (_type == value) return;
    _type = value;
    notifyListeners();
  }

  void setStatus(ReadingStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  void setScore(double? value) {
    if (_score == value) return;
    _score = value;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    progressController.dispose();
    tagsController.dispose();
    descriptionController.dispose();
    alternativeTitlesController.dispose();
    super.dispose();
  }
}
