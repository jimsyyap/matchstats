CREATE TABLE metrics (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    metric_name VARCHAR(50) NOT NULL, -- e.g., "aces", "double_faults"
    value INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_metrics_session_id ON metrics(session_id);
