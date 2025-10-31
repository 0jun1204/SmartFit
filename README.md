# SmartFit

AI 기반 자세 교정 및 운동 추적 Flutter 앱

## 📱 프로젝트 소개

SmartFit은 Google ML Kit의 Pose Detection을 활용하여 사용자의 운동 자세를 실시간으로 분석하고 피드백을 제공하는 지능형 헬스케어 애플리케이션입니다. 스쿼트, 푸시업, 런지 등 다양한 운동의 자세를 모니터링하여 부상 방지 및 효과적인 운동을 돕습니다.

## ✨ 주요 기능

### 🤖 AI 자세 분석
- **실시간 자세 인식**: 카메라를 통한 실시간 운동 자세 감지
- **자세 피드백**: 잘못된 자세에 대한 음성 및 시각적 피드백 제공
- **지원 운동**: 스쿼트, 푸시업, 런지 등 다양한 운동 지원

### 📊 운동 기록 및 추적
- **운동 이력 관리**: Firebase를 통한 운동 기록 저장
- **달력 기반 히스토리**: 과거 운동 기록 확인
- **통계 대시보드**: 운동 데이터 시각화

### 🏋️ 운동 학습
- **3D 운동 가이드**: model_viewer를 활용한 3D 모델 제공
- **운동 이미지**: 각 운동별 정확한 자세 안내

### 🛒 상품 추천
- **운동용품 추천**: 운동 관련 상품 추천 기능
- **카테고리별 분류**: 단백질, 운동복, 운동기구 등

### 🔐 사용자 관리
- **회원가입/로그인**: Firebase Authentication 기반 사용자 인증
- **개인화된 경험**: 사용자별 맞춤 운동 데이터 관리

## 🛠 기술 스택

### 프레임워크 & 언어
- **Flutter** 3.5.3
- **Dart**

### AI/ML
- **Google ML Kit Pose Detection**: 실시간 자세 인식
- **MoveNet**: 고성능 포즈 추정 모델
- **PoseNet**: 로컬 포즈 추정 모델

### 백엔드 & 데이터베이스
- **Firebase Authentication**: 사용자 인증
- **Cloud Firestore**: 실시간 데이터베이스
- **Firebase Core**: Firebase 초기화

### 주요 패키지
- **camera**: 카메라 기능 제어
- **model_viewer_plus**: 3D 모델 렌더링
- **table_calendar**: 달력 UI
- **just_audio**: 음성 피드백 재생
- **url_launcher**: 외부 링크 실행
- **webview_flutter**: 웹뷰 기능
- **intl**: 날짜/시간 포맷팅

## 📁 프로젝트 구조

```
smartfit/
├── lib/
│   ├── main.dart                      # 앱 진입점
│   ├── camera_view.dart               # 카메라 뷰
│   ├── pose_detector_view.dart        # 자세 감지 뷰
│   ├── pose_painter.dart              # 자세 그리기
│   ├── coordinates_translator.dart    # 좌표 변환
│   ├── exercise_selection_screen.dart # 운동 선택 화면
│   ├── exercise_summary_screen.dart   # 운동 요약 화면
│   ├── firebase_service.dart          # Firebase 서비스
│   ├── models/                        # 데이터 모델
│   │   ├── user_model.dart
│   │   └── workout_record.dart
│   ├── screens/                       # 화면 위젯
│   │   ├── main_home_screen.dart
│   │   ├── exercise_learning.dart
│   │   ├── health_dashboard_screen.dart
│   │   ├── workout_history_screen.dart
│   │   ├── posture_screen.dart
│   │   ├── product_recommendation_screen.dart
│   │   ├── signup_screen.dart
│   │   └── ...
│   └── services/                      # 비즈니스 로직
│       ├── auth_service.dart
│       └── workout_service.dart
├── assets/
│   ├── audio/                         # 음성 피드백 파일
│   ├── images/                        # 이미지 리소스
│   └── models/                        # 3D 모델 & ML 모델
│       ├── human_muscle_*.glb
│       ├── movenet.tflite
│       └── posenet.tflite
├── android/                           # Android 플랫폼 코드
├── ios/                               # iOS 플랫폼 코드
├── web/                               # Web 플랫폼 코드
├── windows/                           # Windows 플랫폼 코드
├── linux/                             # Linux 플랫폼 코드
├── macos/                             # macOS 플랫폼 코드
└── pubspec.yaml                       # 프로젝트 설정

```

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK (3.5.3 이상)
- Dart SDK
- Firebase 프로젝트
- Android Studio / Xcode (플랫폼별)

### 설치 방법

1. **저장소 클론**
```bash
git clone https://github.com/0jun1204/Smartfit.git
cd smartfit
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **Firebase 설정**
   - Firebase Console에서 프로젝트 생성
   - `android/app/google-services.json` 파일 추가
   - iOS의 경우 `ios/Runner/GoogleService-Info.plist` 추가

4. **앱 실행**
```bash
flutter run
```

## 📱 지원 플랫폼

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ Linux
- ✅ macOS

## 🔧 개발 환경 설정

### Android
```bash
flutter config --android-sdk ~/Android/Sdk
```

### iOS (macOS만)
```bash
open ios/Runner.xcworkspace
```

## 📝 주요 화면

1. **로그인/회원가입**: Firebase 인증 기반 사용자 관리
2. **메인 홈**: 운동 선택 및 빠른 접근
3. **운동 선택**: 스쿼트, 푸시업, 런지 등 운동 종류 선택
4. **자세 감지**: 실시간 카메라 기반 자세 분석
5. **운동 이력**: 과거 운동 기록 및 통계
6. **운동 학습**: 3D 모델을 통한 자세 안내
7. **상품 추천**: 운동 관련 용품 추천

## 🎯 향후 계획

- [ ] 더 많은 운동 종류 추가
- [ ] 심박수 연동 기능
- [ ] 소셜 기능 (친구 추가, 경쟁)
- [ ] 개인화된 운동 플랜 생성
- [ ] 음성 인식 기반 명령 제어

## 📄 라이선스

이 프로젝트는 개인 학습 및 개발 목적으로 제작되었습니다.

## 👥 기여

개선 사항이나 버그 리포트는 Issues를 통해 제출해주세요.

## 📧 연락처

프로젝트에 대한 문의사항이 있으시면 GitHub Issues를 이용해주세요.

---

**SmartFit**으로 더 안전하고 효과적인 운동을 시작하세요! 💪
