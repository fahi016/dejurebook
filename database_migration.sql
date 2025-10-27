-- Add profession and phone_number columns to profiles table
-- Run this in your Supabase SQL Editor

-- Add the columns
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS profession TEXT;

ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS phone_number TEXT;

-- Update RLS policies to allow users to read their own profiles
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
CREATE POLICY "Users can view their own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- Update the insert policy to include new columns
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Update policy to allow users to update their own profiles
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update their own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- The profession and phone_number columns are now added to your profiles table
-- RLS policies have been updated to allow users to read and write their own profiles
