class Toyon < Formula
  desc "Verify and update Toyon trace sidecars."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.1.1/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "366d4b9dc2d04a5d5cec191dc3bdd05a435b25dec9441c239d03d96845f2c06f"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.1.1/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "aded61d829b7482ee688a4f742832b68b0cfae2d7a7de029c94a6d8d5090408a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.1.1/toyon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0904291b5b017384845974677def6126948639e15073e33935daf0ad43acca83"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.1.1/toyon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "86ffbceb972a92c54ff98da7c8aec4bf1406cd8eef6de16cd72ec222981293f8"
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
