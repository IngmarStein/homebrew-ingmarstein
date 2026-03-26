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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "46911cc408806c4e93a4bad235f4c10ac719286e9db5e905a3907831008b2094"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5cfde5c8f40748a9268178172bfc83ec0fb86a2785f5c6492756307fd6ff7d3f"
  end

  def install
    system "make", "release", "TAG=#{version}", "BRANCH="
    bin.install "build/rtl_wmbus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtl_wmbus -V")
  end
end
