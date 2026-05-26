class Toyon < Formula
  desc "Check Toyon facts, proofs, and evidence accountability."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.2/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "01d3e80d6ae5350b0faaf1be1c76778d1bf2c042cc69a7778d8685236dbe6a2a"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.2/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "09a35811116eaa2e04455858016c0703ed50bd5177ea31e5dcf1b75f700553ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.3.2/toyon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2ee7809175eda3cf3130fe44ac815e2653f4032a38c3531ecac42d3156d81f23"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.3.2/toyon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5fd5e1eb6a1381631e84a359c3515900172ff529adbf897d573edf46fa43733f"
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
