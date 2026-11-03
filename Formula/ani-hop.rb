class AniHop < Formula
  desc "A fast terminal UI for anime: browse, stream and download through ani-cli, with AniList sync"
  homepage "https://github.com/ReynkeDeVos/ani-hop"
  version "0.9.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.9.0/ani-hop-aarch64-apple-darwin.tar.xz"
    sha256 "90d91fdb1db880a2383bb74b18a380b61f5f597455d2d906e10b6168ba686480"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.9.0/ani-hop-aarch64-unknown-linux-musl.tar.xz"
      sha256 "87d407b048a4b0b7c1d2555a498f7861315dba07c6c2abaa733488151f3aba0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ReynkeDeVos/ani-hop/releases/download/v0.9.0/ani-hop-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d5e4bfc72333cc007b06f15a884211b003fb95f3d9710e5349ce784e73dc2e75"
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
