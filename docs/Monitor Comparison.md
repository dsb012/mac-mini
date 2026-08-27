# Monitor Comparison — Mac Mini Replacement Project

_Started August 15, 2026. **Decision closed 2026-08-26 — see below.** Candidate research retained for reference._

## DECIDED: Dell S3425DW, purchased and in use (2026-08-26)

**Bought and set up.** Confirmed live on the work M1 MacBook Pro via `system_profiler
SPDisplaysDataType`: `DELL S3425DW`, 3440 x 1440, main display, running **100.00Hz**.

**Also decided 2026-08-26: the desk goes to a single monitor for the near future.** The
two LGs (29WN600-W primary, 24ML600M-B secondary) come out of the daily setup. This
changes the KVM and cabling plan recorded in `../Mac Mini Replacement Research.md` --
see the Displays section there.

**RESOLVED 2026-08-26: 120Hz is not available through the KVM.** Confirmed on the
MacBook Pro -- macOS offers no 120Hz mode on that leg. **The bandwidth prediction in this
file was correct**: 3440x1440@120 (~19 Gbps) exceeds the NAWEN's HDMI 2.0 ~18 Gbps ceiling,
@100 (~16 Gbps) fits. The EDID risk, which was flagged as the *bigger* worry, did not
materialize at all -- full native 3440x1440 passes cleanly.

Practical impact is close to nil, as predicted: 100Hz is exactly what the work monitor runs
at. 120Hz is recoverable per-machine by plugging into one of the Dell's own HDMI 2.1 inputs
and bypassing the KVM.

## Candidates (research retained; decision is closed)

1. **Dell 34 Plus USB-C Monitor (S3425DW)** — 34" WQHD, 120Hz curved VA
2. **Samsung ViewFinity S65UC (LS34C654UANXGO)** — 34" Ultra-WQHD, 100Hz curved VA, built-in KVM switch
3. **LG 34U530A-W** — 34" WFHD (2560×1080), 100Hz flat IPS, budget pick

## Currently in use at work (reference point, not a candidate)

**Samsung LC34H890WJNXGO** (CJ89 series) — 34" curved, 3440x1440, 100Hz, single-cable USB-C. David's daily driver at the office.

Confirmed from the monitor's own on-screen Information panel, photographed 2026-08-13 (`reference/PXL_20260813_171634582.MP.jpg` -- already in this repo):

| Read directly off the OSD | Value |
|---|---|
| Model | LC34H890WJNXGO |
| Active input | USB Type-C |
| Running resolution | 3440 x 1440 |
| Refresh | 100 Hz (150.9 kHz horizontal) |
| Menu features seen | Picture, PIP/PBP, OnScreen Display, System, Information |

Full specs, confirmed against Samsung's own CH890 support page (2026-08-26). It is also carried as the **leading column of the spec comparison table below**, as the baseline everything else is judged against:

