class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.17.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.1/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "01d8734d62993a3b4873c28a3531e9d8aee9732b0ee6f65b93c610343d6d93b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.1/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "33c0c3c07aeaae9060bd777096fb6b85fe0e36cff33f4f51f2c9c9e6054157c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.1/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "020c5d329388b197892685912b742a93d7400a353d8accd5622c5d8303eda7c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.1/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "05b0a8ac3c3cc8f5aee4063b374e4ebe5ee5f7f2f388316b751a805ada13ed1b"
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
