class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.18.0/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "e723900f2f599314d2e47abae29d0e198857a0f9aa6ad39ee9b9c364134c1bcb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.18.0/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "4d41d53edd779b5746ff0e4b7684f2f278ebd915c9936ac31b79f1fad75a2ece"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.18.0/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "11242cf8d38a39ee0372596730216beb1180beddd7cb03bc3e2a297466ee61e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.18.0/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "74d256fac7c915b39914b7372fa40dba212c0058f8c5dad2212de26f27faf6bc"
    end
  end
  license "MIT"
  depends_on "ripgrep"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
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
      bin.install "ccs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ccs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ccs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ccs"
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
