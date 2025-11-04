# Cloudinary Reels Integration - Quick Start Guide

## 🚀 Quick Setup (5 Steps)

### 1. Get Cloudinary Credentials
- Sign up at [cloudinary.com](https://cloudinary.com)
- Get your **Cloud Name**, **API Key**, and **API Secret** from dashboard

### 2. Add to `.env` File
```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

### 3. Upload 20 Videos to Cloudinary
- Go to Cloudinary Dashboard → Media Library
- Create folder: `reels` (optional)
- Upload 20 videos
- Note the **Public ID** of each video

### 4. No manual IDs needed (dynamic fetch)
The app now dynamically fetches all videos from your `reels` folder via Cloudinary's Admin API. If you change the folder name, update `_videoFolder` in `lib/services/cloudinary_service.dart`.

### 5. Install Dependencies & Run
```bash
flutter pub get
flutter run
```

## ✅ That's It!

Your reels page will now:
- ✅ Fetch 20 videos from Cloudinary
- ✅ Display them in **random order** (shuffled each time)
- ✅ Work with your existing BLoC architecture

## 📝 Notes

- Videos are shuffled randomly each time `LoadReelsDataEvent` is triggered
- All 20 videos will be displayed
- Error handling is built-in
- See `CLOUDINARY_SETUP.md` for detailed documentation

