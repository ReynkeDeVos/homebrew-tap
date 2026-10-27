class AniHop < Formula
  desc "A fast terminal UI for anime: browse, stream and download through ani-cli, with AniList sync"
  homepage "https://github.com/ReynkeDeVos/ani-hop"
  version "0.7.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.7.5/ani-hop-aarch64-apple-darwin.tar.xz"
    sha256 "dff4007371c84dd4808f326cac711d59fa725980e75bdfee5cc2e976ed25c9a8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.7.5/ani-hop-aarch64-unknown-linux-musl.tar.xz"
      sha256 "76ed304c7609dceb034ca1096686cea5d3631ed35f2c546955b847f2584a8a33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.7.5/ani-hop-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f419bcd27cf056fd2efa265d4b8be55e34f15566ede8ff1612185f8e5554135c"
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
