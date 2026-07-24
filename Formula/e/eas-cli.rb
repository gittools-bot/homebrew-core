class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.1.0.tgz"
  sha256 "68efb902c01bd5cab46b625ac229feb7cfed4587c55abb3c7cc02cfe5462df58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cb046135086e1bcb174188546f7987376cc79b4ebfb733a81bf74758132556a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
