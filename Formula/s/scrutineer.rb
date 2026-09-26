class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.09.26.1.tar.gz"
  sha256 "62227311efe1f547831ee31b597bfd0b469832382a93fad72d779c46d5e8b499"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c877d7807d31a0db5b63e6842125c07e27719e52aaeb14d320322f18caea12d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c877d7807d31a0db5b63e6842125c07e27719e52aaeb14d320322f18caea12d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c877d7807d31a0db5b63e6842125c07e27719e52aaeb14d320322f18caea12d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bbd2f31136a96852c5f5714f478cfa17de20d84a2f135563301774c75391b501"
    sha256 cellar: :any,                 x86_64_linux:      "5dfed42383f939b6b4d3eedcee0494ea214d5a43630f0ea19aa45e9263c803d1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/scrutineer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrutineer version")

    output = shell_output("#{bin}/scrutineer -runtime brew 2>&1", 1)
    assert_match "runtime: must be \\\"docker\\\", \\\"podman\\\", or \\\"apple\\\"", output
  end
end
