class RtlWmbus < Formula
  desc "Software defined receiver for wireless M-Bus with RTL-SDR"
  homepage "https://github.com/weetmuts/rtl-wmbus"
  url "https://github.com/weetmuts/rtl-wmbus/archive/refs/tags/1.1.0.tar.gz"
  sha256 "0da72c7f5b026a4c0d8dc9beabba021f147c950f52eb8e09f4e41884d4f32ebf"
  license "BSD-2-Clause"

  head "https://github.com/weetmuts/rtl-wmbus.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/ingmarstein/ingmarstein"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f29a5a839c3b4e53ff1dc82820031bc4c2fb49863c184c1806bd6509fe523a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "795330eb2ad4bb9df0e90976c627539f7d9f8616c0445227189d6fba5caed468"
  end

  def install
    system "make", "release"
    bin.install "build/rtl_wmbus"
  end

  test do
    assert_match "rtl_wmbus", shell_output("#{bin}/rtl_wmbus -h 2>&1", 1)
  end
end
