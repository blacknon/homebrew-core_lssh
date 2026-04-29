class Lssh < Formula
  desc "SSH workflow suite with host picker, transfer, and multi-host tools"
  homepage "https://github.com/blacknon/lssh"
  url "https://github.com/blacknon/lssh/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "de89a9964e433bfee5a598005a528cccbf16d5077cc5a7a24aca35322e69d2ed"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["GOFLAGS"] = "-mod=mod"
    ENV["GOWORK"] = "off"

    ldflags = "-s -w"
    binaries = %w[
      lssh
      lscp
      lsftp
    ]

    binaries.each do |binary|
      system "go", "build", *std_go_args(output: bin/binary, ldflags: ldflags), "./cmd/#{binary}"
    end

    binaries.each do |binary|
      bash_completion.install "completion/bash/#{binary}"
      fish_completion.install "completion/fish/#{binary}.fish"
      zsh_completion.install "completion/zsh/_#{binary}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lssh --version")
    assert_match version.to_s, shell_output("#{bin}/lscp --version")
    assert_match version.to_s, shell_output("#{bin}/lsftp --version")
  end
end
