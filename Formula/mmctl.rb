class Mmctl < Formula
  desc "Remote CLI tool for Mattermost"
  homepage "https://github.com/mattermost/mmctl/"
  url "https://github.com/mattermost/mmctl.git",
      :tag      => "0.1.0",
      :revision => "8a5486ec76e40c52fda51966eae997cb76dfa3e3"
  head "https://github.com/mattermost/mmctl.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = "#{ENV["HOME"]}/go"

    system "make", "build"

    bin.install "mmctl"

    # Install bash completion
    output = Utils.popen_read("#{bin}/mmctl completion bash")
    (bash_completion/"mmctl").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/mmctl completion zsh")
    (zsh_completion/"_mmctl").write output

    # Clean up build path (go mod creates files that Homebrew won't delete)
    system "go", "clean", "-modcache"
  end

  test do
    expected = if build.head?
      /mmctl \S+ -- #{version.commit}/
    else
      "mmctl v#{version}"
    end

    assert_match expected, shell_output("#{bin}/mmctl version")
  end
end
