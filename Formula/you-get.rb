class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1060/you-get-0.4.1060.tar.gz"
  sha256 "a1cc8754ec877a2a200ab76ca37c5c506d762d535945fdbfdf3263388dcd8db0"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "3db8324a14d3a0215a30cfccf5045f1a78764bea1b6c00c8e92a77dd64969008" => :high_sierra
    sha256 "03a8bbd099aa61815e80df3be92c5eaeb71eef2469a33fb079bb4273b807407e" => :sierra
    sha256 "06b8d3af29298ea026d68b8edbd4d6cbdc1ade6a5cd37bcc5a150b9f10fb3dff" => :el_capitan
  end

  depends_on "python"

  depends_on "rtmpdump" => :optional

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
