class Lisa < Formula
  desc "CLI for Lisa DAG-driven concurrent task scheduling"
  homepage "https://github.com/johnhkchen/lisa"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.7/lisa-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e483e50e9a817dcda1be38e437cf0dabf8e58d74f886e765ceaafd274235eb8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.7/lisa-cli-x86_64-apple-darwin.tar.xz"
      sha256 "20344e084468359ef670a608854cc85e81b33a3745582b441a1d5d500990ea5c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.7/lisa-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "155f7cd8c1eb50cb0e5c55841892f88fa20030397d6a126140bb85b767414d1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.7/lisa-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a3b58afb7f0459dda8c38aa15547199a275261de2616d787574aeaf328f2ee82"
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
