class Grc < Formula
  include Language::Python::Shebang

  desc "Colorize logfiles and command output"
  homepage "http://kassiopeia.juls.savba.sk/~garabik/software/grc.html"
  url "https://github.com/garabik/grc/archive/v1.12.tar.gz"
  sha256 "4ca20134775ca15b2e26b4a464786aacd8c114cc793557b53959592b279b8d3c"
  license "GPL-2.0-or-later"
  head "https://github.com/garabik/grc.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4a5c03d218092356e8a1f0969dc1d6ad5462931c0c49542e979faf75b1adde25"
    sha256 cellar: :any_skip_relocation, all:          "8853ca1088ea0598d4eed82cae88748f677372487ed1794b1e0ee564d2c1b783"
  end

  depends_on "python@3.9"

  conflicts_with "cc65", because: "both install `grc` binaries"

  def install
    # fix non-standard prefix installs
    inreplace "grc", "/usr/local/etc/", "#{etc}/"
    inreplace "grc.1", " /etc/", " #{etc}/"
    inreplace ["grcat", "grcat.1"], "/usr/local/share/grc/", "#{pkgshare}/"

    # so that the completions don't end up in etc/profile.d
    inreplace "install.sh",
      "mkdir -p $PROFILEDIR\ncp -fv grc.sh $PROFILEDIR", ""

    rewrite_shebang detected_python_shebang, "grc", "grcat"

    system "./install.sh", prefix, HOMEBREW_PREFIX
    etc.install "grc.sh"
    etc.install "grc.zsh"
    etc.install "grc.fish"
    zsh_completion.install "_grc"
  end

  test do
    actual = pipe_output("#{bin}/grcat #{pkgshare}/conf.ls", "hello root")
    assert_equal "\e[0mhello \e[0m\e[1m\e[37m\e[41mroot\e[0m", actual.chomp
  end
end
