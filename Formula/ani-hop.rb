class AniHop < Formula
  desc "A fast terminal UI for anime: browse, stream and download through ani-cli, with AniList sync"
  homepage "https://github.com/ReynkeDeVos/ani-hop"
  version "0.6.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.8/ani-hop-aarch64-apple-darwin.tar.xz"
    sha256 "efe635e8799e42dfc152eeb85a1a015938b6cd8f9f92339d8db9e4f2e21e4624"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.8/ani-hop-aarch64-unknown-linux-musl.tar.xz"
      sha256 "347d415f04f962da91e5ebdc9c8d4f2d0d328b6f5aaacef0c8ff70bb617f1d49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.8/ani-hop-x86_64-unknown-linux-musl.tar.xz"
      sha256 "61bf39e4c4a6dc99940c181c649fcd657e883eb6da9294b889afe62fcba565a5"
    end
  end
  license "GPL-3.0-or-later"
  depends_on "mpv"
  depends_on "yt-dlp"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ani-hop"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ani-hop"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ani-hop"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
