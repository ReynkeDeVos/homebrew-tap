class AniHop < Formula
  desc "A fast terminal UI for anime: browse, stream and download through ani-cli, with AniList sync"
  homepage "https://github.com/ReynkeDeVos/ani-hop"
  version "0.6.11"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.11/ani-hop-aarch64-apple-darwin.tar.xz"
    sha256 "402df9cb3f31f31771c1c59b326787aff6812e1c4da16e5de04f2320a039413e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.11/ani-hop-aarch64-unknown-linux-musl.tar.xz"
      sha256 "37ab7a162fd1ddd622491021035ecc708e4e21dc220fd78c1c4f2952e23bfd52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.11/ani-hop-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5e1775c983409c560b401c731529a4bc9cd0fb532a15ef05124f6f147681b9ab"
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
