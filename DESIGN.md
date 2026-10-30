# Design System: Hpyat Mal (Inspired by Starbucks Dual-Theme Sanctuary)

## 1. Visual Theme & Atmosphere

**Hpyat Mal** ("ဖြတ်မယ်" — Forest Quit Tracker) adopts a **warm, calm, minimalist sanctuary design system** modeled directly on **Starbucks' four-tier botanical color architecture and warm café-material surfaces**, adapted for a dual-theme quit-smoking wellness experience:
1. **Emerald Forest (`PlantThemeType.emerald`)** — Classic Starbucks apothecary & forest green palette.
2. **Cherry Blossom (`PlantThemeType.cherry`)** — Sakura Reserve palette calibrated to the exact same four-tier luminance, contrast, and warm cream temperature as Starbucks.

Instead of sterile, cold-white medical screens or noisy multi-colored dashboards, the canvas alternates between **Neutral Warm Cream** (`#F2F0EB` / `#F5F0F1`) and **Ceramic Off-White** (`#EDEBE9` / `#EFEAEC`), while pure white (`#FFFFFF`) cards rest on top with whisper-soft elevation. Deep **House Bands** (`#1E3932` in Emerald / `#381824` in Cherry) anchor hero sanctuary moments, streak milestones, and breathing immersions. **Rewards Gold** (`#CBA258`) is reserved strictly for smoke-free milestone ceremonies and savings achievements—never as a general-purpose decorative color.

**Key Characteristics:**
- **Dual-Theme Four-Tier Botanical System:** Every color role (`forestDeep`, `forestPrimary`, `emerald`, `forestMedium`, `leafSoft`) maps 1:1 between **Emerald Forest** and **Cherry Blossom**, maintaining identical visual weight and contrast.
- **Warm-Neutral Canvas (`#F2F0EB` / `#F5F0F1`) Instead of Cold White:** Reduces visual fatigue during daily check-ins, breathing exercises, and journaling.
- **Pure White Cards (`#FFFFFF`) on Cream:** Content hierarchy is achieved through surface temperature shifts and whitespace rather than heavy borders or drop shadows.
- **Gold Reserved for Ceremony (`#CBA258`):** Used exclusively for smoke-free streak badges, unlocked health milestones, and savings rewards.
- **Universal Pill Actions (`50px` radius) & `scale(0.95)` Micro-Interaction:** Every interactive button is a full pill that gently compresses on tap.
- **Whisper-Soft Layered Shadows:** Cards use `12px` border radius with subtle two-layer ambient shadows (`0.14` / `0.24` alpha max) or clean `1px` warm hairlines.
- **Color-Block Page Rhythm:** Warm cream canvas → Pure white content cards → Deep House (`#1E3932` / `#381824`) feature bands with white text → Gold-tinted milestone callouts (`#FAF6EE`). No decorative gradients.

---

## 2. Color Palette & Roles (`AppColors` Dual-Theme Reference)

All colors resolve dynamically through `AppColors` (`lib/core/theme/app_color.dart`) based on the active `PlantThemeType`.

### Tier 1: Primary Four-Tier Botanical Hierarchy

| Semantic Token (`AppColors`) | Role in Starbucks System | Emerald Forest (`emerald`) | Cherry Blossom (`cherry`) | Functional Usage |
| :--- | :--- | :--- | :--- | :--- |
| **`forestDeep`** | **House Green** (Deep Band) | `#1E3932` | `#381824` | Deep sanctuary feature bands, streak hero numbers, primary app bar titles, dark immersion surfaces |
| **`forestPrimary`** | **Starbucks Green** (Brand) | `#006241` | `#8C234B` | Primary brand headings (`H1`), active navigation tabs, primary icons, selected theme border |
| **`emerald`** | **Green Accent** (Action CTA) | `#00754A` | `#A8325D` | Primary filled pill buttons, floating action button ("Frap"), active progress rings, toggle switches |
| **`forestMedium`** | **Green Uplift** (Mid-Tone) | `#2B5148` | `#5E2A3D` | Secondary interactive badges, subtle dark-surface accents, breathing ring outer halo |
| **`mintAccent`** | **Luminous Accent** | `#3D9970` | `#C85A82` | Vitality pulse dot, chart highlight bar, active streak spark |
| **`sageLight`** | **Botanical Muted** | `#6B9E88` | `#D88AA6` | Inactive botanical illustrations, secondary progress track, subtle icon tint |
| **`leafSoft`** | **Green Light** (Soft Wash) | `#D4E9E2` | `#F3DCE4` | Pill badge backgrounds, selected card wash, valid form-field tint, soft icon containers |
| **`leafBackground`** | **Whisper Tint** | `#EBF4F0` | `#F9EFF3` | Subtle section highlight, breathing background wash |

