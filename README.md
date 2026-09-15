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

설치 후 안내(`caveats`)에 나오는 훅 설치와 `/Applications` 연결을 마저 한다.
