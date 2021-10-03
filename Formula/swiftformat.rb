class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.12.tar.gz"
  sha256 "75bd02135d215dd6539a8a715a28477db0c2f5d1d5337530afd741ea258fe7d1"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0a851cfa2ff5d04f0fc98a9e624d1411f1b5b1e55e3cbc0901f4913c02e716a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5327283fe32b2ef2c6f264e14c966a9a60cb291415d3d05ed659c92a93c4987"
    sha256 cellar: :any_skip_relocation, catalina:      "ba95e49ecc71bb19734698dee565e3b0ced6470729206cb434675cfa051f2755"
    sha256 cellar: :any_skip_relocation, mojave:        "c7e00eae9d46dddf040999f0f2832d08110f093c7a403aaaaaa18d8830213967"
  end

  depends_on xcode: ["10.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
        "-project", "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "-configuration", "Release",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
