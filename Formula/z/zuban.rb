class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "bb42cb54b5bb50fab38fb28163e5b4397e22255a7a65e838e2961f79a17ab1e9"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "145058ff0f6d0eabd6ac398eb1e51552c14005ac8dbc2fe43dbc850cf6d23fa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffa9d85c76986368b4a88d6f29cadc26f90e543926b2d7a540796a8af023be93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dcc918ea36140dd741ff5a0847ca4d6e6dabcafb2e4a296159962c41ba599f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb70c749b44932e8a2b72ed0c9c2bc35ce42a42595739c09362d7ca47a5a9429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09aea8d889ad3d9004f388b4f825e42754cd6f2ddecf88f8d25bd9773cf28b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a15fe420170c6d0636b7adea3bb889908980cb07d3bb0078e0fba1010f966325"
  end

  depends_on "mypy" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")

    (lib/"typeshed").mkpath
    cp_r Formula["mypy"].opt_libexec.glob("lib/python*/site-packages/mypy/typeshed")[0].children, lib/"typeshed"
    bin.env_script_all_files(libexec/"bin", ZUBAN_TYPESHED: lib/"typeshed")
  end

  test do
    %w[zmypy zuban zubanls].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match(/(not assignable|incompatible|error)/i, out)
  end
end
