class BackupTool < Formula
  desc "Backup jobs for PostgreSQL and Paperless-ngx with Healthchecks reporting"
  homepage "https://github.com/IngmarStein/backup-tool"
  # The repo is private, and Homebrew cannot authenticate private release assets,
  # so this builds from source over SSH (the URL scheme the machine already uses
  # for git) instead of shipping bottles.
  url "ssh://git@github.com/IngmarStein/backup-tool.git",
      tag:      "v1.0.0",
      revision: "40b5d964edfe102ecacc4c1b3e3e1624ed75ccdd"
  license "MIT"

  head "ssh://git@github.com/IngmarStein/backup-tool.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  # One service, because a formula can only define one. Both jobs run in one
  # process; the tool gives each its own deadline and Healthchecks check.
  service do
    run [opt_bin/"backup-tool", "--timeout", "14400", "all"]
    run_type :cron
    cron "10 3 * * *"
    run_at_load false
    log_path var/"log/backup-tool.log"
    error_log_path var/"log/backup-tool.log"
    environment_variables PATH: std_service_path_env
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  def caveats
    <<~EOS
      The job copies its artifact to /nas, a network volume. macOS attributes
      that access to the binary making it, so the first run asks for permission
      to access files on a network volume. Answer "Allow" from a GUI session: a
      background launchd job cannot answer the prompt, and until it is answered
      the copy stalls rather than failing.

      The grant is keyed to the exact binary, so a new version asks again.

      `brew upgrade` does not restart services, and launchd pins the job to a
      code requirement for the binary it spawned. Restart it after upgrading:

        brew services restart backup-tool
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backup-tool -version")
  end
end
