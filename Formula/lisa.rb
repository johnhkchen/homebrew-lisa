class Lisa < Formula
  desc "CLI for Lisa DAG-driven concurrent task scheduling"
  homepage "https://github.com/johnhkchen/lisa"
  version "0.2.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.12/lisa-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0c9ef53e3a6e40e4c24f0caba5afc34a9ba7f7b71a785845d14600e062090277"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.12/lisa-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f726beacd623e7e74c7b0416ecac93c29d5c3e5db2042a7ec6f1d778e854b913"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.12/lisa-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d0253df40b00f122397ccb19828d4624d045646484e8109e31f40b49dc04b7fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.12/lisa-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1563fb5d145eb9533f2e684740cd283218115723612a18f594d2d70cbb3b4c7a"
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
