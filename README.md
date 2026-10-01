# homebrew-tap

[LoganBaek97](https://github.com/LoganBaek97) 의 Homebrew tap.

```sh
brew trust LoganBaek97/tap
brew tap LoganBaek97/tap
```

Homebrew 7 부터 서드파티 tap 은 신뢰를 먼저 밝혀야 읽힌다. tap 의 포뮬러는 설치할 때
임의의 코드를 실행할 수 있으니, 신뢰하기 전에 [포뮬러](Formula/claude-pet.rb)를 읽어 보길 권한다.

## 포뮬러

| 이름 | 설명 |
| --- | --- |
| [claude-pet](https://github.com/LoganBaek97/claude-pet) | Claude Code 세션 상태에 반응하는 macOS 데스크톱 펫 |

```sh
brew install LoganBaek97/tap/claude-pet
```

macOS 14 이상이 필요하다. Apple Silicon(macOS 14 이상)과 Intel(macOS 15 이상)은 미리 빌드한
bottle 을 받아 몇 초 만에 끝나고, Command Line Tools 버전도 따지지 않는다.

bottle 이 없는 환경(Intel Sonoma, `--build-from-source`, `--HEAD`)은 소스에서 빌드하므로 Command Line
Tools 가 필요하다. Xcode 는 필요 없다. `Your Command Line Tools are too outdated` 오류가 나면 Command
Line Tools 를 갱신한다. 자세한 절차는 [claude-pet 의 요구 사항](https://github.com/LoganBaek97/claude-pet#요구-사항)에 있다.

설치 후 안내(`caveats`)에 나오는 훅 설치와 `/Applications` 연결을 마저 한다.

## 릴리스 절차

bottle 은 [`brew test-bot`](.github/workflows/tests.yml) 과 [`brew pr-pull`](.github/workflows/publish.yml) 로 만든다.
포뮬러는 main 에 바로 커밋하지 않고 PR 로 올린다.

1. 브랜치에서 포뮬러의 `url` 과 `sha256` 을 새 태그로 바꾸고 PR 을 연다.
   `sha256` 은 `curl -sL <url> | shasum -a 256` 으로 구한다.
2. `brew test-bot` 이 macOS 러너마다 소스에서 빌드하고, 만든 bottle 로 다시 설치해 `brew test` 를 돌린 뒤
   bottle 을 PR 아티팩트로 올린다.
3. 초록불이면 Actions 의 `brew pr-pull` 워크플로를 PR 번호로 실행한다.
   bottle 이 이 저장소의 릴리스(`claude-pet-<버전>`)에 올라가고, 포뮬러에 `bottle do` 블록을 붙인 커밋이
   main 에 들어가며 PR 은 닫힌다.

포뮬러만 고친 PR 이어야 한다. 워크플로나 README 를 함께 바꾸면 `brew pr-pull` 이 커밋을 정리하지 못한다.
