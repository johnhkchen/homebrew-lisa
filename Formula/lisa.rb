class Lisa < Formula
  desc "CLI for Lisa DAG-driven concurrent task scheduling"
  homepage "https://github.com/johnhkchen/lisa"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.0/lisa-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c1a94fb0099ba94216618668f08b63691eb8ea1ac0321d613dcd155b8c6ea732"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.0/lisa-cli-x86_64-apple-darwin.tar.xz"
      sha256 "346ac940217c08e4e33ec5bb7c53a84326fddd44878b7a6b478484bbd6f79d07"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.0/lisa-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7fab26e84b08cb5304e7f99aa9ef14546bd826cde6e1ce01d5c83170567ad6cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.0/lisa-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9d8db5773fa6dae7dc259b3d44661a9c96bca85b6aa93e6c0854ed4ca1ea51f1"
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
