# Supabase Setup for AI Chat Feature

This document explains what you need to do in Supabase to enable the AI chat history and delete functionality.

## 📋 Database Tables Required

You need to create two tables in your Supabase database:

### 1. `ai_chat_sessions` Table

This table stores chat sessions/conversations.

```sql
create table public.ai_chat_sessions (
  id text primary key,
  user_id uuid references auth.users (id) not null,
  title text not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Enable Row Level Security
alter table public.ai_chat_sessions enable row level security;

-- Create policies
create policy "Users can view own chat sessions" on public.ai_chat_sessions
  for select using (auth.uid() = user_id);

create policy "Users can insert own chat sessions" on public.ai_chat_sessions
  for insert with check (auth.uid() = user_id);

create policy "Users can update own chat sessions" on public.ai_chat_sessions
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Users can delete own chat sessions" on public.ai_chat_sessions
  for delete using (auth.uid() = user_id);
```

### 2. `ai_chat_messages` Table

This table stores individual messages within chat sessions.

```sql
create table public.ai_chat_messages (
  id text primary key,
  session_id text references public.ai_chat_sessions (id) on delete cascade,
  content text not null,
  is_user boolean not null default false,
  sources text,
  suggested_actions text[],
  created_at timestamptz default now()
);

-- Enable Row Level Security
alter table public.ai_chat_messages enable row level security;

-- Create policies
create policy "Users can view own chat messages" on public.ai_chat_messages
  for select using (
    exists (
      select 1 from public.ai_chat_sessions
      where ai_chat_sessions.id = ai_chat_messages.session_id
      and ai_chat_sessions.user_id = auth.uid()
    )
  );

create policy "Users can insert own chat messages" on public.ai_chat_messages
  for insert with check (
    exists (
      select 1 from public.ai_chat_sessions
      where ai_chat_sessions.id = ai_chat_messages.session_id
      and ai_chat_sessions.user_id = auth.uid()
    )
  );

create policy "Users can delete own chat messages" on public.ai_chat_messages
  for delete using (
    exists (
      select 1 from public.ai_chat_sessions
      where ai_chat_sessions.id = ai_chat_messages.session_id
      and ai_chat_sessions.user_id = auth.uid()
    )
  );
```

### 3. Indexes (Optional but Recommended)

For better query performance:

```sql
-- Index for faster session lookups by user
create index idx_ai_chat_sessions_user_id on public.ai_chat_sessions (user_id);

-- Index for faster message lookups by session
create index idx_ai_chat_messages_session_id on public.ai_chat_messages (session_id);

-- Index for ordering sessions by updated_at
create index idx_ai_chat_sessions_updated_at on public.ai_chat_sessions (updated_at desc);
```

## ✅ Verification Steps

After creating the tables:

1. **Test Row Level Security**: Try to access another user's chat sessions - it should be blocked
2. **Test Insert**: Create a new chat session and verify it appears in the table
3. **Test Delete**: Delete a chat session and verify all related messages are also deleted (cascade)
4. **Test Queries**: Verify that users can only see their own chat history

## 🔧 Features Enabled

Once these tables are set up, the following features will work:

- ✅ **Chat History**: Users can view all their previous chat sessions
- ✅ **Delete Chat**: Users can delete individual chat sessions
- ✅ **Auto-save**: All messages are automatically saved to the database
- ✅ **Session Management**: Each conversation is tracked as a separate session
- ✅ **Message Persistence**: Messages persist across app restarts

## 📝 Notes

- The `suggested_actions` field is stored as a text array in PostgreSQL
- The `sources` field is optional and can be null
- When a session is deleted, all related messages are automatically deleted (CASCADE)
- The `updated_at` field in sessions is automatically updated when new messages are added

## 🚀 Next Steps

1. Run the SQL scripts above in your Supabase SQL Editor
2. Verify the tables are created correctly
3. Test the RLS policies
4. The app will automatically start using these tables once they exist

