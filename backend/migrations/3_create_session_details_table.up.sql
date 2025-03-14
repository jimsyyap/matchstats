CREATE TABLE session_details (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    set_number INTEGER NOT NULL, -- Set number (e.g., 1, 2, 3)
    points_won INTEGER DEFAULT 0,
    unforced_errors INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_session_details_session_id ON session_details(session_id);