### Tier 2: Warm Canvas & Ceramic Surfaces

| Semantic Token (`AppColors`) | Role in Starbucks System | Emerald Forest (`emerald`) | Cherry Blossom (`cherry`) | Functional Usage |
| :--- | :--- | :--- | :--- | :--- |
| **`surface`** | **Neutral Warm** (Canvas) | `#F2F0EB` | `#F5F0F1` | Primary `Scaffold` background across all screens — warm paper cream, never pure white |
| **`surfaceCard`** | **White** (Card Surface) | `#FFFFFF` | `#FFFFFF` | Primary content cards, modals, bottom sheets, input fields, bottom navigation bar |
| **`surfaceCardMuted`** | **Ceramic** (Utility Zone) | `#EDEBE9` | `#EFEAEC` | Secondary inset containers, unselected segment pills, quiet utility rows |
| **`border`** | **Warm Hairline** | `#DFDCD5` | `#E6DFE1` | `1px` card outlines, input borders (`#D6DBDE` equivalent), divider hairlines |
| **`borderSubtle`** | **Soft Hairline** | `#E8E5DF` | `#EFEAEB` | Internal row separators inside white cards (nutrition/health table style) |

### Tier 3: Rewards Ceremony & Earth Accents

| Semantic Token (`AppColors`) | Role in Starbucks System | Emerald Forest (`emerald`) | Cherry Blossom (`cherry`) | Functional Usage |
| :--- | :--- | :--- | :--- | :--- |
| **`amberWarm`** | **Rewards Gold** | `#CBA258` | `#CBA258` | Milestone stars (`★`), smoke-free badge rings, money-saved celebration accents |
| **`amberLight`** | **Gold Lightest** | `#FAF6EE` | `#FAF6EE` | Warm cream-gold card background for personal promises, rewards, and milestone banners |
| **`barkBrown`** | **Espresso Earth** | `#4E3629` | `#54343A` | Tree trunk illustration anchor, grounding earth metadata |
| **`skyMist`** | **Neutral Cool** | `#F9F9F9` | `#FAF8F9` | Quiet utility containers, breathing calm backdrop |
| **`skySoft`** | **Gold Light** | `#DFC49D` | `#DFC49D` | Gold-tier border rings (`1px solid #DFC49D`) on milestone cards |

### Tier 4: Warm Typography & Semantic Feedback

| Semantic Token (`AppColors`) | Role in Starbucks System | Emerald Forest (`emerald`) | Cherry Blossom (`cherry`) | Functional Usage |
| :--- | :--- | :--- | :--- | :--- |
| **`baseBlack` / `textPrimary`** | **Text Black** (`87%` Ink) | `#1F1F1F` | `#241A1E` | Primary headings and body copy on light surfaces (never harsh `#000000`) |
| **`textSecondary`** | **Rewards Slate** | `#33433D` | `#4E3840` | Subtitles, metric labels, and descriptive copy with a subtle botanical undertone |
| **`textMuted`** | **Text Black Soft** (`58%`) | `#6B6A65` | `#75686C` | Timestamps, units, helper captions, inactive tab labels |
| **`textLight` / `baseWhite`** | **Text White** | `#FFFFFF` | `#FFFFFF` | Primary text on `forestDeep` (`#1E3932` / `#381824`) and `emerald` CTA surfaces |
| **`danger` / `dangerSoft`** | **Red** (Destructive) | `#C82014` / `#FBE9E7` | `#C82014` / `#FBE9E7` | Relapse reset warning, destructive delete actions, form validation errors |
| **`warning` / `warningSoft`** | **Yellow** (Craving Alert) | `#D99B26` / `#FEF6E6` | `#D99B26` / `#FEF6E6` | Craving intensity indicator, gentle caution prompts |
| **`success` / `successSoft`** | **Green Accent / Light** | `#00754A` / `#D4E9E2` | `#8C234B` / `#F3DCE4` | Completed health recovery stages, daily check-in confirmation |

