class Toyon < Formula
  desc "Check Toyon facts, proofs, and evidence accountability."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.3.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.12/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "f1e568613008b724f65f133fcbb89ecf37e4340df50754d4e333ed329c888ffb"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.12/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "7dc056219c83f3aaf76e6318c0d486b1f559605191f336b920099fd5da112a5a"
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
