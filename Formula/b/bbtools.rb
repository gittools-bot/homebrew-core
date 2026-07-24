class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.98.tar.gz"
  sha256 "9879fcd70bdfbdc3a3696679acab061e0e4889f6508d68ad44b5a19f42ad189c"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "87dcf8996ac494d8e54a959e5c103979bad6d6400250086bed1947e18ebff2f6"
    sha256 cellar: :any, arm64_sequoia: "19aa438b0158184cc0c13565266573f9de147957b4f83c54bbceaf525c71a302"
    sha256 cellar: :any, arm64_sonoma:  "0d217f1bbb9ed0d823fb50f94fa4ef574699862d7029e64ea19fd4ff140fff12"
    sha256 cellar: :any, sonoma:        "421f5a6f3205a5d670640dcf41e902f44718b1da6d79b498e90e36b2626e2621"
    sha256 cellar: :any, arm64_linux:   "ad857f842da14edf5aca5eaf26f3fd6cc60e9a62f6e37028897afefd3e22b184"
    sha256 cellar: :any, x86_64_linux:  "e3cf2a10798cba0bcc7aa603430094282d5ebfa422a7a9f8d4c34d46697887ae"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[bbtools.jar jni resources]
    libexec.install Dir["*.sh"]
    bin.install Dir[libexec/"*.sh"]
    bin.env_script_all_files(libexec, Language::Java.overridable_java_home_env)
    doc.install Dir["docs/*"]
  end

  test do
    res = libexec/"resources"
    args = %W[in=#{res}/sample1.fq.gz
              in2=#{res}/sample2.fq.gz
              out=R1.fastq.gz
              out2=R2.fastq.gz
              ref=#{res}/phix174_ill.ref.fa.gz
              k=31
              hdist=1]

    system bin/"bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
