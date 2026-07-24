class WgslAnalyzer < Formula
  desc "Language server implementation for WGSL and WESL"
  homepage "https://wgsl-analyzer.github.io"
  url "https://github.com/wgsl-analyzer/wgsl-analyzer/archive/refs/tags/2026-04-26.tar.gz"
  sha256 "ac422ae9615bef7f41992eedcc0aeffde80cead438c2913ee254bbbefaed0511"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wgsl-analyzer")
  end

  test do
    input = <<~EOF
      Content-Length: 132\r\n\r
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
      Content-Length: 64\r\n\r
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
      Content-Length: 74\r\n\r
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
      Content-Length: 57\r\n\r
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"wgsl-analyzer", input, 0)
  end
end
