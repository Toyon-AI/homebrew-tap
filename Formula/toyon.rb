class Toyon < Formula
  desc "Verify and update Toyon trace sidecars."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.2.0/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "9c4df26278bbb240d3899436fd86420999e5e895b9fdbd5ea98af815f9b7a7b0"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.2.0/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "8446aa929d7ea6c06ee4206f334465c218cc04b9621d04e0ec5dba49dabd4115"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.2.0/toyon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5bbbe27cfc1632bd7ba4a27a1c6dce1dad9f65614f46d776fdda40e8855b6c70"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.2.0/toyon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d9825d5754ba543e6a6b42773f9ee683a7c00a33bb4424b516a5a5dcf9d7fd1"
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
