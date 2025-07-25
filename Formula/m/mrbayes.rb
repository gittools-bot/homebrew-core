class Mrbayes < Formula
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/refs/tags/v3.2.7a.tar.gz"
  sha256 "3eed2e3b1d9e46f265b6067a502a89732b6f430585d258b886e008e846ecc5c6"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/NBISweden/MrBayes.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bc112b0be314f46b96f507ec3741b7f915b7b384e162ff88d98076a0370a728f"
    sha256 cellar: :any,                 arm64_sonoma:   "e671f59ccb6371a26c1ff58c6bbb800a2bf7472f625ac83d756eeb8b281fd6a9"
    sha256 cellar: :any,                 arm64_ventura:  "67537897e78b18147e0a793ee201b270940fad606d3143ced31782e3fee12ef4"
    sha256 cellar: :any,                 arm64_monterey: "56f6d18191f9e66a4cd485f3b1831b8037fccae239ccf6dab3289cf2bf4f22e6"
    sha256 cellar: :any,                 arm64_big_sur:  "c79fa2b377c5f8757040bb3ec2e55b88ba0d01f3085784c0d8c03dbb745b98fc"
    sha256 cellar: :any,                 sonoma:         "fb4866da8b44dcca56aa7b59d92d299d70882321919f46fa013a7b68889ea60f"
    sha256 cellar: :any,                 ventura:        "0f00c4d31388e52785795c9cffee3124d8662d1b25648a2cef38e80ff1d46609"
    sha256 cellar: :any,                 monterey:       "868362e98f0a1ebe8bf2a71f45fa96d6fd4d474e581f52e88e27192cc0086815"
    sha256 cellar: :any,                 big_sur:        "f00054f1f4fd5c3c7835ece867a6ce6d1a5156517a0a08233fe4548717b6a41e"
    sha256 cellar: :any,                 catalina:       "4239d03c3d4cf4e2b82b7b91dec3486836695da2770397238b7c8c4182930d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2a4ec915301ae658e00a5fc302f84124e69ae54af8c0bfbc6167701fbe60d69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "102eb61f76273eb1345ca920c8e0e4dc4cec0ccba93c56a9a2634376b727e3e6"
  end

  depends_on "pkgconf" => :build
  depends_on "beagle"
  depends_on "open-mpi"

  def install
    args = ["--with-mpi=yes"]
    if Hardware::CPU.intel?
      args << "--disable-avx"
      # There is no argument to override AX_EXT SIMD auto-detection, which is done in
      # configure and adds -m<simd> to build flags and also defines HAVE_<simd> macros
      if OS.mac?
        args << "ax_cv_have_sse41_cpu_ext=no" unless MacOS.version.requires_sse41?
        args << "ax_cv_have_sse42_cpu_ext=no" unless MacOS.version.requires_sse42?
      else
        args << "ax_cv_have_sse41_cpu_ext=no"
        args << "ax_cv_have_sse42_cpu_ext=no"
      end
      args << "ax_cv_have_sse4a_cpu_ext=no"
      args << "ax_cv_have_sha_cpu_ext=no"
      args << "ax_cv_have_aes_cpu_ext=no"
      args << "ax_cv_have_avx_os_support_ext=no"
      args << "ax_cv_have_avx512_os_support_ext=no"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"

    doc.install share/"examples/mrbayes" => "examples"
  end

  test do
    cp doc/"examples/primates.nex", testpath
    cmd = "mcmc ngen = 5000; sump; sumt;"
    cmd = "set usebeagle=yes beagledevice=cpu;" + cmd
    inreplace "primates.nex", "end;", cmd + "\n\nend;"
    system bin/"mb", "primates.nex"
  end
end
