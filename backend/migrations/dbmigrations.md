To use `go-migrate` for managing your PostgreSQL migrations, you need to create migration scripts in the format required by `go-migrate`. Each migration consists of two files: one for the "up" migration (applying changes) and one for the "down" migration (reverting changes). These files are named with a version number and a description, such as `1_create_users_table.up.sql` and `1_create_users_table.down.sql`.

Below are the migration scripts for your database schema. Save these files in the appropriate directory (e.g., `migrations/`) and run them using `go-migrate`.

---

### **Migration Scripts**

#### **1. Create Users Table**
File: `1_create_users_table.up.sql`
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'player' CHECK (role IN ('player', 'admin')), -- Add roles for access control
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE, -- Track last login time for analytics/security
    is_active BOOLEAN DEFAULT TRUE -- Soft deletion flag for user accounts
);

CREATE INDEX idx_users_email ON users(email);
```

File: `1_create_users_table.down.sql`
```sql
DROP TABLE IF EXISTS users CASCADE;
DROP INDEX IF EXISTS idx_users_email;
```

---

#### **2. Create Sessions Table**
File: `2_create_sessions_table.up.sql`
```sql
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    match_type VARCHAR(50) NOT NULL CHECK (match_type IN ('singles', 'doubles')), -- Specify match type
    name VARCHAR(255) NOT NULL,
    opponent_name VARCHAR(255), -- Optional for practice sessions
    session_date TIMESTAMP WITH TIME ZONE NOT NULL,
    total_points_won INTEGER DEFAULT 0, -- Track points won directly in the session
    total_unforced_errors INTEGER DEFAULT 0, -- Track errors directly in the session
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_user_id_match_type ON sessions(user_id, match_type);
```

File: `2_create_sessions_table.down.sql`
```sql
DROP TABLE IF EXISTS sessions CASCADE;
DROP INDEX IF EXISTS idx_sessions_user_id;
DROP INDEX IF EXISTS idx_sessions_user_id_match_type;
```

---

#### **3. Create Session Details Table**
File: `3_create_session_details_table.up.sql`
```sql
CREATE TABLE session_details (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    set_number INTEGER NOT NULL, -- Set number (e.g., 1, 2, 3)
    points_won INTEGER DEFAULT 0,
    unforced_errors INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_session_details_session_id ON session_details(session_id);
```

File: `3_create_session_details_table.down.sql`
```sql
DROP TABLE IF EXISTS session_details CASCADE;
DROP INDEX IF EXISTS idx_session_details_session_id;
```

---

#### **4. Create Shared Links Table**
File: `4_create_shared_links_table.up.sql`
```sql
CREATE TABLE shared_links (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    purpose VARCHAR(50) NOT NULL CHECK (purpose IN ('stats_sharing', 'collaboration')), -- Purpose of the link
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_shared_links_token ON shared_links(token);
CREATE INDEX idx_shared_links_user_id ON shared_links(user_id);
CREATE INDEX idx_shared_links_session_id ON shared_links(session_id);
```

File: `4_create_shared_links_table.down.sql`
```sql
DROP TABLE IF EXISTS shared_links CASCADE;
DROP INDEX IF EXISTS idx_shared_links_token;
DROP INDEX IF EXISTS idx_shared_links_user_id;
DROP INDEX IF EXISTS idx_shared_links_session_id;
```

---

#### **5. Create Metrics Table (Optional)**
File: `5_create_metrics_table.up.sql`
```sql
CREATE TABLE metrics (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    metric_name VARCHAR(50) NOT NULL, -- e.g., "aces", "double_faults"
    value INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_metrics_session_id ON metrics(session_id);
```

File: `5_create_metrics_table.down.sql`
```sql
DROP TABLE IF EXISTS metrics CASCADE;
DROP INDEX IF EXISTS idx_metrics_session_id;
```

---

### **Running Migrations**

1. **Install `go-migrate`:**
   Ensure `go-migrate` is installed on your system. You can install it using:
   ```bash
   go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
   ```

2. **Set Up the Migration Directory:**
   Place all `.sql` files in a directory named `migrations/`.

3. **Run Migrations:**
   Use the following command to apply migrations:
   ```bash
   migrate -path ./migrations -database "postgres://username:password@localhost:5432/your_database_name?sslmode=disable" up
   ```
   Replace `username`, `password`, and `your_database_name` with your PostgreSQL credentials.

4. **Roll Back Migrations:**
   To roll back the last migration, use:
   ```bash
   migrate -path ./migrations -database "postgres://username:password@localhost:5432/your_database_name?sslmode=disable" down
   ```

---

### **Notes**

- **Versioning:** The numeric prefix (`1_`, `2_`, etc.) ensures migrations are applied in the correct order.
- **Idempotency:** Ensure each migration script is idempotent (can be safely rerun without causing errors).
- **Testing:** Test migrations in a development environment before applying them to production.

