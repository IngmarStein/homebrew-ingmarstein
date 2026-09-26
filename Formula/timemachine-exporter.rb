class TimemachineExporter < Formula
  desc "Prometheus exporter for Apple Time Machine"
  homepage "https://github.com/IngmarStein/timemachine-exporter"
  url "https://github.com/IngmarStein/timemachine-exporter/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7ae6d3d8f12ccf256dcf5f25011f2f98c3167f35d178f96d6cee2606d7ed2710"
  license "MIT"

  head "https://github.com/IngmarStein/timemachine-exporter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on :macos

  service do
    run [opt_bin/"timemachine-exporter", "-socket=#{var}/run/timemachine-exporter.sock", "-port="]
    keep_alive true
    log_path var/"log/timemachine-exporter.log"
    error_log_path var/"log/timemachine-exporter.log"
  end

  def install
    system "go", "build", *std_go_args, "exporter.go"
  end

  def caveats
    <<~EOS
      This exporter runs `tmutil latestbackup`, which reads the Time Machine
      destination volume. macOS attributes that access to the process running
      the exporter, so the binary needs Full Disk Access:

        #{opt_bin}/timemachine-exporter

      Grant it in System Settings > Privacy & Security > Full Disk Access.
      Without it, scrapes still succeed but `timemachine_last_success_timestamp_seconds`
      and `timemachine_destination_latest_age_seconds` are silently missing.

      The grant is keyed to the exact binary, and upgrades replace it, so it
      has to be granted again after every `brew upgrade`.
    EOS
  end

  test do
    port = free_port
    pid = fork { exec bin/"timemachine-exporter", "-port=#{port}" }
    sleep 2
    assert_match "timemachine_backup_running", shell_output("curl -s http://localhost:#{port}/metrics")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
