class Toyon < Formula
  desc "Toyon command line interface."
  homepage "https://github.com/Toyon-AI/monorepo"
  version "0.3.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.15/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "2093c8a3439d783e41432d3f6fbec2c96de751961eaee320d3d152ddaf807ef4"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.15/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "9ee175b7fdfede683f36ea717a0d35d1edb15bc2c4af47dbee5a95763d0f361d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {}
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
      bin.install "toyon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "toyon"
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
