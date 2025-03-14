### **Project Structure**

```
tennis-tracker/
├── README.md
├── frontend/
│   ├── public/
│   │   ├── index.html
│   │   └── favicon.ico
│   ├── src/
│   │   ├── components/
│   │   │   ├── Auth/
│   │   │   │   ├── Login.jsx
│   │   │   │   └── Register.jsx
│   │   │   ├── Match/
│   │   │   │   ├── CreateMatch.jsx
│   │   │   │   └── TrackStats.jsx
│   │   │   ├── Analytics/
│   │   │   │   └── PerformanceCharts.jsx
│   │   │   └── Shared/
│   │   │       └── Navbar.jsx
│   │   ├── App.js
│   │   ├── index.js
│   │   └── styles/
│   │       ├── global.css
│   │       └── themes.css
│   ├── package.json
│   ├── .env
│   └── .gitignore
├── backend/
│   ├── main.go
│   ├── handlers/
│   │   ├── auth.go
│   │   ├── match.go
│   │   └── analytics.go
│   ├── models/
│   │   ├── user.go
│   │   └── match.go
│   ├── database/
│   │   ├── db.go
│   │   └── migrations/
│   │       └── 001_create_users_table.sql
│   ├── .env
│   └── .gitignore
└── docker-compose.yml (optional, for containerization)
```

