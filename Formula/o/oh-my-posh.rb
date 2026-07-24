class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.35.3.tar.gz"
  sha256 "2e99c97a64c57ade2ce14e05c3391f3ba039d407d61174608abd33221fa500fa"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f246c4532952016816193a7ea211f6d3afc3bb14e4c9541def3e341f329e7559"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dc580858aac8496d45fcc49b2342ffca47700653725ab63331bbe1379dc189c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d51642297c747987d5f3be3d4dc7b91618acea7c065d5b75a7ae78104e055cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "06fac8eef5d41b4d74246123a42c207d53785de4fe1df0044c3a0764e83e70dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "389c1c1bddd1e2541d500a1fbeb102724bdadd68939869ced4e803c62863f1d4"
    sha256 cellar: :any,                 x86_64_linux:  "0fc8e17cfa25aeebdb3c0ca8e0bad83a92387d2a44c8412a8d9a7b62742e6f6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
