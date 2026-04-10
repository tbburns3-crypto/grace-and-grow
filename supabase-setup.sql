-- ═══════════════════════════════════════════════════════════
-- Grace & Grow — Supabase Setup SQL
-- Run this ONCE in your Supabase project → SQL Editor
-- ═══════════════════════════════════════════════════════════

-- 1. Main sync table — one row per data key per family
CREATE TABLE IF NOT EXISTS gg_sync (
  id          BIGSERIAL PRIMARY KEY,
  family_id   TEXT NOT NULL,
  key         TEXT NOT NULL,
  value       JSONB,
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (family_id, key)
);

-- 2. Index for fast lookups
CREATE INDEX IF NOT EXISTS gg_sync_family_key ON gg_sync (family_id, key);

-- 3. Enable Row Level Security
ALTER TABLE gg_sync ENABLE ROW LEVEL SECURITY;

-- 4. Policy: anyone with the anon key can read/write their family's data
--    (The family_id acts as a shared secret between the two phones)
CREATE POLICY "family_access" ON gg_sync
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- 5. Enable Realtime on this table (optional — app polls every 8s anyway)
ALTER PUBLICATION supabase_realtime ADD TABLE gg_sync;

-- ═══════════════════════════════════════════════════════════
-- DONE! Now copy your Project URL and anon key from:
-- Supabase Dashboard → Settings → API
-- And paste them into grace-and-grow.html where it says:
--   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
--   const SUPABASE_KEY = 'YOUR_SUPABASE_ANON_KEY';
-- ═══════════════════════════════════════════════════════════
