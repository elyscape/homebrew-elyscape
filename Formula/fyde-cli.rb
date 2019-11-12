class FydeCli < Formula
  desc "Fyde Enterprise Console command-line tool"
  homepage "https://github.com/fyde/fyde-cli"
  version "0.4"
  bottle :unneeded

  if OS.mac?
    url "https://github.com/fyde/fyde-cli/releases/download/v0.4/fyde-cli_v0.4_macOS-amd64.tar.gz"
    sha256 "77930609cfa80c5d77d058749634ea48a056f7faf1d099598a7ca000d284eb5a"
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/fyde/fyde-cli/releases/download/v0.4/fyde-cli_v0.4_linux-amd64.tar.gz"
      sha256 "da0238ba6655714e14e8fd6053505211eb6b3c5010a28e515abc5e463399ea8c"
    elsif Hardware::CPU.arm?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/fyde/fyde-cli/releases/download/v0.4/fyde-cli_v0.4_linux-arm64.tar.gz"
        sha256 "eff51326685362437052e028a887cfc3338e64fadd156b4545b9bf5871eb02c6"
      else
        url "https://github.com/fyde/fyde-cli/releases/download/v0.4/fyde-cli_v0.4_linux-arm.tar.gz"
        sha256 "595654208b98c83e19068452d1bf874d1ecc76fd6ca1c1804e4bda56a721c97f"
      end
    end
  end

  def install
    bin.install "fyde-cli"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/fyde-cli version")
  end
end
