## 0.1.4

- Added optional select picker filters through `withFilterSupported`.
- Added local filter mode for in-memory options and remote filter mode for lazy loading request parameters.
- Preserved multiple picker selections across filter changes and added localized selected-count text.
- Improved filter popup placement, white popup styling, and search field spacing when filters are enabled.
- Fixed filter options with null values, such as an "All" option, so they can be selected reliably.
- Expanded README documentation and the example app with local and remote filter examples.

## 0.1.3

- Add vibe coding agent context for Codex, Claude, Cursor, and Copilot.

## 0.1.2

- Improved date and date range calendar day cell states, including distinct today styling and visible helper labels for selected dates.
- Added year shortcut navigation to date and date range calendar headers, with month and year buttons hidden when navigation would exceed the configured bounds.
- Improved year-month range selection behavior, including an empty end value when no initial range is provided and bounded end candidates based on the selected start.
- Added fixed-width selected range chips for year-month range pickers to avoid overly wide layouts on landscape screens.
- Updated README documentation to make English the default pub.dev README and move Chinese documentation to `README-ZH.md`.
- Expanded public API documentation and release notes for calendar, date range, year-month, checkbox, and localization features.

## 0.1.1

- Added Custom Sheet Height
- Added confirmOnTap for single picker
- Added optional checkbox indicators for multiple pickers.
- Added date and date range calendar pickers.
- Added year-month and year-month range pickers.
- Added calendar helper labels for multiple calendar systems.
- Added built-in weekday and calendar labels to localizations.
- Added month and year shortcut navigation for calendar pickers.


## 0.1.0

- Initial release.
- Added single, multiple, lazy loading, searchable, and cascade bottom sheet pickers.
- Added simple primary color theming.
- Added built-in picker labels for English, simplified Chinese, traditional Chinese, Thai, Burmese, Brazilian Portuguese, Canadian French, Italian, and Spanish.
- Added package documentation, API comments, and an example app for pub.dev.
