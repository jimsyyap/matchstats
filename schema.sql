-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS shared_links CASCADE;
DROP TABLE IF EXISTS session_details CASCADE;
DROP TABLE IF EXISTS sessions CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Create users table
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

-- Create sessions table
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

-- Create session_details table
CREATE TABLE session_details (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    set_number INTEGER NOT NULL, -- Set number (e.g., 1, 2, 3)
    points_won INTEGER DEFAULT 0,
    unforced_errors INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create shared_links table
CREATE TABLE shared_links (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    purpose VARCHAR(50) NOT NULL CHECK (purpose IN ('stats_sharing', 'collaboration')), -- Purpose of the link
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create metrics table (optional, for future enhancements)
CREATE TABLE metrics (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    metric_name VARCHAR(50) NOT NULL, -- e.g., "aces", "double_faults"
    value INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_shared_links_token ON shared_links(token);
CREATE INDEX idx_shared_links_user_id ON shared_links(user_id);
CREATE INDEX idx_session_details_session_id ON session_details(session_id);
CREATE INDEX idx_sessions_user_id_match_type ON sessions(user_id, match_type);

-- Insert sample users
INSERT INTO users (email, password_hash, name, role) VALUES 
('player1@example.com', '$2a$10$GckdTPS05LnUmMSxH4g4peVKqEoR8h1WUSLfFrS0WkpLcKTVQSfQq', 'Player One', 'player'),
('coach1@example.com', '$2a$10$GckdTPS05LnUmMSxH4g4peVKqEoR8h1WUSLfFrS0WkpLcKTVQSfQq', 'Coach One', 'admin');

-- Insert sample sessions
INSERT INTO sessions (user_id, match_type, name, opponent_name, session_date, total_points_won, total_unforced_errors) VALUES 
(1, 'singles', 'Practice Session 1', 'Practice Partner', NOW() - INTERVAL '7 DAYS', 45, 12),
(1, 'doubles', 'Tournament Match 1', 'John Doe', NOW() - INTERVAL '3 DAYS', 60, 8);

-- Insert sample session details
INSERT INTO session_details (session_id, set_number, points_won, unforced_errors) VALUES 
(1, 1, 15, 4),
(1, 2, 15, 5),
(1, 3, 15, 3),
(2, 1, 20, 3),
(2, 2, 20, 3),
(2, 3, 20, 2);

-- Insert sample shared link
INSERT INTO shared_links (user_id, session_id, token, purpose, expires_at) VALUES 
(1, 1, 'a1b2c3d4e5f6', 'stats_sharing', NOW() + INTERVAL '7 DAYS');