---

## 3. Typography Rules (`AppTextStyle`)

### Font Family
- **Primary UI & Myanmar Support:** `Noto Sans Myanmar` (via `GoogleFonts.notoSansMyanmar`) paired with humanist geometric metrics inspired by Starbucks' `SoDoSans`.
- **Numeric Figures:** `FontFeature.tabularFigures()` enabled on all timers, streak counters, currency amounts, and health percentages so live-ticking digits never jitter horizontally.

### Hierarchy Scale

| Style Token (`AppTextStyle`) | Size | Weight | Line Height | Letter Spacing | Color Role | Typical Use |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`numberDisplay`** | `44px` | `w800` / `w700` | `1.15` | `-1.0px` | `forestDeep` | Smoke-free days counter, total savings hero number |
| **`display`** | `32px` | `w700` | `1.25` | `-0.5px` | `textPrimary` | Onboarding hero headlines, milestone celebration titles |
| **`headingLarge`** | `24px` | `w600` | `1.40` | `-0.2px` | `forestPrimary` | Primary section H1 (Starbucks-style weight + color hierarchy) |
| **`headingMedium`** | `20px` | `w600` | `1.40` | `-0.16px` | `textPrimary` | Card group headers, modal titles |
| **`headingSmall`** | `17px` | `w600` | `1.45` | `-0.16px` | `forestDeep` | AppBar titles, card titles, setting section headers |
| **`bodyLarge`** | `16px` | `w400` | `1.55` | `-0.16px` | `textPrimary` | Primary reading copy, journal entries, health descriptions |
| **`bodySemiBold`** | `15px` | `w600` | `1.45` | `-0.16px` | `textPrimary` | Pill button labels, list item titles, metric values |
| **`bodyMedium`** | `15px` | `w400` | `1.55` | `-0.16px` | `textSecondary` | Card subtitles, stage descriptions, settings descriptions |
| **`captionMedium`** | `13.5px` | `w500` | `1.45` | `-0.1px` | `textSecondary` | Metadata labels, date stamps, stat unit labels |
| **`captionSmall`** | `12px` | `w600` | `1.40` | `0.3px` | `textMuted` | Eyebrow category tags, "200★" style milestone badges |

### Typographic Principles
1. **Weight & Color Carry Hierarchy Over Size Inflation:** Following Starbucks' H1/H2 rule, section headers stay compact (`17px–24px`), using `w600` + `forestPrimary` (`#006241` / `#8C234B`) or `forestDeep` to stand out against `w400` `textSecondary` body copy.
2. **Tight, Confident Tracking:** Subtle negative letter-spacing (`-0.16px` to `-0.5px`) on Latin/numeric glyphs keeps headers crisp and composed.
3. **Generous Myanmar Line-Height:** Maintain `1.45–1.60` line height so stacked Myanmar consonant/vowel diacritics never clip vertically.

---

## 4. Component Stylings

### Buttons

1. **Primary Filled Pill (Starbucks Green Accent / Sakura Accent)**
   - **Background:** `AppColors.emerald` (`#00754A` in Emerald / `#A8325D` in Cherry)
   - **Text:** `AppColors.baseWhite` (`#FFFFFF`), `15px`, `w600`
   - **Border Radius:** `50px` (full pill — universal rule)
   - **Padding:** `12px 24px` (mobile touch target `>= 48px` height)
   - **Micro-interaction:** `scale(0.95)` on press (`200ms Curves.easeOut`)

