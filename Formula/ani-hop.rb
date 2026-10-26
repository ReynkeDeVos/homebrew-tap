class AniHop < Formula
  desc "A fast terminal UI for anime: browse, stream and download through ani-cli, with AniList sync"
  homepage "https://github.com/ReynkeDeVos/ani-hop"
  version "0.6.15"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.15/ani-hop-aarch64-apple-darwin.tar.xz"
    sha256 "41ec1bee80328f40aceedb2e08901434c8404900730ba35615d30872ceca76e7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.15/ani-hop-aarch64-unknown-linux-musl.tar.xz"
      sha256 "fd99bd06a21c7d6eae88d4b8131c738979b332e4cf5ad95f5a5052ed764bfbc2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.6.15/ani-hop-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2c5ff2ef1cf01b7857ef6cf9d99ce647a2f87549a221ee5b6a1d01fc38ac6ef1"
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
