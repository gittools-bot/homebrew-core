class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-6.2.2.tgz"
  sha256 "3cc183287c8cef68b1927100c5d1ca2e8e26f813cd14decbae909aa17cbe93e3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6096054ff517842d59bf388d3e043d242b4c18dcf54d45871da149c6b0fbe31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6096054ff517842d59bf388d3e043d242b4c18dcf54d45871da149c6b0fbe31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6096054ff517842d59bf388d3e043d242b4c18dcf54d45871da149c6b0fbe31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce246dc74121f674123c782ab633dce90b4bb0ce027eec7332d858e685c5f5e9"
    sha256 cellar: :any_skip_relocation, ventura:       "ce246dc74121f674123c782ab633dce90b4bb0ce027eec7332d858e685c5f5e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6096054ff517842d59bf388d3e043d242b4c18dcf54d45871da149c6b0fbe31"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
