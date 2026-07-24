class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.9.tar.gz"
  sha256 "00d7f52106f06aa7b721c700749010814795755a4a9c12ba60c3943ba31ec63d"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6d0ae2ae684e902aa06f260e3682ed279a52ea0ce4e394dd78995f4d429bbef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6d0ae2ae684e902aa06f260e3682ed279a52ea0ce4e394dd78995f4d429bbef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6d0ae2ae684e902aa06f260e3682ed279a52ea0ce4e394dd78995f4d429bbef"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede69e79b469ec972c7c5ebdbf7fcdbb5bbd4d1e610d92b4f0d617a410118441"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8442e8e38624a1cc8ce9793e73af9bbbb41c138f6c144d68e8e5a3a810053f89"
    sha256 cellar: :any,                 x86_64_linux:  "adbec602e1252b6d223e6c492eeb3c4d46e9a069ecd09dcdf3b0ff10efc31395"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://github.com/aliyun/aliyun-openapi-meta/archive/2563691c22229a0b493606e11166b95896707095.tar.gz"
    version "2563691c22229a0b493606e11166b95896707095"
    sha256 "7ba54333e467ddf5b25cc93ef883742b1817b44c48568bfee699450544537e31"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")

    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
