class Toyon < Formula
  desc "Check Toyon facts, proofs, and evidence accountability."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.3.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://downloads.toyon.ai/toyon/v0.3.8/toyon-aarch64-apple-darwin.tar.xz"
    sha256 "1616dd774c99f14cf70622c6066dd7c377fb50ff21b4ee1600862cae868d4e31"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
