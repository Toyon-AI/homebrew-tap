class Toyon < Formula
  desc "Verify and update Toyon trace sidecars."
  homepage "https://github.com/Scott-Hickmann/toyon-transpiler"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.1.0/toyon-aarch64-apple-darwin.tar.xz"
      sha256 "eeae2d1803d42d7183733c0c77b4384e16fdbbfc10c35e2571d95afe55db4306"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.1.0/toyon-x86_64-apple-darwin.tar.xz"
      sha256 "529c41fbb6aba6d2ff33488e249f1f3931f561e43df045a4fe91b6ecdd35092b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://downloads.toyon.ai/toyon/v0.1.0/toyon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7176df84d45285aef122d383fe5cb0c552a2e0e71a56185b98c7ba2dd1c3cef"
    end
    if Hardware::CPU.intel?
      url "https://downloads.toyon.ai/toyon/v0.1.0/toyon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de4ca2a278b0ff5b7609acb053703ce68591a0be6fbc956417f74063eb28c3f5"
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
