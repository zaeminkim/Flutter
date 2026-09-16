# 미니프로젝트

## 프로젝트명: Sportoo

### 프로젝트 개요

Sportoo는 스포츠 경기 관람 경험을 더 편리하고 몰입감 있게 만들기 위한 모바일 애플리케이션입니다. 경기장에 방문한 사용자가 모바일 티켓을 빠르게 확인하고, AR 어시스턴트를 통해 경기 관람에 필요한 정보를 얻으며, 경기장 편의 시설과 프로필 설정을 한 앱 안에서 사용할 수 있도록 기획되었습니다.

기존 스포츠 관람 앱이 티켓 확인이나 일정 안내에 머무르는 경우가 많다면, Sportoo는 "경기장 안에서 실제로 필요한 기능"에 초점을 맞춥니다. 사용자는 시작 화면에서 원하는 스포츠를 선택하고, 홈 화면에서 모바일 티켓, AR, 편의 정보, 프로필 기능을 탭 기반으로 전환하며 사용할 수 있습니다.

### 프로젝트 캐치 프레이즈
**Symbol:** 경기장을 형상화한 어두운 배경 위에 떠 있는 초록색 `S` 심볼  
**Meaning:** Sportoo의 심볼은 스포츠의 역동성과 경기장 경험의 확장을 의미합니다. 입체적인 `S`는 Sportoo, Sport, Stadium을 상징하며, 경기장 위에 떠 있는 형태는 사용자가 현실 경기 관람 위에 디지털 편의 기능을 더해가는 경험을 표현합니다.

## 주요 기능 설명

### 1. 스포츠 선택

- 스포츠 카드 스와이프: 축구, 농구, 배구, 야구 카드를 좌우로 스와이프하여 원하는 스포츠를 선택할 수 있습니다.
- 카드형 UI: 중앙의 선택된 스포츠 카드는 크게 표시되고, 양옆의 스포츠 카드는 흐릿하게 보이도록 구성하여 현재 선택 상태를 직관적으로 보여줍니다.
- 페이지 인디케이터: 하단의 점 표시를 통해 현재 몇 번째 스포츠를 보고 있는지 확인할 수 있습니다.
- 홈 화면 진입: `선택하기` 버튼을 누르면 선택한 스포츠 기준으로 앱의 홈 화면으로 이동합니다.

### 2. 모바일 티켓

- 티켓 이미지 표시: 홈 화면의 `모바일 티켓` 탭에서 경기 티켓을 이미지 형태로 확인할 수 있습니다.
- 티켓 확대 보기: 티켓을 터치하면 티켓이 확대되어 세부 정보를 더 크게 볼 수 있습니다.
- 외부 영역 터치 복귀: 확대된 티켓이 아닌 영역을 터치하면 원래 크기의 티켓 화면으로 돌아옵니다.
- 경기장 입장 흐름 고려: QR 코드, 좌석, 게이트 정보가 포함된 티켓 UI를 통해 실제 입장권 확인 흐름을 반영했습니다.

### 3. AR 어시스턴트

- AR 안내 화면: AR 탭에서는 스포츠 경기 관람을 돕는 AR 어시스턴트 기능을 소개합니다.
- 카메라 실행: `AR 어시스턴트 사용하기` 버튼을 누르면 실제 기기 카메라가 실행됩니다.
- 좌석 및 선수 정보 안내 컨셉: 나의 좌석을 직관적으로 안내하고, 필드 위 선수 정보를 확인할 수 있는 기능을 목표로 구성했습니다.
- 시각적 브랜딩: AR 기능의 성격이 잘 드러나도록 전용 AR 그래픽 이미지를 사용했습니다.

### 4. 편의 정보

- 경기장 지도 이미지: 편의 탭에서 경기장 구역 및 시설 안내 이미지를 확인할 수 있습니다.
- 상단/하단 구역 안내: 경기장의 일부 좌석 구역과 전체 구역도를 이미지로 제공하여 사용자가 위치와 이동 동선을 파악할 수 있도록 했습니다.
- 스크롤 기반 정보 확인: 긴 안내 이미지를 자연스럽게 확인할 수 있도록 스크롤 화면으로 구성했습니다.

### 5. 프로필 및 설정

- 마이페이지: 사용자 이름, 프로필 아이콘, 내 정보, 내 리뷰, 문의하기, 약관, 로그아웃 메뉴를 제공합니다.
- 설정 탭: 푸시 알림, 경기 시작 전 알림, 이벤트 알림, 기본 스포츠, 기본 경기장, 위치 정보 사용, 다크모드, 앱 버전 정보를 제공합니다.
- 다크모드 전환: 설정 화면의 다크모드 스위치를 켜면 실제 앱 UI가 다크 테마로 전환됩니다.
- 앱 버전 표시: 현재 앱 버전 `1.0.0`을 설정 화면에서 확인할 수 있습니다.

