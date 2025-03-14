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
