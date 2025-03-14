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
