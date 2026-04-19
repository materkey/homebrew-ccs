class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.10.0/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "654614afe3f3e86afa7597357209559547a7b6ddb9712730af6fcae452dcddc5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.10.0/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "7fa8c7251bb207f75a360b1b21c6b985cbb082513f176effc54a503b3d38bae6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.10.0/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5ba98d6a8af7a921382948e04eb515267ccdb5d9b281faeb00d60613c38e4040"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.10.0/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bee47763dff2da912910d51b2260d8fff8762257efe4df142460de57742da778"
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