2. **Secondary Outlined Pill**
   - **Background:** `Colors.transparent`
   - **Text:** `AppColors.emerald` (`#00754A` / `#A8325D`)
   - **Border:** `1.5px solid AppColors.emerald`
   - **Border Radius:** `50px` (full pill)

3. **Inverted Pill on Deep House Band**
   - **Background:** `AppColors.baseWhite` (`#FFFFFF`)
   - **Text:** `AppColors.forestDeep` (`#1E3932` / `#381824`)
   - **Used on:** Deep House (`forestDeep`) hero cards or craving relief banners.

4. **Floating Action Button ("Frap" Sanctuary Action — e.g., Add Journal / Craving SOS)**
   - **Background:** `AppColors.emerald` (`#00754A` / `#A8325D`)
   - **Foreground:** `AppColors.baseWhite` (`#FFFFFF`)
   - **Shape:** `56px × 56px` full circle (`50%`)
   - **Shadow Stack:**
     - Base halo: `BoxShadow(color: Colors.black.withValues(alpha: 0.20), blurRadius: 6, offset: Offset.zero)`
     - Ambient lift: `BoxShadow(color: Colors.black.withValues(alpha: 0.14), blurRadius: 12, offset: Offset(0, 8))`

### Cards & Containers

1. **Standard Content Card (White on Warm Cream)**
   - **Background:** `AppColors.surfaceCard` (`#FFFFFF`)
   - **Border Radius:** `12px` (or `16px` for major sanctuary hero panels)
   - **Elevation / Border:** Whisper-soft dual shadow (`BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: Offset(0, 2))`) paired with a `1px solid AppColors.borderSubtle` hairline.
   - **Internal Padding:** `16px` (`--space-3`) to `20px`.

2. **House Feature Band Card (Rewards / Sanctuary Hero Panel)**
   - **Background:** `AppColors.forestDeep` (`#1E3932` in Emerald / `#381824` in Cherry)
   - **Text:** `AppColors.baseWhite` (`#FFFFFF`) primary, `Colors.white.withValues(alpha: 0.72)` secondary
   - **Accent:** Gold (`#CBA258`) milestone pill (`1px solid #CBA258`, `50px` radius)
   - **Border Radius:** `16px`
   - **Usage:** Hero streak banners, breathing focus cards, or savings summary headers.

3. **Gold Ceremony / Promise Card (Starbucks Partnership / Milestone Wash)**
   - **Background:** `AppColors.amberLight` (`#FAF6EE`)
   - **Border:** `1px solid AppColors.skySoft` (`#DFC49D`)
   - **Accent Icon / Badge:** `AppColors.amberWarm` (`#CBA258`)
   - **Border Radius:** `12px`
   - **Usage:** Personal Quit Promise (`MotivationAnchorCardWidget`), unlocked achievements, and milestone rewards.

4. **Nutrition-Style Recovery & Stat Rows**
   - **Container:** Inside a `#FFFFFF` card
   - **Row Structure:** Label on the left (`bodyMedium` `textSecondary`), tabular value on the right (`bodySemiBold` `textPrimary`), separated by a `1px solid AppColors.borderSubtle` horizontal hairline.

### Inputs & Selection Controls

- **Text Fields & Dropdowns:**
  - **Fill:** `AppColors.surfaceCard` (`#FFFFFF`)
  - **Border:** `1px solid AppColors.border` default; `1.5px solid AppColors.emerald` when focused
  - **Radius:** `12px` (or `8px` for compact inline inputs)
- **Option / Theme Selector Cards (`ThemeChoiceCardWidget`):**
  - **Selected State:** `2px solid AppColors.emerald` ring with `AppColors.leafSoft` icon badge wash, mirroring Starbucks' size-selector active ring (`2px solid #00754A`).
  - **Unselected State:** `1px solid AppColors.borderSubtle` on `#FFFFFF` card.

