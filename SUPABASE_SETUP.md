# DeJureBook - Supabase Authentication Setup

## Setup Instructions

### 1. Configure Supabase Credentials

Update the Supabase configuration in `lib/services/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
  // ... rest of the code
}
```

Replace `YOUR_SUPABASE_URL_HERE` and `YOUR_SUPABASE_ANON_KEY_HERE` with your actual Supabase project URL and anonymous key.

### 2. Install Dependencies

Run the following command to install the new dependencies:

```bash
flutter pub get
```

### 3. Supabase Project Configuration

In your Supabase project dashboard:

1. **Enable Email Authentication**: Go to Authentication > Settings and enable email authentication
2. **Configure Google OAuth** (optional): 
   - Go to Authentication > Providers
   - Enable Google provider
   - Add your Google OAuth credentials
3. **Set up Email Templates**: Configure email templates for signup confirmation and password reset

### 4. Database Schema (Optional)

If you want to store additional user profile data, create a `profiles` table:

```sql
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  name TEXT,
  location TEXT,
  profession TEXT,
  user_type TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);
```

## Features Implemented

### Authentication Features
- ✅ Email/Password Sign Up
- ✅ Email/Password Sign In
- ✅ Google OAuth Sign In
- ✅ Sign Out
- ✅ Password Reset
- ✅ Authentication State Management
- ✅ Protected Routes

### User Profile Features
- ✅ Complete Profile Collection During Signup
- ✅ User Profile Database Storage
- ✅ Real-time Profile Data Display
- ✅ Profile Management Service
- ✅ User Type Selection (Consumer, Lawyer, Law Student)

### UI Components
- ✅ Sign Up Screen with Email/Password Dialog
- ✅ Complete Profile Screen with Form Validation
- ✅ Google Sign In Button
- ✅ Settings Screen with Logout
- ✅ Profile Page with Real User Data
- ✅ My Account Screen with User Information
- ✅ Authentication State Handling

### Architecture
- ✅ Clean Architecture with BLoC Pattern
- ✅ Supabase Service Layer
- ✅ Authentication BLoC
- ✅ Error Handling
- ✅ Loading States

## Usage

The authentication system is now integrated throughout the app:

1. **Sign Up Screen**: Users can sign up with email/password or Google
2. **Complete Profile**: New users fill out detailed profile information
3. **User Selection**: After authentication, users select their type
4. **Profile Page**: Shows authenticated user data from database
5. **My Account**: Displays real user profile information
6. **Settings**: Users can logout from here

## Security Notes

- All authentication is handled securely through Supabase
- User sessions are managed automatically
- Row Level Security (RLS) should be enabled on any user-specific tables
- Never expose service role keys in client-side code

## Next Steps

1. Replace placeholder Supabase credentials with your actual project credentials
2. Configure your Supabase project settings as described above
3. Test the authentication flow
4. Add any additional user profile fields as needed
