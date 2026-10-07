# Design

## Context

`ks.envsubst` currently installs `i3-desktop-environment` and `xrdp`/`xrdp-selinux`
via `dnf` in `%post` (see proposal.md - Why). The Fedora Server DVD does not
carry these; they live in the Everything repo. The `xrdp-selinux` subpackage
builds its `xrdp.pp` module from a policy source that contains only `allow`
rules (no file contexts), and base policy already labels `/usr/sbin/` as
`bin_t` at package install time.

## Goals / Non-Goals

**Goals:**
- Anaconda resolves and installs all packages; `%post` only configures.
- DVD remains the base repo (`cdrom`); network repos only fill the gaps.

**Non-Goals:**
- Switching to a netinstall ISO / `url` source (bigger workflow change).
- Reworking unrelated `%post` content (tar helpers, xrdp ini tuning).

## Decisions

- **Keep `cdrom`, add two `repo` lines** for the `fedora` and `updates`
  mirrorlists over dropping the DVD in favor of `url --mirrorlist=...`.
  Rationale: smallest delta; the existing `network` static-IP directive runs
  early enough that Anaconda can reach the mirrors during install. The `url`
  variant would allow the small netinst ISO but changes the documented media
  workflow for no functional gain here.
- **Environment-group syntax `@^i3-desktop-environment`** in `%packages`:
  `i3-desktop-environment` is an environment in comps, so it needs the `^`
  prefix (plain groups use `@name`, packages are listed bare).
- **Drop both `chcon` lines** instead of replacing them with
  `semanage fcontext`: rpm applies `bin_t` from base policy when the package
  is installed, so there is nothing to fix. A persistent `fcontext` rule
  would be equally redundant; `chcon` additionally would not survive a
  relabel. The vsock access xrdp needs is granted by the `xrdp-selinux`
  module's allows on `unconfined_service_t`, not by file labels.
- **DVD preferred via repo cost**: the network repos get `--cost 2000`,
  above DNF's default of 1000 that the `cdrom` repo keeps, so packages
  present on the DVD install from the media and network is only used for
  what the DVD lacks (i3, xrdp). Alternative `--priority` was considered but
  is stricter than needed and less portable across DNF5/backends; cost is a
  preference, exactly the wanted semantics. Caveat: repo *metadata* is still
  downloaded for all enabled repos — cost only steers package downloads.
- **Mirrorlist over `metalink`/`baseurl`**: mirrorlist is the traditional,
  documented form for kickstart `repo` and needs no HTTPS-redirect handling
  assumptions; `$releasever`/`$basearch` are substituted by Anaconda's DNF
  base configuration.
- **Repo ids must not collide with the image's system repos**: the boot image
  ships the Fedora system repos (`fedora`, `updates`, `updates-testing`, ...)
  disabled in `/etc/anaconda.repos.d/`. `DNFManager.add_repository`
  reconfigures a same-named existing repo in place but never re-enables it
  (`_configure_repository` only disables), so kickstart repos named `fedora`/
  `updates` silently stay disabled — the install then runs on the DVD repo
  alone and `@^i3-desktop-environment`/`xrdp`/`xrdp-selinux` fail to resolve
  (`No match for argument`, observed 2026-10-06 in `/tmp/dnf.log` and
  `/tmp/packaging.log` of Anaconda 44.30-2.fc44). The prefix `net-` avoids the
  collision, so the repos are created fresh and enabled.

## Risks / Trade-offs

- [Mirror unreachable during install (VM network starts but upstream is down)] → install fails early in software selection rather than silently later in `%post`; acceptable, and still strictly better than the status quo.
- [A group/package name changes in a future Fedora release] → caught by the test-install task; `%packages` fails loudly with `--erroronfail`-equivalent behavior in Anaconda.

## Migration Plan

Single-file edit of `ks.envsubst`, then one full test install of a throwaway
VM to validate; delete the test VM afterwards. No rollback plan needed —
the previous `ks.envsubst` remains in git history.
