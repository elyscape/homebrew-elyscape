class FydeCli < Formula
  desc "Fyde Enterprise Console command-line tool"
  homepage "https://github.com/fyde/fyde-cli"
  version "0.4.1"
  bottle :unneeded

  if OS.mac?
    url "https://github.com/fyde/fyde-cli/releases/download/v0.4.1/fyde-cli_v0.4.1_macOS-amd64.tar.gz"
    sha256 "89214ac9c1ab0b956d814ef58dd9695fa08f9a1826f044e7d4834a6e0bb9a08a"
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/fyde/fyde-cli/releases/download/v0.4.1/fyde-cli_v0.4.1_linux-amd64.tar.gz"
      sha256 "0362fa5f649d95be122730f2931497d88d0057fa70c7d13a2e4e99ae96474d9f"
    elsif Hardware::CPU.arm?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/fyde/fyde-cli/releases/download/v0.4.1/fyde-cli_v0.4.1_linux-arm64.tar.gz"
        sha256 "d73ba3bf32262face8ce5b5110193e0a0cbec29a39af4842df5886b5ad86f6e0"
      else
        url "https://github.com/fyde/fyde-cli/releases/download/v0.4.1/fyde-cli_v0.4.1_linux-arm.tar.gz"
        sha256 "ae4ef05d5b1e45c0bd555b7102d962b292dd1ed0acf1787d405f53f79e72fe47"
      end
    end
  end

  def install
    bin.install "fyde-cli"

    # Install bash completion
    output = Utils.popen_read("#{bin}/fyde-cli completion bash")
    (bash_completion/"fyde-cli").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/fyde-cli completion zsh")
    (zsh_completion/"_fyde-cli").write output
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/fyde-cli version")
  end
end
