class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.15.0/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "f08d16762641db1f0ee41a89bd28b5887a3a9617d206914d9427b529b339021f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.15.0/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "49050f706e06d684192f05667afb9cddbc6221e2f080582c55725bd8d022eeb5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.15.0/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7c8cdcc34b2b2a0b889d9cb7d7ac0501cdf144e67d4f215200bc1958c780e03c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.15.0/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e812b7a8ce66848d4e51b124537f066d7d8dea2355dd0f54d4f92779fca71419"
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
