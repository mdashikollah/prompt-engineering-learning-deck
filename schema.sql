CREATE TABLE IF NOT EXISTS quiz_sessions (
  session_id TEXT PRIMARY KEY,
  started_at TEXT NOT NULL,
  used INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS certificates (
  certificate_number TEXT PRIMARY KEY CHECK (length(certificate_number) = 3),
  participant_name TEXT NOT NULL,
  score INTEGER NOT NULL,
  total INTEGER NOT NULL,
  percentage INTEGER NOT NULL,
  completed_at TEXT NOT NULL,
  total_time_seconds INTEGER NOT NULL,
  session_id TEXT NOT NULL UNIQUE,
  FOREIGN KEY (session_id) REFERENCES quiz_sessions(session_id)
);

CREATE INDEX IF NOT EXISTS idx_certificates_completed_at ON certificates(completed_at);