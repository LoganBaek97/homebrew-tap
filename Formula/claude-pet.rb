class ClaudePet < Formula
  desc "macOS desktop pet that reacts to Claude Code session state"
  homepage "https://github.com/LoganBaek97/claude-pet"
  url "https://github.com/LoganBaek97/claude-pet/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "05e8e8f656345a779558d17c4831a331ec52082d5c6b5d96e05acbdb36b11e71"
  license "MIT"
  head "https://github.com/LoganBaek97/claude-pet.git", branch: "main"

  # Xcode 는 필요 없다. Command Line Tools 의 Swift 툴체인과 macOS SDK 로 빌드된다.
  # Homebrew 는 소스 빌드에 CLT 를 이미 요구하므로 따로 선언하지 않는다.
  depends_on macos: :sonoma

  def install
    # 설치하는 기계에서 빌드하므로 유니버설이 필요 없다.
    ENV["CLAUDE_PET_UNIVERSAL"] = "0"
    # Homebrew 가 이미 샌드박스 안에서 돌리므로 SwiftPM 이 샌드박스를 또 만들면 실패한다.
    ENV["CLAUDE_PET_SWIFT_FLAGS"] = "--disable-sandbox"
    system "sh", "scripts/bundle.sh", "release"
    prefix.install "dist/ClaudePet.app"

    # CLI 는 심링크로 걸면 안 된다. 앱은 실행 파일 경로에 .app/Contents/MacOS 가
    # 들어 있어야 훅 스크립트와 내장 펫을 찾는데, 심링크는 그 경로를 잃는다.
    # opt_prefix 는 버전이 올라가도 그대로라 훅에 박히는 경로가 깨지지 않는다.
    (bin/"claude-pet").write <<~SH
      #!/bin/sh
      exec "#{opt_prefix}/ClaudePet.app/Contents/MacOS/claude-pet" "$@"
    SH
    chmod 0755, bin/"claude-pet"
  end

  def caveats
    <<~EOS
      훅을 설치해야 펫이 세션 상태를 받는다. ~/.claude/settings.json 을 고치며 백업을 남긴다.
        claude-pet install-hooks

      Finder·Spotlight 에서 앱을 열려면 /Applications 에 연결한다.
        ln -sfn #{opt_prefix}/ClaudePet.app /Applications/ClaudePet.app

      펫을 받고 앱을 띄운다.
        claude-pet add guga
        open #{opt_prefix}/ClaudePet.app

      로그인 시 자동 실행(claude-pet login-item on)은 Apple 서명이 없는 빌드라
      macOS 가 거부할 수 있다. 그 경우 시스템 설정의 로그인 항목에 직접 추가한다.
    EOS
  end

  test do
    assert_match "훅:", shell_output("#{bin}/claude-pet status")
  end
end
