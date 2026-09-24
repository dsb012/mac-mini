# Cura Settings Migration (Windows → Mac mini)

**Done 2026-09-23.** Windows turned out to be on 5.13 as well (the `5.12` and `4.8`
folders were leftovers from earlier upgrades), so its settings subfolders were copied
straight into the Mac's `5.13`, leaving out `cache`, `cura.log*`, `cura.lock`, `plugins`,
`packages.json` and `plugins.json`. Copied: the Neptune 3 Pro setup, 8 custom profiles,
6 custom materials and `cura.cfg`. Checked in Cura and it looks right. The pre-copy Mac
config is saved at `~/Library/Application Support/cura/5.13.bak-2026-09-23` (safe to
delete once a few prints have gone fine). Plugins to reinstall from the Marketplace:
Mesh Tools, Settings Guide, Start Optimiser. OctoPrint and Onshape were already installed.

**Current state on the Mac:** UltiMaker Cura **5.13.0** is installed, and its config
folder (`~/Library/Application Support/cura/5.13`) only has a freshly added
Elegoo Neptune 3 Pro printer. It has no custom profiles, materials or scripts yet.

## Step 1 — On the Windows PC

1. **Close Cura.**
2. In PowerShell (no admin needed):

   ```powershell
   # Note which version folder(s) exist, e.g. 5.7
   Get-ChildItem "$env:APPDATA\cura"

   # Copy the whole config tree to the NAS staging folder
   Copy-Item "$env:APPDATA\cura" "Z:\Mac Migration\Cura" -Recurse
   ```

3. Write down the Cura version shown in Cura → Help → About, or the version folder name.
4. **Optional:** in Cura's Marketplace, note any installed plugins. Plugins are
   reinstalled on the Mac, not copied over.

What that folder holds: printer setups (`machine_instances`, `definition_changes`,
`extruders`), custom profiles (`quality_changes`), per-printer overrides (`user`),
custom materials (`materials`), post-processing scripts (`scripts`), setting visibility
presets (`setting_visibility`), and preferences (`cura.cfg`).

## Step 2 — On the Mac mini

1. Mount the NAS: Finder → Go → Connect to Server → `smb://<nas-name>` → Mac Migration share.
2. **Back up the current Mac config** first:
   `~/Library/Application Support/cura/5.13` → `5.13.bak-<date>`
3. Bring the Windows config across:
   - **Windows Cura older than 5.13** (the usual case): copy the Windows version folder
     (e.g. `5.7`) into `~/Library/Application Support/cura/` and move the `5.13` folder
     out of the way. On the next launch, Cura detects the older folder and upgrades it
     into a new `5.13` on its own.
   - **Windows also on 5.13:** copy the settings subfolders listed above straight into
     the existing `5.13` folder.
4. **Don't copy:** `cache/`, `cura.log`, or `plugins/` (those plugins were built for
   Windows, so reinstall them from the Marketplace instead).
5. Launch Cura and check that the printer(s), custom profiles, materials and
   post-processing scripts are all there. Slice a known model to sanity-check it.

## Fallback

If the folder copy gives you trouble, use Cura → Preferences → Profiles → **Export** on
Windows (one `.curaprofile` per custom profile), then **Import** on the Mac. This only
carries quality profiles, so you'd set up printer settings, materials and scripts by
hand.
