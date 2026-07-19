class Lisa < Formula
  desc "CLI for Lisa DAG-driven concurrent task scheduling"
  homepage "https://github.com/johnhkchen/lisa"
  version "0.4.4-rc.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.4.4-rc.9/lisa-cli-aarch64-apple-darwin.tar.gz"
      sha256 "0f9a6c879337f0d11e66dfcdf9d639aa6b5785ff9fe70cfd8054bea224be8168"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.4.4-rc.9/lisa-cli-x86_64-apple-darwin.tar.gz"
      sha256 "22bcc0381e21fdb033face1cfc205493c7d66501f883fde70d5d7f6b55d28d2d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.4.4-rc.9/lisa-cli-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cd529805c52f8e4c4a9bc3671c0abf300f5621cefdc43556fe440a3aba945e0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.4.4-rc.9/lisa-cli-x86_64-unknown-linux-musl.tar.gz"
      sha256 "435fd3d1603c4ef5a9d66cb5fe27ac645b323e605262fedcb4112116b2960405"
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
