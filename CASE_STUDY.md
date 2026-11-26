# Revio — Flashcard Learning App · Case Study

## Overview

**Revio** is a fully offline Flutter flashcard app I built from scratch as a portfolio project to practise Clean Architecture, Cubit-based state management, and local persistence with Hive CE. The app is published on Google Play and covers the full product loop — adding cards, organizing them by topic, studying them, and testing yourself with two quiz modes.

---

## The Problem

Most flashcard apps either require an internet connection, force a rigid structure on the learner, or treat the quiz as a simple right/wrong binary with no tolerance for real typing variance. I wanted to build something that:

1. Works fully **offline**, always.
2. Lets the user **organize cards into topics** they define themselves.
3. Has a **study mode** that feels natural — swipe, flip, shuffle.
4. Has a **smart quiz** that understands partial answers, typos, and alternate phrasings without being too lenient.
5. Tracks **progress over time** with persistent quiz history.

---

## Architecture

The project is structured around **feature-based Clean Architecture** with three layers per module:

```
feature/
├── data/      → models + repository (Hive CE)
├── logic/     → Cubit + state classes
└── ui/        → screen + widgets
```

**7 feature modules**: `add_new_card`, `cards`, `home`, `quiz`, `review`, `study`, `genres`

Shared infrastructure (theming, routing, helpers, shared widgets) lives in `core/`.

### State Management

5 Cubits, 21 explicit state classes:

| Cubit | States |
|:------|:-------|
| `GetAllCardsCubit` | Initial → Loading → LoadedSuccess / Error |
| `AddCardCubit` | Initial → Loading → Success / Error |
| `EditCardCubit` | Initial → Loading → Success / Error |
| `DeleteCardCubit` | Initial → Loading → Success / Error |
| `QuizCubit` | TopicSelection → ModeSelection → InProgress → Completed |

`GetAllCardsCubit` is provided at the **app root** and subscribes to `CardsRepo.watchCards()` — an `async*` stream over Hive's `.watch()` event bus. Any write (add, edit, delete, favorite toggle) automatically propagates to every screen with no manual refresh.

### Local Persistence

4 Hive CE boxes opened at startup with per-box error recovery (delete & reopen on corruption):

| Box | Type | Content |
|:----|:-----|:--------|
| `flash_cards_box` | `Box<CardModel>` | All flashcards |
| `custom_categories_box` | `Box<String>` | User-created topic names |
| `deleted_core_categories_box` | `Box<String>` | Built-in topics the user deleted |
| `quiz_history_box` | `Box<dynamic>` | Serialized `QuizResultModel` maps |

---

## Key Engineering Decisions

### 1 — The 5-Tier Answer Matcher

The biggest custom piece of engineering in the app. Accepts `userAnswer` and `correctAnswer`, normalizes both (lowercase → trim → collapse whitespace → strip leading article: *a / an / the*), then walks a pipeline:

| Tier | Rule |
|:-----|:-----|
| **Exact** | Normalized strings are identical |
| **Alternative** | Card answer split on `/` `\|` `;` `,` `or` — user matches any variant |
| **Numeric** | First extractable number is the same (digit or word-form 0–10) |
| **Partial** | One string contains the other; ratio ≥ 0.45; min length ≥ 3 chars; no negation conflict |
| **Fuzzy** | Levenshtein distance ≤ adaptive max (0 for ≤5 chars, 1 for ≤10, 2 for longer); similarity ≥ 0.82 |

The **negation conflict guard** was added after finding that "correct" and "not correct" were matching via partial — it blocks partial matches when exactly one string contains a negation word.

Returns a typed `AnswerResult(isCorrect, matchType, similarity)` — the `matchType` enum makes it easy to surface feedback in a future version.

### 2 — Shared `CategoryFilterHelper` Modal

The topic + favorites filter UX is identical across Library, Study Mode, and Quiz. Rather than duplicating the bottom sheet three times, I extracted `CategoryFilterHelper.showCategoryFilterModal()` as a static method in `core/helpers/`. It takes callbacks (`onCategoriesChanged`, `onFavoritesToggled`, `onResetFilters`) and renders per-topic card counts dynamically from the passed card list.

### 3 — Flip Key Management in Study Mode

Each `FlipCard` widget needs a persistent `GlobalKey<FlipCardState>` to programmatically reset it. I store keys in a `Map<String, GlobalKey>` keyed by `card.id`. When navigating between cards, the old card's key is removed from the map so the next time that card appears (after shuffling or going back) it always starts face-up. The `ValueKey(card.id)` on the `StudyFlashCard` widget ensures Flutter replaces rather than reuses the widget tree.

