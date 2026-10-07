# RemoveMacAI Learnings

Assessment of what [RemoveMacAI](https://github.com/omlahore/RemoveMacAI) does and which parts
belong in `ansible/macos.yml`. Written 2026-10-06 against RemoveMacAI at the time, macOS 27.0.1.

## How RemoveMacAI Works

It is a Swift CLI and app with three mechanisms:

1. **User preferences** written the same way `defaults write` does. Each change records its
   previous value in a journal so it can be undone exactly.
2. **A configuration profile** (`.mobileconfig`) for settings macOS will only honor when managed:
   Apple Intelligence restrictions, analytics, personalized ads, Game Center, Spotlight internet
   results, and "forced" preferences such as Improve Siri. The profile must be approved by hand in
   System Settings.
3. **Model removal** through Apple's private Unified Asset Framework, plus a profile key that
   points each removed model set's download URL at a closed local port so macOS never re-fetches
   it.

Only the first mechanism maps onto `community.general.osx_defaults`. The other two need either a
manual approval step or the RemoveMacAI binary itself.

## Decisions

### Port the plain `defaults` tweaks into `macos.yml`

These are the settings from RemoveMacAI not already in the playbook. All are `osx_defaults` tasks.

| Domain | Key | Value | Effect |
| --- | --- | --- | --- |
| `com.apple.finder` | `_FXSortFoldersFirst` | bool `true` | Folders above files when sorting by name |
| `com.apple.finder` | `FXDefaultSearchScope` | string `SCcf` | Search the current folder, not the whole Mac |
| `com.apple.finder` | `FXEnableExtensionChangeWarning` | bool `false` | Skip the extension change warning |
| `com.apple.finder` | `ShowStatusBar` | bool `true` | Item count and free space in Finder windows |
| `com.apple.finder` | `FXRemoveOldTrashItems` | bool `true` | Empty the Trash after 30 days |
| `com.apple.finder` | `_FXShowPosixPathInTitle` | bool `true` | Full path in the Finder title bar |
| `com.apple.desktopservices` | `DSDontWriteNetworkStores` | bool `true` | No `.DS_Store` on network drives |
| `com.apple.dock` | `show-recents` | bool `false` | Hide recent apps in the Dock |
| `com.apple.dock` | `launchanim` | bool `false` | Stop Dock icons bouncing |
| `com.apple.dock` | `minimize-to-application` | bool `true` | Minimize windows into their app icon |
| `com.apple.WindowManager` | `EnableStandardClickToShowDesktop` | bool `false` | Clicking the wallpaper no longer hides windows |
| `com.apple.WindowManager` | `EnableTiledWindowMargins` | bool `false` | No gaps between tiled windows (macOS 15+) |
| `NSGlobalDomain` | `NSAutomaticPeriodSubstitutionEnabled` | bool `false` | No period on double space |
| `NSGlobalDomain` | `NSAutomaticCapitalizationEnabled` | bool `false` | No automatic capitals |
| `NSGlobalDomain` | `ApplePressAndHoldEnabled` | bool `false` | Held keys repeat instead of showing the accent menu |
| `NSGlobalDomain` | `NSAutomaticWindowAnimationsEnabled` | bool `false` | No window opening animation |
| `NSGlobalDomain` | `NSAutomaticInlinePredictionEnabled` | bool `false` | No inline text predictions |
| `NSGlobalDomain` | `NSDocumentSaveNewDocumentsToCloud` | bool `false` | Save dialogs start on the Mac, not iCloud |
| `NSGlobalDomain` | `NSNavPanelExpandedStateForSaveMode` | bool `true` | Save dialogs open expanded |

Already present in the playbook and matching RemoveMacAI: smart quotes and dashes, autocorrect,
screenshot shadow, Dock autohide delay, hidden files, path bar, desktop and Stage Manager widgets.

### Fix the `AppleShowAllExtensions` domain

The playbook writes `AppleShowAllExtensions` to `com.apple.finder`. Apple reads it from
`NSGlobalDomain`, which is where RemoveMacAI and every dotfiles reference write it. On the machine
this was checked on, the global key was unset and only the Finder-domain copy existed, so the
setting was not taking effect. Move it to the General UI/UX loop under `NSGlobalDomain`.

### Three non-`defaults` tweaks that still fit Ansible

- **Show `~/Library`**: `chflags nohidden ~/Library`, guarded by a `stat` so it stays idempotent.
- **Stop the play key opening Music**: `launchctl disable gui/$UID/com.apple.rcd` followed by
  `launchctl bootout gui/$UID/com.apple.rcd`. Guard on `launchctl print-disabled gui/$UID`.
- **Remove Apple apps from the Dock**: install `dockutil` from Homebrew and remove by bundle ID
  (`com.apple.news`, `com.apple.TV`, `com.apple.Music`, `com.apple.podcasts`, `com.apple.iBooksX`,
  `com.apple.freeform`, `com.apple.Maps`, `com.apple.stocks`). Do not reimplement its
  `persistent-apps` plist surgery.

### Use the RemoveMacAI binary for the profile and model layer

Ansible can template the `.mobileconfig` and `open` it, but the approval click in System Settings
is manual on every machine, and model deletion needs the private framework the binary links.
The practical route is an opt-in tagged task:

```yaml
- name: Add RemoveMacAI tap
  community.general.homebrew_tap:
    name: omlahore/tap
  tags: [removemacai, never]

- name: Install RemoveMacAI
  homebrew:
    name: removemacai
  tags: [removemacai, never]

- name: Apply recommended preset
  command: removemacai apply --preset recommended --yes
  tags: [removemacai, never]
```

`removemacai tweaks --json` reports the state of every tweak and can drive a `changed_when` or a
compliance check. The `never` tag keeps it out of `make run` until invoked explicitly with
`--tags removemacai`.

### Replace the unconditional `killall` with handlers

RemoveMacAI declares, per tweak, which process reads the setting only at launch (`Finder`,
`Dock`, `SystemUIServer`) and restarts only those that changed. The playbook currently runs
`killall` on six apps every run regardless of changes. Convert them to handlers and `notify` from
the `osx_defaults` tasks so `make run` only restarts what changed and `make check` reports
honestly.

### Gate newer keys by macOS version

RemoveMacAI records the first macOS version that has each setting (`EnableTiledWindowMargins`,
`allowiPhoneMirroring`, `allowBookstore` are 15.0+). The playbook has `gather_facts: no`, so a
version guard needs facts on, or a single `sw_vers -productVersion` task registered up front and
compared with `version()`.

## Out of Scope

- **Deleting built-in Apple apps.** They live on the sealed system volume and need SIP off.
- **Mass-disabling Apple background services.** SIP blocks most unloads and many respawn on demand.
- **Storage cleanup** (old installers, Xcode device support, simulators, snapshots). Useful but
  one-off; run `removemacai clean` by hand rather than automating deletions.

## References

- [omlahore/RemoveMacAI](https://github.com/omlahore/RemoveMacAI)
- [4evy/pared](https://github.com/4evy/pared), which first mapped the Apple Intelligence asset
  service and settings keys RemoveMacAI builds on
- [community.general.osx_defaults module](https://docs.ansible.com/ansible/latest/collections/community/general/osx_defaults_module.html)
- [kcrawford/dockutil](https://github.com/kcrawford/dockutil)
- [Apple Platform Deployment: Restrictions payload](https://support.apple.com/guide/deployment/restrictions-payload-settings-dep21cd9a5c5/web)
