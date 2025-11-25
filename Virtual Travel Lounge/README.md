# Virtual Travel Lounge (tvOS prototype)

This repository contains a tvOS SwiftUI prototype called "Virtual Travel Lounge" designed for Apple TV (tvOS 17+).

Overview
- Platform: tvOS (Apple TV simulator)
- UI: SwiftUI (focus-driven, large tappable items)
- Purpose: Showcase curated destination tours with slideshows & narration, quizzes, and per-profile bookmarks.

What is included
- Home carousel with destination cards
- Destination detail screen with Play / Quiz / Bookmark actions
- Full-screen Tour Player (slideshow + narration via `AVAudioPlayer`)
- Quiz flow with immediate feedback and Core Data persistence of results
- Favorites view showing bookmarked destination IDs
- Profile modal to create local profiles
- Settings view with captions/autoplay/UI scale toggles
- Bundled `destinations.json` describing 4 sample destinations
- Core Data model updated to include `Profile`, `Bookmark`, and `QuizResult` entities

Notes about bundled media
- The project includes `destinations.json` that references images and MP3 files such as `paris1.jpg` and `paris_narration.mp3`.
- For the evaluation/demo, please add high-resolution images (5 per destination) and short narration audio files into the project's Asset Catalog or add them to Copy Bundle Resources.

How to run (tvOS simulator)
1. Open the Xcode project/workspace in Xcode (make sure the target is tvOS).
2. Select a tvOS simulator (e.g., Apple TV 4K) and run the app.

Demo script (viva)
1. Open app — the Home carousel appears showing destination cards.
2. Use the Siri Remote (simulator keyboard arrows) to focus and select a destination card.
3. On the Destination Details screen, press `Play Tour` to open the full-screen player. Observe slideshow and narration.
4. Close the player. On details screen, press `Start Quiz` to answer 3 questions with immediate feedback; finish and observe final score.
5. Toggle `Bookmark` on the details screen to add to Favorites.
6. Open `Favorites` from the main menu to see saved bookmarks (CRUD: remove via swipe/delete).
7. Open `Profiles` to create a new profile and observe per-profile data segregation (scaffolded — uses Core Data). Switch profiles to see saved favorites per profile.

What is scaffolded vs stubbed
- Scaffolded:
  - UI flows for home, details, player, quiz, favorites, profiles, settings
  - JSON loader (`DataService`) to populate destinations from `destinations.json`
  - Core Data model & save for `QuizResult`, `Profile`, `Bookmark`
  - `AudioService` for simple playback of bundled narration files
- Stubbed or left as TODO:
  - Real media files (add `jpg` and `mp3` assets to the bundle)
  - Rich caption rendering tied to audio playback timeline
  - Multi-device sync / cloud (note locations for future MultipeerConnectivity/WebSocket sync)

Extending the prototype
- Add real images/audio: add files to `Assets.xcassets` or Copy Bundle Resources and ensure names match `destinations.json`.
- Improve focus animations and parallax: extend `DestinationCardView` to include depth layers.
- Add captions rendering: wire `AudioService` currentTime to captions and show subtitles overlay.
- Add authentication and cloud sync: integrate CloudKit or a backend and migrate Core Data to CloudKit-backed store.

If you want, I can:
- Add placeholder images into the asset catalog so the project is fully runnable without adding media.
- Implement more advanced caption syncing and exported demo video recording steps.

Enjoy — and tell me which part you'd like me to improve or complete next.
