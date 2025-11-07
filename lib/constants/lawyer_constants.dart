import 'package:dejurebook/models/lawyer_profile.dart';

class LawyerConstants {
  LawyerConstants._();

  static const double verificationFee = 99;

  static const List<LawyerPracticeArea> practiceAreas = [
    LawyerPracticeArea.businessLaw,
    LawyerPracticeArea.criminalLaw,
    LawyerPracticeArea.civilLaw,
    LawyerPracticeArea.familyLaw,
    LawyerPracticeArea.labourLaw,
    LawyerPracticeArea.ipLaw,
  ];

  static const Map<String, double> feeBreakdown = {
    'Formation': 99,
    'State Filing Fees': 0,
    'Operating Agreement': 0,
  };

  static const List<String> supportedFileExtensions = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'png',
    'jpg',
    'jpeg',
  ];

  static const double maxUploadSizeInMb = 5;
}

