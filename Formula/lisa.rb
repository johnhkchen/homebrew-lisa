class Lisa < Formula
  desc "CLI for Lisa DAG-driven concurrent task scheduling"
  homepage "https://github.com/johnhkchen/lisa"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.3/lisa-cli-aarch64-apple-darwin.tar.xz"
      sha256 "44e3e28ae315cd4b604cb99187983db0a45992aa76b466465f08fb129532aea0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.3/lisa-cli-x86_64-apple-darwin.tar.xz"
      sha256 "724223a1c13c4e2dc2e07424b2fc73fd6a5e467ee4caa959b54b3ce01095c4d9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.3/lisa-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "265c7319e0aac0b98595941cf1f7b4e4031fc9d85c289d0d45e9cb79bf4d4db3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.3/lisa-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e3b66f545729549d2548a287a007078ad32d43b3d054858d2b3f8439d04d736a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
