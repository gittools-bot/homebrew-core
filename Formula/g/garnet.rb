class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "afaad70dc25bc557536937652646c3bdc233eb497447e0973a6990122771cbac"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7dfcbab24928dc57256b030f7ca02f728b80fb3f6c0c494de9568b71321b816f"
    sha256 cellar: :any,                 arm64_sequoia: "ef76776f22f082e8dfd21b1bea7126c45b7b028c3a0d685f812f2d677df62871"
    sha256 cellar: :any,                 arm64_sonoma:  "6dd38bad6a5e2aa8c59e4c12d9c0e38870d8e923dd48e590bcaa1633a5cf2900"
    sha256 cellar: :any,                 sonoma:        "fc8941000b281627319955e424ef6a13708045ebb5a076b7dfa0490b18a39943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4fc7740d2fccff41eccd365d94948484dd16397490b5ac6c942ec5c39063124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31e5a8b38b199f13c3d27f630c32a392d5d05e5a3a553e831b1321ee8b02a0f"
  end

  depends_on "rust" => :build
  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

    # Drop the prebuilt BfTree binaries; msbuild rebuilds the library with cargo and prefers its copy
    rm_r Dir["libs/native/bftree-garnet/runtimes/*"]

    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        args = %w[
          -DUSE_URING=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
        system "cmake", "--build", "build"
        rm "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device_libaio.so"
      end
    end

    dotnet = Formula["dotnet"]
    # .NET 10 flags IL3000 here even though Garnet falls back to AppContext.BaseDirectory.
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:WarningsNotAsErrors=IL3000
      -p:EnableSourceLink=false
      -p:EnableSourceControlManagerQueries=false
    ]
    system "dotnet", "publish", "main/GarnetServer/GarnetServer.csproj", *args
    (bin/"GarnetServer").write_env_script libexec/"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos

    # Remove non-native library
    rm libexec/"liblua54.so" if OS.linux? && Hardware::CPU.arm?
  end

  test do
    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{formula_opt_bin("valkey")}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end
