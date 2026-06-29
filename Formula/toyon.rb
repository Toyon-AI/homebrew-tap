class Toyon < Formula
  desc "Toyon command line authentication."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.3.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "\1"
      sha256 "0abae9e88050cc83849e419875a569de133eba2a4b2fe8c8fe89c614f59564dd"
    end
    if Hardware::CPU.intel?
      url "\1"
      sha256 "2cfb16f190719687a746f4528456b78102825462e9c0863332ac51e25ea59bc9"
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