### 6. 앱 브랜딩 및 시스템 UI

- Liquid Glass 하단 메뉴바: 홈 화면 하단에 반투명, 블러, 그림자 효과를 활용한 liquid glass 스타일 메뉴바를 구현했습니다.
- 앱 아이콘 적용: Sportoo 전용 아이콘 이미지를 Android 및 iOS 런처 아이콘으로 적용했습니다.
- 스플래시 화면: 앱 시작 시 Sportoo의 어두운 배경과 아이콘이 함께 보이는 네이티브 스플래시 화면을 적용했습니다.
- Pretendard 폰트 적용: 앱 전체에 Pretendard 계열 폰트를 적용하여 한글 UI의 가독성과 통일감을 높였습니다.

## 실행화면 구성

현재 앱은 다음 화면 흐름을 중심으로 구성되어 있습니다.

1. 스포츠 선택 화면
2. 홈 화면 - 모바일 티켓 탭
3. 홈 화면 - AR 탭
4. 홈 화면 - 편의 탭
5. 프로필 화면 - 마이페이지
6. 프로필 화면 - 설정

## 본인이 구현한 부분

기획 및 컨셉 설계: 스포츠 관람 중 사용자가 실제로 필요로 하는 기능을 중심으로 앱의 목적과 화면 흐름을 구성했습니다.

UI/UX 디자인 반영: Figma로 설계한 시작 화면, 홈 화면, AR 화면, 프로필 화면을 Flutter 코드로 구현하고, 카드 스와이프, 티켓 확대, 탭 전환, 설정 스위치 등 기본 인터랙션을 추가했습니다.

브랜드 시스템 적용: Sportoo 앱 아이콘, 스플래시 화면, Pretendard 폰트, liquid glass 하단 메뉴바를 적용하여 앱의 시각적 정체성을 통일했습니다.

기능 구현: AR 버튼을 통한 카메라 실행, 다크모드 실제 테마 전환, 모바일 티켓 확대 보기, 프로필 설정 화면의 스위치 UI 등을 구현했습니다.

## AI 활용 여부 및 활용 범위

본 프로젝트는 UI 구현 및 코드 구조화 과정에서 AI 도구를 활용했습니다.

- Figma 기반 UI 해석: Figma 디자인 및 스크린샷을 참고하여 Flutter 위젯 구조로 변환했습니다.
- Flutter 코드 작성: 화면 레이아웃, 탭 전환, 스와이프 카드, liquid glass 메뉴바, 프로필 설정 화면 등을 AI와 협업하여 구현했습니다.
- 리소스 적용: 앱 아이콘, 스플래시 화면, 폰트, 이미지 에셋을 프로젝트 구조에 맞게 등록하고 연결했습니다.
- 코드 검증: `flutter test`, `flutter analyze`, `dart format`을 반복 실행하며 생성된 코드를 직접 검토하고 수정했습니다.

AI는 전체 코드를 자동으로 완성하는 도구가 아니라, 디자인 의도와 기능 요구사항을 바탕으로 구현을 보조하는 방식으로 활용되었습니다. 생성된 결과는 직접 확인하고 프로젝트에 맞게 수정했습니다.

## 개발 환경

- Flutter SDK
- Dart
- Android / iOS / Web 프로젝트 구조 포함
- Windows 개발 환경

## 사용 패키지

- `cupertino_icons`: iOS 스타일 기본 아이콘 사용
- `image_picker`: AR 어시스턴트 버튼을 통한 네이티브 카메라 실행
- `flutter_launcher_icons`: Android 및 iOS 앱 아이콘 자동 생성
- `flutter_native_splash`: Android, iOS, Web 스플래시 화면 생성
- `flutter_lints`: Flutter 권장 lint 규칙 적용

## 라이센스

이 프로젝트는 MIT License를 따릅니다.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## 오픈소스 라이선스 고지 (Open Source Acknowledgments)

- **Flutter SDK**: BSD 3-Clause License
- **Dart SDK**: BSD 3-Clause License
- **Cupertino Icons**: MIT License
- **image_picker**: BSD 3-Clause License
- **Flutter Launcher Icons**: MIT License
- **Flutter Native Splash**: MIT License
- **Flutter Lints**: BSD 3-Clause License
- **Pretendard / Pretendard JP Font**: SIL Open Font License 1.1

포함된 스포츠 이미지, 경기장 안내 이미지, 모바일 티켓 예시 이미지, AR 그래픽 및 앱 아이콘 이미지는 프로젝트 시연 및 학습 목적의 에셋으로 사용되었습니다. 실제 배포 시에는 각 이미지의 원 저작권 및 사용 허가 범위를 별도로 확인해야 합니다.
