import 'dart:io';
import 'package:catdog/core/utils/compress_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_analysis.g.dart';

@riverpod
class PetAnalysis extends _$PetAnalysis {
  // 1. 상태 관리를 위한 변수들 (클래스 멤버 변수)
  final List<String> _apiKeys = [
    dotenv.env['GEMINI_API_KEY'] ?? '',
    dotenv.env['GEMINI_API_KEY_2'] ?? '',
    dotenv.env['GEMINI_API_KEY_3'] ?? '',
  ];

  final List<String> _modelNames = [
    'gemini-3-flash-preview',
    'gemini-2.5-flash',
    'gemini-2.5-flash-lite',
  ];

  int _currentKeyIndex = 0;
  int _currentModelIndex = 0;

  @override
  FutureOr<bool?> build() => null;

  Future<bool> _callGeminiApi(File compressedFile) async {
    final imageBytes = await compressedFile.readAsBytes();

    for (int m = _currentModelIndex; m < _modelNames.length; m++) {
      for (int k = _currentKeyIndex; k < _apiKeys.length; k++) {
        final modelName = _modelNames[m];
        final apiKey = _apiKeys[k];

        try {
          print("시도 중: 모델[$modelName], 키 인덱스[$k]");

          final model = GenerativeModel(
            model: modelName,
            apiKey: apiKey,
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
              temperature: 0.1,
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
              SafetySetting(
                HarmCategory.sexuallyExplicit,
                HarmBlockThreshold.none,
              ),
              SafetySetting(
                HarmCategory.dangerousContent,
                HarmBlockThreshold.none,
              ),
            ],
          );

          final response = await model.generateContent([
            Content.multi([
              TextPart(
                "Return JSON: {'found': true} if a dog or cat is clearly visible. "
                "If you are not sure, the image is blurry, or the animal is not a dog or cat, "
                "return {'found': false}. Only return valid JSON.",
              ),
              DataPart('image/jpeg', imageBytes),
            ]),
          ]);

          if (response.text != null) {
            // 성공 시: 현재 모델과 키 위치를 고정하고 결과 반환
            _currentModelIndex = m;
            _currentKeyIndex = k;
            print("response : ${response.text}");
            return response.text!.toLowerCase().contains('true');
          }
        } catch (e) {
          // 할당량 초과(429) 발생 시 다음 키로 이동
          if (e.toString().contains('429') || e.toString().contains('quota')) {
            print("Key $k 의 할당량 초과. 다음 키로 전환합니다.");
            continue; // 내부 루프(키 변경) 계속
          }
          print("알 수 없는 에러 발생: $e");
          break;
        }
      }

      // 현재 모델의 모든 키를 다 썼다면, 다음 모델의 첫 번째 키부터 다시 시작
      _currentKeyIndex = 0;
    }

    print("모든 모델과 API 키의 할당량이 소진되었습니다.");
    return true;
  }

  Future<void> startAnalysis(XFile rawFile) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final File originalFile = File(rawFile.path);
      final compressedFile = await compressImage(originalFile);
      if (compressedFile == null) throw Exception("압축 실패");

      return await _callGeminiApi(compressedFile);
    });
  }
}
