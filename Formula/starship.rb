class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.52.1.tar.gz"
  sha256 "7fa3fad6940276a62b7c6250be34ba544e37652f9de706b48ddf9bcee74ce3d8"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7e9059e8609d78d19775f9264a79adfdd990f514ebea85ca31ae42c5643347dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "61b425022d3da693df66522872982666925e43619ac464a829545a6fca8cfae2"
    sha256 cellar: :any_skip_relocation, catalina:      "039a39b47b97f47a0176c0dc0d6ab99333a970cabe514e1a57d81ebbfa8cdb4d"
    sha256 cellar: :any_skip_relocation, mojave:        "01cccd0f97d5fc9312c357d70a6968c2fabd4f4ea00834bd851d734853dfdb50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d0e4f9fbe81812755c4f8aa35c85d64607d51569c5a22d08bf0687ab3f36dd1"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", "--features", "notify-rust", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
