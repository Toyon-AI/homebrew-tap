class Toyon < Formula
  desc "Check Toyon facts, proofs, and evidence accountability."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.3/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "bc90100e7c826c1e6c42018740c47e93aeb3be1c08b0e4663374d75f279fa372"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.3/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "3b7ee924cdabbd3f93c34f203a5f14664bacca6c31993427822e869ff1613cb6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.3/toyon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f4656e5417cd944d77a566b2074f1e90904054b0d60fb0b54fb486addb14bc6"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.3/toyon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c16a8c6f782a774e1df8f4ac40dff94f2698a2a5a8a82274ec317d61712185c1"
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
