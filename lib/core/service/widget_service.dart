import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

/// HomeScreen Widget 관리 서비스
class WidgetService {
  static const String _androidFrameWidgetName = 'FrameWidgetProvider';
  static const String _androidPostWidgetName = 'PostWidgetProvider';
  static const String _iosGroupId = 'group.com.team.catdog.catdog'; // Xcode에서 설정한 App Group ID와 일치해야 함

  static Future<void> _initAppGroup() async {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(_iosGroupId);
    }
  }
  
  /// 최신 피드 이미지 URL을 위젯에 저장하고 업데이트
  static Future<void> updateLatestImageUrl(String? imageUrl) async {
    debugPrint('WidgetService: updateLatestImageUrl called. URL: $imageUrl');
    try {
      await _initAppGroup();
      // 데이터 저장
      await HomeWidget.saveWidgetData<String>('latest_image_url', imageUrl ?? '');
      debugPrint('WidgetService: Data saved to UserDefaults');
      
      // 위젯 새로고침
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          name: _androidFrameWidgetName,
          qualifiedAndroidName: 'com.team.catdog.catdog.$_androidFrameWidgetName',
        );
      } else if (Platform.isIOS) {
        debugPrint('WidgetService: Requesting iOS Widget Update (CatdogWidget)');
        final result = await HomeWidget.updateWidget(
          name: 'CatdogWidget',
          iOSName: 'CatdogWidget',
        );
        debugPrint('WidgetService: iOS Update Result: $result');
      }
    } catch (e) {
      debugPrint('WidgetService.updateLatestImageUrl error: $e');
    }
  }
  
  /// 위젯 클릭으로 앱이 시작되었는지 확인
  static Future<Uri?> getInitialWidgetUri() async {
    try {
      await _initAppGroup();
      return await HomeWidget.initiallyLaunchedFromHomeWidget();
    } catch (e) {
      print('WidgetService.getInitialWidgetUri error: $e');
      return null;
    }
  }
  
  /// 위젯 클릭 이벤트 스트림 구독
  static Stream<Uri?> get widgetClickedStream => HomeWidget.widgetClicked;
  
  /// 로그아웃 시 위젯 데이터 초기화
  static Future<void> clearWidgetData() async {
    try {
      await _initAppGroup();
      await HomeWidget.saveWidgetData<String>('latest_image_url', '');
      
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          name: _androidFrameWidgetName,
          qualifiedAndroidName: 'com.team.catdog.catdog.$_androidFrameWidgetName',
        );
      } else if (Platform.isIOS) {
        await HomeWidget.updateWidget(
          name: 'CatdogWidget',
          iOSName: 'CatdogWidget',
        );
      }
    } catch (e) {
      print('WidgetService.clearWidgetData error: $e');
    }
  }
}