### 4 — Quiz Session Isolation

The `QuizCubit` holds an integer `_sessionId` that increments on every `emitStartQuiz` / `emitSkipCard` / `emitShowTopicSelection`. Delayed callbacks (`Future.delayed`) capture the session ID at dispatch time and no-op if the ID has changed by the time they fire — preventing stale state transitions when the user exits a quiz mid-session.

### 5 — Responsive Layouts

All sizing uses `flutter_screenutil` (360 × 690 canvas). Screens use `LayoutBuilder` + `ConstrainedBox` to cap width:

- Quiz / Results: **700 dp**
- Study / Add Card: **750 dp**
- Home / Topics: **800 dp**
- Library: **850 dp**

The quiz card height is calculated as `(constraints.maxHeight * 0.25).clamp(135.0, 200.0)` to stay proportional on both small phones and tablets. Keyboard insets are handled via `MediaQuery.viewInsetsOf(context).bottom` added to the scroll view padding.

---

## Features Shipped

| Feature | Details |
|:--------|:--------|
| **Home Dashboard** | Live animated stat counters (cards, favorites, topics) via reactive stream; study mode banner; recent quiz banner; 6-destination navigation drawer |
| **Flashcards** | 3D flip animation (350–400 ms); category color badge; optional hint with 💡 icon; Arabic RTL auto-detection per field; semantic accessibility labels |
| **Library** | Full-text search (question + answer + hint); topic/favorites filter modal; live "Showing X / Y" counter; swipe-to-delete; inline add; pre-filter from home chips |
| **Topics** | 8 built-in + unlimited custom; rename (cards auto-update); delete with card reassignment; protected default (*No Topic*) |
| **Study Mode** | Swipe navigation; 3D flip; shuffle; topic & favorites filter; prev/next/finish nav; per-card flip key management |
| **Quiz Arena** | Per-topic & favorites filter; MCQ (4 options, A–D labels, animated color feedback, auto-advance 1 000 ms) + Smart Typing (5-tier matcher, skip 600 ms); hint toggle; correct-answer banner; exit guard |
| **Quiz Results** | Animated score ring (CustomPainter, 1800 ms `Interval` easing); performance badge; stats card; play again / back |
| **Quiz History** | Persistent Hive storage; average accuracy; sorted by recency; per-entry & bulk deletion |
| **Add Card** | Topic chip picker; optional hint; favorite toggle; discard protection via `PopScope` |

---

## Design System

**Theme:** Material 3 dark — *Midnight Obsidian & Cyber Cyan*

- 24 named color tokens
- 7 `LinearGradient` constants
- 27 `Manrope` text styles (all responsive via `flutter_screenutil`)
- Per-screen glow background variants (`GlowVariant.home / review / quiz / addCard`)
- `PressScale` wrapper for tactile button feedback
- Glassmorphic `AppCard` used throughout

---

## Challenges & What I Learned

**Challenge 1 — Stream-based real-time sync across unrelated screens**
Connecting Hive's `.watch()` box events to a root Cubit that broadcasts to all screens required careful `StreamSubscription` lifecycle management (cancel in `close()`). The payoff is that any write anywhere immediately reflects everywhere with zero boilerplate.

**Challenge 2 — Building a fair but forgiving answer matcher**
The first version was too strict (exact only). The second was too lenient (long partial matches). The final 5-tier design with adaptive Levenshtein thresholds and negation conflict detection hits the right balance for a real study tool.

**Challenge 3 — Quiz session state with async delays**
Using `Future.delayed` for auto-advance while supporting mid-quiz exit required the session-ID guard to prevent ghost state transitions. It's a simple pattern but easy to miss when building reactive UIs.

**Challenge 4 — Reusing filter UX without duplication**
The same filter modal needed to work in three contexts (Library, Study, Quiz) with different callback signatures and data sources. Extracting it into a static helper with callback parameters rather than a stateful widget eliminated three copies of 150+ lines of UI code.

---

## Tech Stack

Flutter · Dart 3.14 · flutter_bloc (Cubit) · Hive CE · flip_card · flutter_screenutil · Material 3 · Manrope

---

## Links

- 🛒 [Google Play](https://play.google.com/store/apps/details?id=com.ahmed.revio&hl=en_US)
- 🎬 [Demo Video](https://youtube.com/shorts/FsG1XUAbmDY?si=lvngji7Uz-EKRROJ)
- 💻 [GitHub Repository](#)
