class Lisa < Formula
  desc "CLI for Lisa DAG-driven concurrent task scheduling"
  homepage "https://github.com/johnhkchen/lisa"
  version "0.2.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.11/lisa-cli-aarch64-apple-darwin.tar.xz"
      sha256 "57a3c294c33b2525ce7357c897816b5665954dfa73cb9b0595167f2942d4be89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.11/lisa-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2a4ea16f9669bd0c79d83f3e4bacc1de911d43f25fb8a699d405597628771610"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.11/lisa-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9fe25dd42febdc00040e6f5d541941e80a2bdf16295fa1a24fd48b563461d562"
    end
    if Hardware::CPU.intel?
      url "https://github.com/johnhkchen/lisa/releases/download/v0.2.11/lisa-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84ce2faf42d919e2c1471bb36623d5bf0f0b70c5e62e525857173ff690305e4e"
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
