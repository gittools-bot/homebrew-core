class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.101.6.tgz"
  sha256 "97f95ca6b93d3643829e3e651490cdf10284e567d42056cb372e10ed2b344b70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e95ab62a58ae9943a409800e4187c0f773592e2781c304e17d5766238d07862"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e95ab62a58ae9943a409800e4187c0f773592e2781c304e17d5766238d07862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e95ab62a58ae9943a409800e4187c0f773592e2781c304e17d5766238d07862"
    sha256 cellar: :any_skip_relocation, sonoma:        "915aed6769514039d034fe865b6af07a81b814a3da21877abacb45cc370fd18e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c43a222bee39bf3dce6c54fc12a35baa528c1b073541fe2dae1248eaa3b7811c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6be97ae45c162e7f1403188f8f4c4762530883c11b360dd7f3e9af0eab353d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
