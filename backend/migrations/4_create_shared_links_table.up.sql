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
