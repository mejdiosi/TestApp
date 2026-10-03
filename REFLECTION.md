# Reflection

## Summary

A SwiftUI app (iOS 16+, MVVM, no external libraries) that shows the listings from the local API.

- **Core:** list with image, category, title, price and urgent badge; category filter; detail screen; visible loading, error (with retry) and empty states; accessibility labels and Dynamic Type.
- **Extras:** real-time search and an iPad layout (see the scope note below).
- **UI language:** French, because the API data is French.
- **Tests:** 7 unit tests (decoding, filtering, failure state, search, request building). None of them needs the server.

## Tools used

- **Codex:** applied a focused refactor (shared image view) and ran the test suite.
- **Claude (chat):** explained the API and server, helped design the search, wrote the French wording, and helped debug two issues on iPad (see below).
- **Xcode:** build, run on the iPhone and iPad simulators, and run the tests.

## What AI helped with

- **Understanding the API.** The server keeps its data in memory from JSON files. Checking that data showed some listings have null image fields and 5 point to a file that does not exist.
- **Search.** The design is a debounce with `Task.sleep` inside `.task(id:)`, which also cancels the request when the text changes, plus a `query` parameter on the endpoint and the matching tests.
- **iPad.** Claude suggested a split view (list on the left, detail on the right) and found why the detail stayed on screen after a search.

## What I changed or rejected


- ** Unnecessary API call. **The categories are fetched again on every search. 
- **Search as the bonus,** and **French** as the app language.
- **One shared image view:** it handles loading, the placeholder and clipping in one place.
- **Choosing the bonus.** I compared Search and Pagination and chose Search, because the API has no category parameter. The category filter runs on the device, and it would only see the pages already loaded.




## Decisions I made myself

- **MVVM:** the views only display data. The view model holds the screen state, and the service is injected so tests can use a mock instead of the real server.
- **A display model (`ListingItem`):** it prepares what the screens show (category name, formatted price and date, image URL), so the views stay simple.
- **Clear screen states:** loading, loaded or failed. Errors have a short message the user can read, with a retry button.
- **Search and filter split:** the server does the text search, and the app does the category filter.

