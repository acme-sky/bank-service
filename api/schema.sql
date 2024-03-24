CREATE TABLE dream_session (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  expires_at REAL NOT NULL,
  payload TEXT NOT NULL
);

CREATE TABLE payment (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  owner TEXT NOT NULL,
  amount FLOAT NOT NULL,
  description VARCHAR NOT NULL,
  paid BOOLEAN DEFAULT false NOT NULL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

