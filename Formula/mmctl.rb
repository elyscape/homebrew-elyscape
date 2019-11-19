class Mmctl < Formula
  desc "Remote CLI tool for Mattermost"
  homepage "https://github.com/mattermost/mmctl/"
  url "https://github.com/mattermost/mmctl.git",
      :tag      => "0.1.0",
      :revision => "8a5486ec76e40c52fda51966eae997cb76dfa3e3"
  head "https://github.com/mattermost/mmctl.git"

  depends_on "go" => :build

  def install
    # Work around broken go.mod file
    go_mod = buildpath/"go.mod"
    mod_source = go_mod.readlines.reject { |line| line.include? "github.com/golang/lint" }
    go_mod.unlink
    go_mod.write mod_source.join

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
    system "mmctl", "-h"
  end
end
