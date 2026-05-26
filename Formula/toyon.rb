class Toyon < Formula
  desc "Check Toyon facts, proofs, and evidence accountability."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.4/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "d6ba839a53a2d5f7cf885c782664a9b1dcdc7141b6a8c33a10b47e1e7dbecf27"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.4/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "9ffd6b7e6459aa5403ae37d79f36cf67ca453a599af48ebe7daf0a010ee4e253"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.4/toyon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f44825468ba5bf1f393c86d7305ed8255e8718927a4981f1eb4c132538f5798e"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.4/toyon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8a152f5dae48dd8e38e5501eb3b6cab1264493742766e8fa56bfe7144db5adda"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "toyon" if OS.mac? && Hardware::CPU.arm?
    bin.install "toyon" if OS.mac? && Hardware::CPU.intel?
    bin.install "toyon" if OS.linux? && Hardware::CPU.arm?
    bin.install "toyon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
