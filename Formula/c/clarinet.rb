class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "d2e5273a5b3f198998413dc1744665167732f83040451a0f8ef58224eaf52bf9"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318e11d3c2fb7412b7b1ae5d254a41ffbb903ee3b6f72bb4efdcefa2cc65ddc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b1e9f78807cdaf8605f634f0cbea24f29cfc1ffa4d46007a314f9204b2e0fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "324e58927e140ee7e79a164cd2abb7cd7de46bef8bd82c34b4841fe54e6b1b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aff7eb15a4ff5af284606d27fc9211f30dd0a628cb33a127e9102c6561e63b7"
    sha256 cellar: :any,                 arm64_linux:   "533ba05ce245813c784d0b13d176434062190bb1d0508d02cf25a7b342c1ca20"
    sha256 cellar: :any,                 x86_64_linux:  "3ce2d41eb2fcb4ae702d0237f1de2b5ab12e669701553410b5b5df80ee3a908a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
