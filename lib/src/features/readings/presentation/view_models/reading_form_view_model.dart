import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';
import '../../domain/entities/reading.dart';
import '../../domain/entities/reading_draft.dart';
import '../../domain/use_cases/create_reading.dart';

final class ReadingFormViewModel extends ChangeNotifier {
  ReadingFormViewModel([this._createReading]);

  final CreateReading? _createReading;

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

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  String? validateProgress(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) return null;

    final progress = int.tryParse(normalized);
    if (progress == null || progress < 0) {
      return AppStrings.invalidNumber;
    }
    return null;
  }

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

  Future<Reading?> save() async {
    final createReading = _createReading;
    if (createReading == null) return null;

    return createReading(
      ReadingDraft(
        title: titleController.text.trim(),
        author: authorController.text.trim(),
        type: type,
        status: status,
        progress: int.tryParse(progressController.text.trim()) ?? 0,
        score: score,
        tags: _commaSeparatedValues(tagsController.text),
        description: descriptionController.text.trim(),
        alternativeTitles: _commaSeparatedValues(
          alternativeTitlesController.text,
        ),
      ),
    );
  }

  List<String> _commaSeparatedValues(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
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
