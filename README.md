# SimpleImageListWithTuist

Tuist를 활용한 모듈형 이미지 리스트 애플리케이션입니다. 이 프로젝트는 Tuist를 사용하여 모듈화된 아키텍처로 구성되어 있으며, 각 모듈은 독립적인 책임을 가지고 있습니다.

## 프로젝트 구조

이 프로젝트는 다음과 같은 모듈로 구성되어 있습니다:

- **Main**: 애플리케이션의 진입점 및 메인 화면을 담당하는 모듈
- **API**: 네트워크 통신 및 API 서비스를 담당하는 모듈
- **Domain**: 비즈니스 로직 및 모델을 담당하는 모듈
- **Presentation**: UI 컴포넌트 및 화면 표시를 담당하는 모듈
- **Util**: 유틸리티 함수 및 공통 기능을 담당하는 모듈

각 모듈은 다음과 같은 구조로 이루어져 있습니다:
```
ModuleName/
├── Sources/
│   └── ModuleName/
├── Tests/
├── .swiftlint.yml
└── Project.swift
```

## 의존성 그래프

아래 그래프는 각 모듈 간의 의존성 관계를 보여줍니다:

![의존성 그래프](https://private-us-east-1.manuscdn.com/sessionFile/7B7YJIEYiYHQDpi4As66Ms/sandbox/diz2AlcMSLSOizdlvGDo8G-images_1744432897335_na1fn_L2hvbWUvdWJ1bnR1L2dyYXBo.png?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvN0I3WUpJRVlpWUhRRHBpNEFzNjZNcy9zYW5kYm94L2RpejJBbGNNU0xTT2l6ZGx2R0RvOEctaW1hZ2VzXzE3NDQ0MzI4OTczMzVfbmExZm5fTDJodmJXVXZkV0oxYm5SMUwyZHlZWEJvLnBuZyIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTc2NzIyNTYwMH19fV19&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=dDqmUQqAia0qPBNiYzSIPV1iM1NuRRZSRg6Ej8~Md80jvSCmHTd~SxUxIdZFmPSwTWdph7EXX8uEryhykia7c~ORRvfDwfS3zDYoTAgzUsZOM3aH~lvx1wak48Vt9hz3CyCr3wLbpHwWH2FnrQttclkWrHBLF6XRXJnXUoPp26vWKftaHD-p53R-EfNVMEWF3PVqBLZAADYSbi8wolWVTM9wP84Ysh7pAwWpVDhNMxs4BonvtyWU0OaeTP4fvc9XMI7szVIjmf68v--mpuHtTPzoQPlFqTDKFuRzZaOEU5P-S-DU-MfPwbwlLnNaZCWQO6x2Phwf2Fg5ySp8H15ztw__)

그래프에서 볼 수 있듯이:
- Main 모듈은 Presentation, Domain, API 모듈에 의존합니다.
- Presentation 모듈은 Domain 모듈과 UIKit에 의존합니다.
- API 모듈은 Domain 모듈과 JHAPIService에 의존합니다.
- 모든 모듈은 SwiftLintBuildToolPlugin을 사용합니다.

## Tuist 사용 방법

이 프로젝트는 [Tuist](https://tuist.io/)를 사용하여 관리됩니다. Tuist는 Xcode 프로젝트 생성 및 관리를 자동화하는 도구입니다.

### 필수 조건

- Xcode 14.0 이상
- Swift 5.7 이상
- Tuist 설치(4.47기반 작성)

### Tuist 설치

```bash
curl -Ls https://install.tuist.io | bash
```

### 프로젝트 생성

프로젝트 루트 디렉토리에서 다음 명령어를 실행합니다:

```bash
tuist generate
```

이 명령어는 Workspace.swift와 각 모듈의 Project.swift 파일을 기반으로 Xcode 프로젝트와 워크스페이스를 생성합니다.

### 프로젝트 실행

생성된 `.xcworkspace` 파일을 Xcode로 열고 실행합니다:

```bash
open *.xcworkspace
```

## 주요 기능

이 프로젝트는 다음과 같은 기능을 제공합니다:

- 이미지 목록 표시
- 모듈화된 아키텍처
- Tuist를 활용한 프로젝트 관리

## 기술 스택

- Swift 5.7
- UIKit
- Tuist
- SwiftLint

## 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다.
