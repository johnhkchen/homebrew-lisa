class Lisa < Formula
  desc "CLI for Lisa DAG-driven concurrent task scheduling"
  homepage "https://github.com/johnhkchen/lisa"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.3.0/lisa-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b40834dd99d624b01c2c177948b679cdc5d29367254a4153e6032138158a7069"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.3.0/lisa-cli-x86_64-apple-darwin.tar.xz"
      sha256 "74385a38fcd0f2095a7ca7146b608e43b2d630347672af60c040081f4e154ab7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.3.0/lisa-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "304c5e6e35387ebed5adc292375886ce60a3bf5ad0dfe5a914c9c31c23a0b770"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.3.0/lisa-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c7aa8a69c0cbe8aaea0a384c9551ef800529640feb285865c0b96fcf959137f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "lisa"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "lisa"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "lisa"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lisa"
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
