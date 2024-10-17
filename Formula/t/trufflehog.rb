class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.82.10.tar.gz"
  sha256 "cc796c034c3fbf9ecdceb22164ed8b54569203e4eb09bbb6eebe79175cf29ed7"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5f07114e0ab5fb32caa9f3f1ccf3aee097d317c45a904fe9c666c992154e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c6dcd02045f9a4d780803d1e6921f78cde8efd2071a49d6fbbf67b435a9e1de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec2c8c5d6ab3e05495b3ca5c9e15f9835b96cda332bde00101e4da6fd5e2f3fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "69964dab8d24240346403193e17e6a6846b4ca030153f0844798ecbd4abf4bb8"
    sha256 cellar: :any_skip_relocation, ventura:       "3709fbefdbdbe6cb158c21ce36c349f39f04498541724359b3878d7060ae77fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9c4b6aef7251c02e6801537be6d85ade2259d08518184a507f7e6123ad00d82"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
