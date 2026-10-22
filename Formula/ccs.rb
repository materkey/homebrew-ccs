class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.0/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "6e2f2a8b49455438b7917e3a3b7e9afcfa4d31824bb69eac5216b5201122dbeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.0/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "796e5fc24438c2b963e79d980356197adbd4191ce238957a93b800dd4e2738d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.0/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3720ce7254db173d34231de071e03de4540b5c0e38752ef45c276735ab9626ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.0/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5b68a62168e33c387aa17535589c6cacd9b20e7c902b21c657cc45135ffe35df"
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
