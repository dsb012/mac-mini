# Chronotron Pitch Offsets — for Anytune migration (2026-08-06)

Extracted directly from Chronotron's own settings file
(`C:\Users\David\AppData\Local\Packages\42031Chronotron.com.ChronotronMobile_1vbpvba2be8my\Settings\settings.dat`,
a Windows registry hive) — not from guesswork. Reverse-engineered the binary
format and validated against 5 known values David supplied from memory
(Unchained +104, Panama +66, Lightnin' Strikes Again +90, Creeping Death -18,
For Whom the Bell Tolls -48) — all 5 matched exactly, confirming the decode
is correct.

Full raw data (all 65 canonical entries, including the ones at 0/unset) is in
`chronotron_pitch_offsets.csv` in this folder. This table is just the songs
that actually have a non-zero saved pitch shift — the ones worth re-entering
in Anytune.

**Units:** whatever raw unit Chronotron stores internally — matched David's
remembered values exactly, so enter these numbers directly into Anytune's
pitch field. If Anytune's UI uses visibly different units, the mapping will
need to be worked out then.

| Artist | Song | Album | Pitch |
|---|---|---|---|
| Van Halen | Unchained | Fair Warning | +104 |
| Van Halen | Panama | 1984 | +66 |
| Van Halen | Feel Your Love Tonight | Van Halen | +100 |
| Dokken | Lightnin' Strikes Again | (single) | +90 |
| Dokken | Into The Fire | The Very Best Of Dokken | +66 |
| Dokken | In My Dreams | Under Lock And Key | +66 |
| Metallica | Creeping Death | Ride The Lightning | -18 |
| Metallica | For Whom the Bell Tolls | Ride The Lightning | -48 |
| Metallica | Ride the Lightning | Ride The Lightning | -20 |
| Metallica | Fade to Black | Ride The Lightning | -20 |
| Metallica | Seek & Destroy (mp3) | Kill 'Em All | -20 |
| AC/DC | Back in Black | Back In Black | -1 |
| AC/DC | T.N.T. | High Voltage | +66 |
| Ratt | Round and Round | Tell the World: The Very Best of Ratt | +100 |
| Ratt | Wanted Man | Tell the World: The Very Best of Ratt | +50 |
| Winger | Time to Surrender | (single) | +100 |
| Paul Gilbert / Racer X | Scarified | Misc Metal | +66 |
| — | Alone Again | Video Projects | +66 |

Everything else in the CSV is `0` (played, never given a custom pitch shift) —
nothing to migrate for those. A couple of duplicate paths in the CSV from an
old `Music\Music\...` folder-nesting glitch are also all `0` — safe to ignore.

## Method notes (for reference if this needs redoing)

- `settings.dat` is a real Windows registry hive — loaded with
  `reg load HKU\<tempname> <path to settings.dat>`, elevated.
- **Chronotron must be closed first** — it holds the file open and the load
  fails with "process cannot access the file" otherwise.
- Per-song data lives under `LocalState\MediaParams://<drive>:\<folder
  path>\<filename>` — local file paths get split into nested subkeys per
  path component; multiple stale copies can exist from old drive-letter
  mappings (e.g. an old `Z:\...` or `C:\ddrive\...` path) — filter to the
  current canonical path.
- Each value is a custom binary property-bag blob, not a standard registry
  type. Format per entry: `[4-byte entry length][4-byte PropertyType][4-byte
  name length][UTF-16 name][2-byte gap][value]`. PropertyType 8 = Single
  (float32), 9 = Double, 12 = String, matching the `Windows.Foundation.PropertyType`
  enum.
- The pitch shift is stored under the field named **`Key`** (PropertyType 8,
  float32) — not `Tempo` or `Speed` (those exist too, for playback
  speed/tempo, separate from pitch).
- `reg query <path> /s` (text hex dump) proved more reliable for extraction
  than .NET's `Microsoft.Win32.Registry` API, which had trouble reading
  `REG_NONE` values correctly during this session.
- Always `reg unload` the temp hive when done (elevated) — check
  `reg query HKU\<tempname>` afterward to confirm it's actually gone.
