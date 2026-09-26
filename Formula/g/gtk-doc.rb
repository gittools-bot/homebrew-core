class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.37/gtk-doc-1.37.0.tar.xz"
  sha256 "2facfb530ddcd20c03ed4758ef934e832626c393e2cacd23fc1249b7ed0e4246"
  license "GPL-2.0-or-later"

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "148169825f695d4e693f2efd71530d16ecf08bbd7641a1e613a4b75d3703e1dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10ffbf3cbe6b5a3aa9707a9ac01c256b208a92f179fa279ba1c42aa641bc36c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "faf1207cdda1baeb9fe4b6282394afc9465ac6192d356315ec3f590a5f354896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0e1d337546ff4c8dda08e1d70069985675009c2c88e1c510c5b278e6bf62ee29"
    sha256 cellar: :any_skip_relocation, sonoma:            "4899cf390c65bef2d73d072f1a228bc2def11be1480e4a2f74f23609bf439325"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf876fe048491a3d10bd980e4022ac7cce4761a931651b29d85606a0bb06fc33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7dfea56e91394088e0dc7b8fc79a56810342b8981c86a3b45eec0baca3aa6b2a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:   "",
                extra_packages: %w[lxml pygments]

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", formula_opt_bin("pkgconf")

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", "setup", "build", "-Dtests=false", "-Dyelp_manual=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
