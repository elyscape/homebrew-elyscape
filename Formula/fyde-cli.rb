class FydeCli < Formula
  desc "Fyde Enterprise Console command-line tool"
  homepage "https://github.com/fyde/fyde-cli"
  url "https://github.com/fyde/fyde-cli.git",
      :tag      => "v0.4",
      :revision => "d147fbb9e081e9fd6f4ad9992679c52a813a0a54"

  depends_on "go" => :build

  resource "go-swagger" do
    url "https://github.com/go-swagger/go-swagger.git",
        :tag => "v0.21.0"
  end

  resource "govvv" do
    url "https://github.com/ahmetb/govvv.git",
        :revision => "eeed55f64b034cbb8d82676030f98676e1b4dae1"
  end

  def install
    home_bindir = Pathname.new(ENV["HOME"])/"bin"
    ENV.prepend_create_path "PATH", home_bindir

    resource("go-swagger").stage do
      system "go", "build", "-o", home_bindir/"swagger", "./cmd/swagger"
    end

    resource("govvv").stage do
      system "go", "build", "-o", home_bindir/"govvv"
    end

    system "git", "checkout", "."
    (buildpath/".git/info/exclude").append_lines(".brew_home/")

    system "swagger", "generate", "client", "-f", "swagger.yml"
    system "govvv", "build", "-version", version, "-o", "#{bin}/fyde-cli"

    # Install bash completion
    output = Utils.popen_read("#{bin}/fyde-cli completion bash")
    (bash_completion/"fyde-cli").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/fyde-cli completion zsh")
    (zsh_completion/"_fyde-cli").write output

    # Clean up build path
    system "go", "clean", "-modcache"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/fyde-cli version")
  end
end
