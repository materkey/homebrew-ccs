class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.13.0/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "ec5aad820a8995af67b7065fb6e7d6ca6235dcb54409a34c2ec0e829984f0650"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.13.0/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "a713520953ab0ab7d59e656c1f86f46d43e42ab84b40a04784dc06ad321de9dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.13.0/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bd02ee1904a294ca4ec5668874cb3ecc584aa7ad94fe2ea4ec30ff8333846e4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.13.0/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fbe1e731983ab34da4f04bad19c38a4eb988bf72b5350c1e6887236d4e92a0a9"
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
