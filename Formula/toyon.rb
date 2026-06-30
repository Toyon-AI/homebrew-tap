class Toyon < Formula
  desc "Toyon command line interface."
  homepage "https://github.com/Toyon-AI/monorepo"
  version "0.3.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.16/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "e0e071dc6712d0843ddade1d5ff5186d6f4f4d5e77dd20563f4554b0b6c59c41"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.16/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "4980b00adac6e92cb5ba24822edeb622e4f3ed89ef7d28476ef245e84f10a521"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "toyon" if OS.mac? && Hardware::CPU.arm?
    bin.install "toyon" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
