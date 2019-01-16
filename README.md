# Annotation for iOS

이 소스코드는 아이패드에서 작동하는 Annotation 도구입니다.

## 중요 포인트

최신 개발 언어는 Swift이지만, 언어 버전이 올라가면서 하위 호환성 문제가 생기기 때문에 Objective-C로 제작됩니다.

소스 패키지는 CocoaPod이 사용됩니다.

## 다른 프로젝트와의 연결

이 프로젝트에서 이미지 프로세싱을 직접 처리한다면 서버의 이미지 변환과 완벽히 같아야 합니다. skia가 멀티플랫폼 환경을 지원하지만, 대부분의 이미지 프로세스 라이브러리가 c로 제작되기 때문에 이 프로젝트로 포팅할 경우 정밀한 테스팅이 되어야 합니다.