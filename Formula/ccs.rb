class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.17.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.2/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "d6f0fd6acf125a7a4bf1c99ee4c9d19da4200304e1f886ad7ca2713c12b585ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.2/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "6a834e27b3f33c7f85e791bf85f7904b13359d651a2eae3b509150606ad2fbfa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.2/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "39bf247ce0c29255af93be4da85a0ec9f11b7dfcfecaf53b061b7bc4cb62ba18"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.17.2/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bb85973f3963a7009e72c6dab1cab5faa0843f9a24ea1f883b95a37ee17ab65d"
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
