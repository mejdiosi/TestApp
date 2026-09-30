# AGENTS.md

Guidance for AI coding agents working in this repository.
              
              ## Project
              
              iOS app (Swift, SwiftUI) for the leboncoin iOS recruitment technical test. It displays listings from the local API server in `server/`.
              
              The deliverable is judged as **production-ready**: code quality, maintainability, best practices, robustness and relevance of choices. **Keep it simple, readable and small.** Depth matters more than breadth.
              
              ## Hard constraints
              
              - Language: Swift. UI: SwiftUI. No storyboards, no `.xib`.
              - Deployment target: **iOS 16+** (do not use `@Observable`, `SwiftData`, or other iOS 17+ APIs).
              - **No external libraries** (no SPM dependencies in the app).
              - Reference runtime: iPhone simulator.
              - **Never modify `server/`.** It is a test fixture.
              - Do not edit `Info.plist` for networking; `NSAllowsLocalNetworking` is already set.
- Only one bonus option at most, and only after the core is complete and tested.

## Architecture

MVVM, protocol-based services, dependency injection through initializers.

```
App/            App entry point, composition root
Models/         Listing, Category, ListingFeed, ImagesURL (Decodable, Equatable)
APIService/     APIServiceProtocol, APIService, Endpoint, APIError
Scenes/
ListingList/    View, ViewModel, Row
ListingDetail/  View


Rules:

- Views contain no networking or business logic.
- ViewModels are `@MainActor final class ... : ObservableObject` with `@Published` state.
- Screen state is explicit (idle / loading / loaded / failed) so loading, error (with retry) and empty states are always intentional.
- Services are injected as protocols so tests can use mocks. Nothing in tests may call the real server.
- Use `async/await` and `URLSession`. Throw a typed `APIError`; never swallow errors silently.
- Build URLs with `URLComponents`, never string concatenation.

## Code style

- Prefer the simplest solution that works. No speculative abstractions, no unused code.
- `final` by default, `private` by default, value types for models.
                                                              - Small files, one main type per file, clear names. No force unwraps (`!`) and no `try!` in app code.
                                                              - Comments explain *why*, not *what*. Code should read on its own.
                                                              - Use `Locale`-aware formatting for prices and dates.
                                                              
                            


Keep `REFLECTION.md` at the repository root and update it as work progresses. It must cover:

1. Tools used and for what.
                        2. At least one concrete AI suggestion that was **rejected, corrected or rewritten**, and why.
                        3. Architectural decisions owned by the developer.
                        4. Ambiguities found in the prompt or API and how they were handled (assumptions).
                        5. Trade-offs, and what would be done with more time.
                        
                        **Agents:** when you propose something the developer changes or rejects, or when you notice an ambiguity, say so clearly in your reply so it can be recorded.
                        
                        ## Working agreement for agents
                        
                        - Make small, focused changes. Explain the reasoning briefly.
                        - Do not add features, dependencies, or files beyond the request.
                        - Before finishing a task: it builds, tests pass, no warnings introduced.
                        - Ask when a requirement is ambiguous instead of guessing silently.
