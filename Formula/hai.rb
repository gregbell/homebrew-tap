class Hai < Formula
  desc "~ tiny CLI tool that turns natural language into Bash or Zsh commands"
  homepage "https://github.com/gregbell/hai"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gregbell/hai/releases/download/v0.1.0/hai-aarch64-apple-darwin.tar.xz"
      sha256 "b72eccd488055ff5856aa44c7ac97cdf9a45c0778e85bdf81c25ddc1d422f5ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gregbell/hai/releases/download/v0.1.0/hai-x86_64-apple-darwin.tar.xz"
      sha256 "032939bd2ca9c665d3549e4d1354854c017ac3eba2cf7cf23cbee186a400f134"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/gregbell/hai/releases/download/v0.1.0/hai-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "254f881d0ca4a0f9b572ccf2f76c3927b6dc054c0a0e3867236c70ad099da6b2"
  end
  license "GPL-3.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "hai" if OS.mac? && Hardware::CPU.arm?
    bin.install "hai" if OS.mac? && Hardware::CPU.intel?
    bin.install "hai" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
