# Task 3 — Flutter Mini E-Commerce

## Branch
Use Git branch: `task3`

## Requirements covered
- Product Details screen loads product details from DummyJSON using Dio.
- Cubit manages loading, success, and error states.
- Product image gallery is dynamic: tapping an image thumbnail changes the main image.
- Size selection updates the selected size UI. DummyJSON product data does not provide clothing sizes or size-specific images, so the size selector is a UI selection only; it does not falsely claim to load a different size-specific photo.
- Favorites and Offers screens are UI only.

## API
Products API documentation: https://dummyjson.com/docs/products
Single product endpoint: `https://dummyjson.com/products/1`
Base URL: `https://dummyjson.com`

DummyJSON is a sample/testing API with fictional product data, not a production commerce backend.

## Run
1. Install Flutter SDK.
2. Extract this ZIP.
3. Open the `task3` folder in VS Code.
4. Run:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
   Or run on an available Android device with `flutter run`.

## Open a product details page
The Home screen displays products fetched through Dio. Tap any product card to open its details screen.