| Spec | Samsung C34H890WJN (work monitor) |
|---|---|
| Curvature | **1800R** |
| Resolution | 3440 x 1440 |
| Refresh rate | 100 Hz |
| Panel type | VA |
| Brightness | 300 cd/m2 (typ) |
| Contrast ratio | 3,000:1 (typ) |
| USB-C | DP Alt Mode + data + power, 65W per retailer listings (not stated on Samsung's spec page) |
| PIP/PBP | PIP 2.0 and PBP both supported |
| KVM | Not listed |

Serial number is visible in the photo and is deliberately not transcribed here.

### Stated preference: the curve

**David likes this monitor's curve radius (2026-08-26).** That makes 1800R a target, not a neutral spec -- and it reorders the shortlist:

| Monitor | Curvature | vs. the curve he likes |
|---|---|---|
| Work monitor (C34H890WJN) | 1800R | baseline |
| **Dell 34 Plus S3425DW** | **1800R** | **exact match** |
| Samsung ViewFinity S65UC | 1000R | noticeably more aggressive |
| LG 34U530A-W | flat | no curve at all |

This cuts against the earlier read of this file. On paper the Samsung S65UC looked like the natural continuation of a Samsung ultrawide, but on the one dimension David has now said he actually cares about, **the Dell is the match and the S65UC is the outlier**. The S65UC's 1000R is a much tighter wrap than the 1800R he's used to daily.

The Dell is also the closer match beyond the curve: same 300 cd/m2 brightness, same 3,000:1 contrast, same VA panel, same 65W USB-C PD as the work monitor -- essentially the same monitor plus 120Hz instead of 100Hz. What the S65UC offers over it (KVM, 90W PD, Ethernet, 3-year warranty) are convenience features, none of which the work monitor has either, so none of them are things David would be giving up.


## Spec comparison

| Spec | **Samsung C34H890WJN (work monitor)** | Dell 34 Plus S3425DW | Samsung ViewFinity S65UC | LG 34U530A-W |
|---|---|---|---|---|
| Price | n/a - already owned (work) | **$419.99 Dell.com / $399.99 Micro Center (checked 2026-08-26; was $329.99 on 2026-08-15)** | $589.99 list; often $339–$499 on Amazon | $249.99–$323.99 (varies by retailer) |
| Resolution | 3440 × 1440 (Ultra-WQHD) | 3440 × 1440 (WQHD) | 3440 × 1440 (Ultra-WQHD) | 2560 × 1080 (WFHD) |
| Pixel density | ~110 PPI | ~110 PPI | ~110 PPI | ~82 PPI |
| Panel type | VA, 1800R curve | VA, 1800R curve | VA, 1000R curve | IPS, flat |
| **Curvature** | **1800R (baseline)** | **1800R - exact match** | **1000R - much tighter** | **flat** |
| Refresh rate | 100 Hz | 120 Hz | 100 Hz | 100 Hz |
| Response time | 4ms GTG | 1ms (Extreme) / 5ms GTG | 5ms GTG | 5ms GTG (1ms MBR claimed in marketing) |
| Brightness | 300 cd/m² | 300 cd/m² | 350 cd/m² | 400 cd/m² (DisplayHDR 400) |
| Contrast ratio | 3,000:1 | 3,000:1 | 3,000:1 | 1,000:1 |
| Color gamut | not confirmed | 95% DCI-P3, 99% sRGB | 1.07B colors (10-bit); gamut % not published | 99% sRGB |
| HDR | not confirmed | HDR10 | HDR10 | HDR10 (VESA DisplayHDR 400) |
| Adaptive sync | AMD FreeSync | AMD FreeSync Premium | AMD FreeSync | AMD FreeSync compatible |
| Video ports | 1× HDMI, 1× DisplayPort | 2× HDMI | 1× DisplayPort, 1× HDMI | 1× HDMI 1.4, 1× DisplayPort 1.4 |
| USB-C | DP Alt Mode + data + power; 65W per retailer listings | DP Alt Mode, 65W power delivery | DP Alt Mode, 90W power delivery | DP Alt Mode, video output only — no confirmed laptop charging |
| Other ports | USB 3.0 hub | 2× USB-A, 1× USB-C downstream | 2× USB-A, 1× USB-B, RJ45 Ethernet, KVM switch | 3.5mm headphone out |
| Speakers | not confirmed | 2×5W (10W total) | 2×5W (10W total) | Integrated stereo w/ Waves MaxxAudio (wattage unlisted) |
| Stand adjustability | not confirmed | Height 5.12", tilt −5°/21°, swivel −4°/4° | Height 4.7", tilt −2°/20°, swivel −30°/30° | Height up to 5.9", tilt, swivel |
| VESA mount | not confirmed | 100×100mm, M4 screws | 100×100mm, M4 screws | 100×100mm, M4 screws |
| Weight | not confirmed | **20.68 lb (9.38 kg) with stand; 15.23 lb (6.91 kg) panel only** | not confirmed | not confirmed |
| Assembled size | not confirmed | **31.78" W x 20.36" H x 8.73" D; stand base 10.20" W x 8.73" D; 5.12" height adjust** | not confirmed | not confirmed |
| Warranty | 3 year | 1 year | 3 years | 1 year |

## Notes

- The LG is the clear budget option but has a notably lower resolution (2560×1080 vs. 3440×1440) and lower pixel density (~82 PPI vs. ~110 PPI on the other two) — text and UI will look visibly less sharp. Its USB-C port also appears to be video-only per the official spec sheet, despite some retailer marketing copy implying charging support — worth confirming before relying on it to power a laptop.
- **Price moved (checked 2026-08-26):** the Dell S3425DW was $329.99 when this file was started on 2026-08-15. It is now **$419.99 on Dell.com** and **$399.99 at Micro Center** (marked down from $439.99). Amazon has listed it as low as ~$315 with Prime -- check Amazon/camelcamelcamel before paying Micro Center's price. Verified 2026-08-26 against Dell's own product page: S3425DW (part 210-BRMV), 34", 3440x1440, 120Hz, VA, **1800R**, 300 cd/m2, 3,000:1, USB-C 65W PD, 2x HDMI 2.1 + 1x USB-C upstream (DP 1.4 Alt Mode), 2x5W speakers, 1yr warranty.
- **Curvature (added 2026-08-26):** Dell 1800R, Samsung S65UC 1000R, LG flat. David's work monitor is 1800R and he likes that curve -- see the reference-point section above. This is the single strongest differentiator found so far, and it favors the Dell.
- The Dell and Samsung match on resolution and pixel density. The Dell is faster (120Hz, better-documented color gamut) and cheaper at list price; the Samsung offers a built-in KVM switch, higher USB-C power delivery (90W vs. 65W), Ethernet, and a 3-year warranty vs. Dell's 1-year.
- Amazon's live price for the Samsung couldn't be confirmed directly (Amazon blocks automated fetches) — third-party trackers show recent sale prices between roughly $339 and $499; check the listing for today's price.

## Expanded shortlist: 34-40" (researched 2026-08-26)

### The structural finding: 1800R only exists at 34"

Ultrawides get **flatter** as they get bigger. Curve radius by size class:

| Size class | Typical curvature | Distance from the 1800R David likes |
|---|---|---|
| 34" | 1800R-1900R (1000R on the S65UC) | on target |
| 38" | 2300R | noticeably flatter |
| 40" | 2500R | flattest |

So "34-40 inch" is not one search -- it is a choice between **matching the curve (34")** and **buying more screen (38-40")**. There is no 38" or 40" that curves like the work monitor.

### Additional 34" candidates (curve-matching)

| Monitor | Curve | Panel / Refresh | USB-C | Approx. price | Note |
|---|---|---|---|---|---|
| Dell UltraSharp U3425WE | 1900R | IPS Black, 120Hz, 2000:1 | Thunderbolt 4 hub, KVM built in | ~$700-900 | The premium sibling of the S3425DW: better contrast for IPS, TB4 dock, KVM |
| Samsung Odyssey OLED G8 (LS34DG856) | 1800R | QD-OLED, 175Hz | **unconfirmed -- verify before shortlisting** | ~$800-1000 | Exact curve match; OLED contrast; check it has a USB-C *input*, not just downstream |
| Alienware AW3425DW | 1800R | QD-OLED, 240Hz | **NO USB-C input** (15W downstream only) | ~$800 | Curve and panel are ideal, but it fails the single-cable requirement -- ruled out |

### 38" options (2300R -- flatter)

| Monitor | Res | Refresh | USB-C | Approx. price |
|---|---|---|---|---|
| Dell UltraSharp U3824DW | 3840x1600 | 60Hz | 90W hub + KVM | ~$1,000 |
| LG 38WN95C-W / 38BN95C-W | 3840x1600 | 144Hz | Thunderbolt 3 | ~$1,000-1,400 |

Note on sharpness: 3840x1600 at 38" is ~111 PPI -- **essentially identical to 3440x1440 at 34" (~110 PPI)**. A 38" buys desk width, not crispness.

### 40" options (2500R -- flattest)

| Monitor | Res | Refresh | USB-C | Approx. price |
|---|---|---|---|---|
| Dell UltraSharp U4025QW | 5120x2160 | 120Hz | Thunderbolt 4 hub | $2,399 MSRP, often less |
| LG 40WP95C | 5120x2160 | 72Hz | Thunderbolt 4 | ~$1,300-1,800 |

These are the only genuinely **sharper** option (~140 PPI vs ~110), but they are 4-7x the Dell S3425DW's price and the furthest from the preferred curve.

### The KVM: identified 2026-08-26

**NAWEN KVM Switch, model KC-KVM202AS-NA** (Amazon ASIN B0C1GVKD8L).

| Spec | Value |
|---|---|
| Capacity | 2 computers, 2 monitors (dual-head) |
| Rated video | **4K @ 60Hz**, **2K @ 144Hz** |
| Implied HDMI generation | **HDMI 2.0 (18 Gbps)** -- both rated modes sit right at that ceiling |
| USB | 4x USB 3.0 shared ports |
| EDID | "Simulation EDID" (EDID emulation) |
| Reviews | 3.7 / 5 from ~72 ratings |

**Correction to the earlier note in this file:** the 75Hz figure recorded in the research
doc was read as evidence of an HDMI 1.4-era KVM. That was wrong. 75Hz is the **LG
29WN600-W's own panel maximum** -- the KVM was never the limit. This switch is HDMI 2.0.

### What that means for the S3425DW

Approximate TMDS bandwidth for 3440x1440, 8-bit, against the KVM's ~18 Gbps ceiling:

| Mode | Approx. required | Through this KVM |
|---|---|---|
| 3440x1440 @ 60Hz | ~12 Gbps | comfortable |
| 3440x1440 @ 100Hz | ~16 Gbps | **should fit** |
| 3440x1440 @ 120Hz | ~19 Gbps | **over budget -- will not pass** |

So the existing KVM should carry the Dell at up to roughly **100Hz**, but not its full
120Hz. Worth noting: **100Hz is exactly what the work monitor runs at**, and that setup
is the one David is happy with -- so the practical loss is close to nothing.

**The real risk is EDID, not bandwidth.** 3440x1440 is a non-standard mode for these
switches, and budget KVMs with EDID emulation frequently advertise only a fixed list of
standard resolutions, forcing an ultrawide down to 1920x1080 or 2560x1440 regardless of
available bandwidth. At 3.7 stars this is not a premium unit. This cannot be tested
without a 3440x1440 panel in hand.

**Therefore: buy the monitor somewhere with a clean return window, and test the KVM leg
first thing.** Micro Center and Amazon both qualify.

### Wiring options, in preference order

1. **Through the KVM at 100Hz** -- keeps one-button switching, matches the work monitor's
   refresh. The default plan if EDID cooperates.
2. **Direct USB-C from the mini** -- full 3440x1440 @ 120Hz on a single cable (mini has
   HDMI + 3x Thunderbolt 4; the S3425DW has a USB-C upstream port with DP 1.4 Alt Mode).
   Costs the one-button switching on that display.
3. **Replace the KVM** with an HDMI 2.1 dual-head unit -- only worth it if EDID emulation
   turns out to mangle the ultrawide mode entirely.

## To research

- [x] ~~Decide the budget tier~~ -- **S3425DW purchased 2026-08-26**
- [x] ~~Buy from a retailer with a clean return window~~ -- done; return window still the safety net if the refresh cap is unacceptable
- [x] ~~Test 3440x1440 through the KVM~~ -- **native 3440x1440 confirmed passing.** EDID emulation did not mangle the ultrawide mode
- [x] ~~Resolve 100Hz vs the panel's 120Hz~~ -- **confirmed 2026-08-26: no 120Hz mode offered through the KVM.** HDMI 2.0 bandwidth ceiling, as predicted. Recoverable only by bypassing the KVM
- [ ] Confirm Mac Mini compatibility on its own leg (USB-C/Thunderbolt alt-mode) once the mini arrives
- [x] ~~Confirm Amazon price for the Samsung listing~~ -- moot, not purchased
- [x] ~~Confirm whether the Samsung Odyssey OLED G8 has a true USB-C input~~ -- moot, not purchased
- [x] ~~Price the work monitor's own model as a fourth option~~ -- moot, decision closed
- [x] ~~Add any additional candidates~~ -- closed

## Product links

- Dell 34 Plus S3425DW: https://www.dell.com/en-us/shop/dell-34-plus-usb-c-monitor-s3425dw/apd/210-brmv/monitors-monitor-accessories
  - Micro Center (same monitor, verified 2026-08-26): https://www.microcenter.com/product/711663/dell-s3425dw-34-2k-uwqhd-(3440-x-1440)-120hz-ultrawide-curved-screen-monitor
  - Amazon price history: https://camelcamelcamel.com/product/B0F1H325FN
- NAWEN KVM (existing, KC-KVM202AS-NA): https://www.amazon.com/dp/B0C1GVKD8L
- Samsung ViewFinity S65UC (LS34C654UANXGO): https://www.amazon.com/gp/product/B0CGKPH78F
- LG 34U530A-W: https://www.lg.com/us/monitors/lg-34u530a-w-ultrawide-monitor
