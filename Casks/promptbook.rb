cask "promptbook" do
  version "0.1.13"
  sha256 "900fa1a75b093f0eddc9b61340a5fa049295aa6a89088ebc7459556b64d4c054"

  url "https://github.com/promptbook-sh/promptbook-releases/releases/download/v#{version}/Promptbook-#{version}.dmg"
  name "PromptBook"
  desc "Terminal with a dockable, runnable notebook"
  homepage "https://promptbook.sh/"

  # Follow the artifacts repo's latest release rather than parsing the URL, so
  # `brew livecheck` keeps working if the asset is ever renamed.
  livecheck do
    url :url
    strategy :github_latest
  end

  # The app and the disk image are both Developer ID-signed and notarized, so
  # Gatekeeper accepts them on first launch and no caveat is needed.
  app "Promptbook.app"

  # Homebrew fetches the disk image from GitHub, so a cask install is invisible
  # to promptbook.sh without this. Anonymous: the version and the word "cask",
  # nothing about the machine. Backgrounded and capped at five seconds so a
  # network hiccup can neither fail nor slow the install, and silenced so it
  # never prints over Homebrew's output. Note this also fires on
  # `brew upgrade --cask`, so the count is installs plus upgrades.
  postflight do
    system_command "/bin/sh",
                   args: ["-c",
                          "curl -fsS -m 5 -o /dev/null " \
                          "'https://promptbook.sh/api/download?src=cask&version=#{version}' " \
                          ">/dev/null 2>&1 &"]
  end

  zap trash: [
    "~/Library/Application Support/Promptbook",
    "~/Library/Preferences/app.promptbook.terminal.plist",
    "~/Library/Saved Application State/app.promptbook.terminal.savedState",
  ]
end
