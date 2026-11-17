# jWallet Lite

A Flutter digital-wallet demo for the jStack assessment. It uses Provider and clean layers: presentation (`WalletProvider` and screens), domain (entities), and data (Dio API repository and SharedPreferences token storage). The Express API owns the wallet balance, transaction history, validation, and idempotency.

## Setup

Install Node.js 18+ and a Flutter SDK compatible with Dart 3.13+. Start the API with `cd backend && npm install && npm start`. From the project root, run `flutter pub get`.

For Android emulator: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1`. On a physical Android device replace `10.0.2.2` with the computer's LAN IP; on iOS simulator use `http://localhost:3000/api/v1`.

Use `demo@jstack.co` / `Demo@123` to sign in.

## Flow

Login stores the bearer token locally, then loads profile, balance, and transactions concurrently. Dashboard refresh invokes the API again. Send Money validates inputs, shows a confirmation step, and sends a unique idempotency key; only the server deducts balance. A successful response refreshes dashboard data and shows the generated reference. History supports search, Credit/Debit filter, and details.

## API

`POST /api/v1/auth/login`, `GET /api/v1/users/profile`, `GET /api/v1/wallet/balance`, `GET /api/v1/transactions`, `POST /api/v1/transactions/transfer`, and `GET /api/v1/transactions/:id` are available. Errors use `{ success: false, message }` and appropriate 400, 401, 404, 409, or 500 statuses.

## Testing and limits

Run `flutter test`. The client validates login fields, mobile number, and a positive transfer amount. The backend validates available balance and returns an insufficient-balance error. The API data is intentionally in-memory and resets when it restarts. Add Money is a required UI-only action. This was AI-assisted and should be reviewed before submission.
