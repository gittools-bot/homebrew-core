class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "17d9d1c1c2f5f8d223afaa9a73ce1ce5faa41fe5fb8a7bfd6d65e402d536d8d6"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b07716140a593093269d3209d52eceaa816d29b430f905a95e0c50d651fa0e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b07716140a593093269d3209d52eceaa816d29b430f905a95e0c50d651fa0e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b07716140a593093269d3209d52eceaa816d29b430f905a95e0c50d651fa0e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2308df2d84a672fc2be3406832abb7bb2bbb044c770109e1576160fba6ad314"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdb08a5dc164085b2525f95949c5c8edaf512faf833a22135b10662e1f8b01b9"
    sha256 cellar: :any,                 x86_64_linux:  "a71e3c51f6a0a2ad079e5e37d7d2f306d5fe82ed144d9c8678158a72830e5731"
  end

  depends_on "go" => :build
  depends_on "git-delta"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/No (diff|input provided), exiting/, shell_output("#{bin}/diffnav 2>&1"))

    system "git", "init", "--initial-branch=main"
    (testpath/"test.txt").write("Hello, Homebrew!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test.txt").append_lines("Hello, diffnav!")

    require "pty"
    begin
      r, w, pid = PTY.spawn("git diff | #{bin}/diffnav")
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "test.txt", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid) unless pid.nil?
    end
  end
end
