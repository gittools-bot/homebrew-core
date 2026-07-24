class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.14.0.tgz"
  sha256 "f0196e44cc2c1a0684438e0d6cba3a151f8b48143409ac2a91ca5b79c2aca11b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "396f63179d46e3b9f7ba1f56bc81289d0d225234344de7624f837c3c5a45e26d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
