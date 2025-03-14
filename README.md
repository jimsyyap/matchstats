# Tennis Tracker

Tennis Tracker is a web application designed to help tennis players track their unforced errors and points won during matches. The app provides performance analytics and collaboration features to enhance player improvement.

## Features

- **User Authentication:** Secure login and registration for players and admins.
- **Match Tracking:** Manual entry of unforced errors and points won for singles and doubles matches.
- **Performance Analytics:** Visualize trends in unforced errors and points won over time.
- **Collaboration:** Share stats with coaches or teammates via exportable reports.
- **Social Features:** Leaderboards and stat comparisons with friends.

## Technology Stack

- **Frontend:** React.js (Material-UI or TailwindCSS for UI, Chart.js for visualizations).
- **Backend:** Go (Gin framework for REST APIs).
- **Database:** PostgreSQL.
- **Authentication:** JWT (JSON Web Tokens).

## Project Structure

- `frontend/`: React.js frontend code.
- `backend/`: Go backend code.
- `docker-compose.yml`: Optional Docker configuration for containerization.

## Getting Started

### Prerequisites

- Node.js and npm installed for the frontend.
- Go installed for the backend.
- PostgreSQL database running locally or in the cloud.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/tennis-tracker.git
   cd tennis-tracker
   ```

2. Set up the frontend:
   ```bash
   cd frontend
   npm install
   npm start
   ```

3. Set up the backend:
   ```bash
   cd ../backend
   go mod tidy
   go run main.go
   ```

4. Configure environment variables:
   - Add database credentials and JWT secrets to `.env` files in both `frontend/` and `backend/`.

5. Access the app:
   - Frontend: `http://localhost:3000`
   - Backend API: `http://localhost:8080`

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.
