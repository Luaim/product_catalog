# Product Catalog

A small Flutter product catalog application built as a technical assessment for Neurogine.

## Stack

- Flutter
- Dart
- `http` package
- DummyJSON REST API

## How to Run

### Requirements

- Flutter SDK
- Android emulator/device 

### Steps

1. Clone the repository.
2. Open the project directory.
3. Install dependencies:

```bash
flutter pub get
```

4. Run the application:

```bash
flutter run
```

## Architecture

The project is separated into different layers:

```text
lib/
├── models/
│   └── product.dart
├── services/
│   └── product_api_service.dart
├── screens/
│   ├── product_list_screen.dart
│   └── product_detail_screen.dart
└── main.dart
```

- **Models:** Contains the Product model and JSON parsing.
- **Services:** Handles communication with the DummyJSON API.
- **Screens:** Handles the product list and product detail UI.

The API logic is separated from the UI to keep the code organized.

## Unfinished

The required features have been implemented.

The optional bonus features were not implemented within the 2–3 hour time-box:

- Pull-to-refresh
- Image loading placeholder / error handling
- Unit test
- Additional UI/UX detail

## AI Usage

AI was used for guidance, debugging, and clarification during development.

It was used to help troubleshoot Flutter/Dart issues and discuss implementation approaches.

The project structure, architecture decisions, API integration, and core application logic were implemented and reviewed manually.
