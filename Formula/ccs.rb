class Ccs < Formula
  desc "A TUI and CLI tool for searching and browsing Claude Code and Claude Desktop session history"
  homepage "https://github.com/materkey/ccfullsearch"
  version "0.18.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.18.1/ccfullsearch-aarch64-apple-darwin.tar.gz"
      sha256 "cac409173f547d4ad68de6b292dbc69a698acde40c84d29a1dea779d6179ad04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.18.1/ccfullsearch-x86_64-apple-darwin.tar.gz"
      sha256 "c9f24e1593c9d7017c2bcf0a44fb2bebad01aec0bf10f17fb1e7a5268138f1ac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.18.1/ccfullsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2f9556b575dd1d3fe3001bb8060012e1bd00c89aee621288ac21237db12db42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/materkey/ccfullsearch/releases/download/v0.18.1/ccfullsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "323a1d58414fb7a0b5c540d9614e0781aa5c77bad3d0301d009dc5eb8e7ca8d2"
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