---

## 5. Layout & Whitespace Principles

### Spacing Scale (`8px` / `16px` Rhythm)
- **`4px` (`space-1`):** Tightest inline icon-to-label gap
- **`8px` (`space-2`):** Compact vertical gap between title and subtitle
- **`12px` (`space-2.5`):** Gap between stacked cards in a dense list
- **`16px` (`space-3`):** Universal baseline — default screen horizontal gutter (`16px–18px`), default card padding, and standard section gap
- **`24px` (`space-4`):** Major section-to-section breathing room
- **`32px` (`space-5`):** Hero zone vertical padding

### Whitespace Philosophy
- **Let the Warm Cream Canvas Breathe:** Never crowd cards edge-to-edge. The `#F2F0EB` / `#F5F0F1` background acts as visual silence between white cards and deep House bands.
- **No Unnecessary Box Wrapping:** Keep hero counters (`StreakCounterWidget`) or section headers unboxed directly on the warm cream canvas when possible, reserving `#FFFFFF` cards for actionable or grouped data.

---

## 6. Depth & Elevation Rules

| Surface Level | Visual Treatment | Where Used |
| :--- | :--- | :--- |
| **Level 0 — Canvas** | Solid `AppColors.surface` (`#F2F0EB` / `#F5F0F1`) | `Scaffold` background |
| **Level 1 — Ceramic Zone** | Solid `AppColors.surfaceCardMuted` (`#EDEBE9` / `#EFEAEC`) | Segmented controls, secondary inset blocks |
| **Level 2 — Content Card** | Solid `#FFFFFF` + `1px` `borderSubtle` + whisper shadow (`alpha: 0.05`, `blur: 6`, `y: 2`) | Quick stats, health timeline items, journal cards |
| **Level 3 — House Feature Band** | Solid `AppColors.forestDeep` (`#1E3932` / `#381824`) | Deep sanctuary banners, primary summary cards |
| **Level 4 — Floating Navigation / CTA** | Layered ambient shadow (`alpha: 0.12–0.20`, `blur: 12`, `y: 6`) | Bottom navigation bar, floating action buttons |

---

## 7. Do's and Don'ts

### Do
- **Do** use `AppColors.surface` (`#F2F0EB` Emerald / `#F5F0F1` Cherry) as the universal screen background—the warm cream temperature is the foundation of the minimalist look.
- **Do** map the four botanical tiers strictly to their roles:
  - `forestDeep` (`#1E3932` / `#381824`) for deep bands & hero numbers
  - `forestPrimary` (`#006241` / `#8C234B`) for headings & active nav
  - `emerald` (`#00754A` / `#A8325D`) for filled pill CTAs & active rings
  - `leafSoft` (`#D4E9E2` / `#F3DCE4`) for soft badge/icon washes
- **Do** reserve `amberWarm` (`#CBA258`) and `amberLight` (`#FAF6EE`) for milestone ceremonies, streak stars, and personal promises.
- **Do** use `50px` full-pill border radius on all primary and secondary buttons.
- **Do** keep cards at `12px–16px` radius with solid fills (no multi-stop decorative gradients).

### Don't
- **Don't** hardcode green or pink hex values inside feature widgets—always reference `AppColors` semantic getters so switching between **Emerald Forest** and **Cherry Blossom** updates every screen instantaneously.
- **Don't** use cold `#FFFFFF` or cool gray (`#F5F7FA`) as the `Scaffold` background.
- **Don't** use pure `#000000` for body text—use `AppColors.textPrimary` (`#1F1F1F` / `#241A1E`) and `AppColors.textSecondary` (`#33433D` / `#4E3840`).
- **Don't** apply heavy, blurry drop shadows or neon glows to cards.
- **Don't** mix multiple competing accent colors on a single card—let the active plant theme + warm cream + crisp white carry the entire visual identity.
