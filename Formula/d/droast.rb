class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.4.9.tar.gz"
  sha256 "e58b846cac1537afcb4a07183bf6beac94a8383eac2c88528cd46399ed03922c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f5c8ad443e24bc49516388761ef237cf42220050d221d4017705babe8aee80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08c2e65f8be17fd6193a243b60e7b67c29a7832fe55ee3513632c63f7592d173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b93fc4fe11b598e658b9a63d8a5b9434bf05aa4b35d7491f6189d0d1109cb221"
    sha256 cellar: :any_skip_relocation, sonoma:        "7afbba06e4aa0e80da7ea215e50bd9d0d99114a4795891181e8d07de844bf9ba"
    sha256 cellar: :any,                 arm64_linux:   "7dcef1f44295503674e612a29d763fcd3c4cb9005f2bf6a4b49e8aebb4187931"
    sha256 cellar: :any,                 x86_64_linux:  "a7712244e4aa29fbed3a891be63361c7bba723fac693675afc781c9e295ddb7a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"droast", "completion")
  end

  test do
    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:3
      ENTRYPOINT ["echo", "hi"]
      ENTRYPOINT ["echo", "bye"]
    DOCKERFILE
    output = shell_output("#{bin}/droast --no-roast --format compact #{testpath}/Dockerfile", 1)
    assert_match "DF039", output
  end
end
