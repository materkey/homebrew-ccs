class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.6.1/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "87629805628b1d0765f3c15116e0c7fa852743bfdef6febc57923dfea5c7e280"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.6.1/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "5d4464d593e9a77578bc1abd2e13340da28fd8cffdbc478c10e4127d653f35cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.6.1/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "00293755ae34a7eb1af65e339ba0183320f5013e8ebe2c786b036ea968ab0e44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.6.1/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4c39337ce481c3d7ed2683a20245a3c70e5bbdc40e03035c60bbd05af960aeae"
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
