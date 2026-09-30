# Reflection

## Tools used

- Codex assisted with inspecting the SwiftUI views, applying the focused refactor, and running the app test suite.
- Xcode is used to build and run the app on the simulator.

## AI suggestion reviewed by the developer

An initial suggestion to extract a single shared listing-metadata view was rejected. The list row and detail header deliberately use different hierarchy, ordering, and accessibility, so forcing them into one configurable view would make the code harder to read. The duplicated image-loading implementation was the right shared boundary instead.

## Architectural decisions

- The existing MVVM structure is retained: `ListingListViewModel` owns loading, filtering, and presentation state; views only render it.
- `ListingImageView` centralizes remote-image loading, fallback, background, and clipping; its callers control size and aspect ratio.
- Tests use an injected `APIServiceProtocol` mock, so they never call the local server.

## Assumptions

- Missing category IDs should display as `Other`, matching `ListingItem.unknownCategoryName`.
- Listing image paths are server-relative and must be resolved against the configured base URL.

## Trade-offs and future work

- The tests focus on view-model state, filtering, mapping, and image URL resolution. With more time, the API client could be tested using a custom `URLProtocol` to cover status and decoding failures without network access.
