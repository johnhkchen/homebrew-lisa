class Lisa < Formula
  desc "CLI for Lisa DAG-driven concurrent task scheduling"
  homepage "https://github.com/johnhkchen/lisa"
  version "0.4.4-rc.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.4.4-rc.3/lisa-cli-aarch64-apple-darwin.tar.gz"
      sha256 "6b00aedc8482e14aa1a07a49af852dd5726d713d1596fd12e06313080e133ec6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.4.4-rc.3/lisa-cli-x86_64-apple-darwin.tar.gz"
      sha256 "510bd4889c4a2bcd1cdc63549bf3bd4783c2103f6a30dd3cf5fdc89959a0fd7c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.4.4-rc.3/lisa-cli-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f222468d1d57cc6c1e59dc645afb73135a7c5094c0b057fccd01dfa118563c4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.4.4-rc.3/lisa-cli-x86_64-unknown-linux-musl.tar.gz"
      sha256 "aa1fe22cd80290327b7cc729f10530ab654a9a28d9ae76b5ee7c2c7f274e4a62"
    end
  end
  license "MIT"

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
    bin.install "lisa" if OS.mac? && Hardware::CPU.arm?
    bin.install "lisa" if OS.mac? && Hardware::CPU.intel?
    bin.install "lisa" if OS.linux? && Hardware::CPU.arm?
    bin.install "lisa" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
