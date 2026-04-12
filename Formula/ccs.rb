class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.9.0/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "eb6e23e6ec5ff065fb0d60007e67da9f313a2dc01cdf2f2dce898d96b51b5e6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.9.0/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "5b21acae7a45620db7ee6c008995988235a94cf211b81819c029a4bb8ea6475c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.9.0/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d675ef147fedc846a1cca2c9284a08bfa793d7e048778d854cfad2a54386997"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.9.0/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9c2344fb4179dde315382975672fc064790655c40ac48491b0e495361e0ef90d"
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
    bin.install "ccs" if OS.mac? && Hardware::CPU.arm?
    bin.install "ccs" if OS.mac? && Hardware::CPU.intel?
    bin.install "ccs" if OS.linux? && Hardware::CPU.arm?
    bin.install "ccs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
