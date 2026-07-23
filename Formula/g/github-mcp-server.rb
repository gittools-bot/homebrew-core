class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ab6f9018039e0562dc49b89e56a4a7b8f3486102d43bc8adffa6d6972445230c"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9036f20aafc897e0056bc1dac2b5e1b0084f2783ad3203fd61585d671601caeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9036f20aafc897e0056bc1dac2b5e1b0084f2783ad3203fd61585d671601caeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9036f20aafc897e0056bc1dac2b5e1b0084f2783ad3203fd61585d671601caeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca91f7e91935fdf2ba8e3d6092041fd47c6c2b5fe23b5064e5eacf537e44d45b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a925550c9e552e8af6e327c8633b9420fa22f86f68ca1e16627a2c8d83756e39"
    sha256 cellar: :any,                 x86_64_linux:  "18c89eb8a2de393ca0a5c50d25ec6c51e434bfa403fa83082cbebc1d19bf0799"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
