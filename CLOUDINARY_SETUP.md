# Cloudinary Integration Guide for Reels

This guide explains how to integrate Cloudinary in your DejureBook project to display 20 videos randomly in the reels page.

## 📋 Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Cloudinary Setup](#cloudinary-setup)
4. [Project Configuration](#project-configuration)
5. [Uploading Videos](#uploading-videos)
6. [Implementation Details](#implementation-details)
7. [Testing](#testing)

---

## 🎯 Overview

Your project now includes:
- **CloudinaryService** (`lib/services/cloudinary_service.dart`) - Dynamically fetches video URLs from Cloudinary Admin API (by folder prefix `reels`) and shuffles them
- **Updated ConsumerBloc** - Fetches videos from Cloudinary and displays them in random order
- **Video Player Integration** - Ready for video playback (requires additional widget updates)

---

## ✅ Prerequisites

1. **Cloudinary Account**: Sign up at [cloudinary.com](https://cloudinary.com) (free tier available)
2. **Flutter Environment**: Ensure Flutter SDK is installed
3. **Project Dependencies**: Run `flutter pub get` after updating `pubspec.yaml`

---

## 🔧 Cloudinary Setup

### Step 1: Create Cloudinary Account

1. Go to [https://cloudinary.com/users/register](https://cloudinary.com/users/register)
2. Sign up for a free account
3. Verify your email address

### Step 2: Get Your Cloudinary Credentials

1. Log in to your Cloudinary dashboard
2. Go to **Dashboard** → You'll see your credentials:
   - **Cloud Name** (e.g., `dxyz123abc`)
   - **API Key** (e.g., `123456789012345`)
   - **API Secret** (e.g., `abcdefghijklmnopqrstuvwxyz123456`)

### Step 3: Configure Environment Variables

1. Open your `.env` file in the project root
2. Add the following Cloudinary credentials:

```env
# Cloudinary Configuration
CLOUDINARY_CLOUD_NAME=your_cloud_name_here
CLOUDINARY_API_KEY=your_api_key_here
CLOUDINARY_API_SECRET=your_api_secret_here
```

**⚠️ Important**: 
- Never commit your `.env` file to version control
- Add `.env` to your `.gitignore` file
- The `.env` file should already be in your assets list in `pubspec.yaml`

---

## 📤 Uploading Videos to Cloudinary

### Method 1: Using Cloudinary Dashboard (Recommended for 20 videos)

1. **Log in to Cloudinary Dashboard**
2. **Navigate to Media Library**
3. **Create a Folder** (optional but recommended):
   - Click "New Folder"
   - Name it `reels`
   - Click "Create Folder"
4. **Upload Videos**:
   - Click "Upload" button
   - Select "Unsigned" or "Signed" upload
   - Select your 20 video files
   - **Important**: Make sure to upload to the `reels` folder if you created one
   - Wait for uploads to complete

### Method 2: Using Cloudinary API

You can use the Cloudinary Management API or upload widget. For bulk uploads, consider using:

```bash
# Example using cURL (replace with your credentials)
curl -X POST \
  https://api.cloudinary.com/v1_1/YOUR_CLOUD_NAME/video/upload \
  -F "file=@/path/to/your/video.mp4" \
  -F "folder=reels" \
  -F "public_id=video1" \
  -F "api_key=YOUR_API_KEY" \
  -F "api_secret=YOUR_API_SECRET"
```

### Method 3: Using Cloudinary Upload Widget (For Future Admin Features)

Consider implementing an admin upload feature in your app using the Cloudinary upload widget.

---

## 🔄 Project Configuration

### Step 1: Dynamic fetching by folder (no manual IDs needed)

`CloudinaryService.getReelsVideoUrls()` now calls the Admin API:

```
GET https://api.cloudinary.com/v1_1/{cloud_name}/resources/video?type=upload&prefix=reels&max_results=30
```

- Uses Basic Auth with `CLOUDINARY_API_KEY` and `CLOUDINARY_API_SECRET`
- Collects all video `secure_url`s under the `reels` folder
- Supports pagination via `next_cursor`
- Shuffles results before returning

If you later rename the folder, update `_videoFolder` in `lib/services/cloudinary_service.dart`.

### Step 2: Ensure `.env` is set

The service reads `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`. Double-check values.

---

## 🎬 Implementation Details

### How Random Shuffling Works

The `CloudinaryService.getReelsVideoUrls()` method:
1. Fetches all 20 video URLs from Cloudinary
2. **Automatically shuffles them randomly** using `Random().shuffle()`
3. Returns the shuffled list

Each time `LoadReelsDataEvent` is triggered:
- Videos are fetched from Cloudinary
- They are shuffled in a new random order
- This ensures users see different video orders on each visit

### Video URL Format

Cloudinary generates URLs in this format:
```
https://res.cloudinary.com/{cloud_name}/video/upload/{public_id}.mp4
```

With transformations (optimized):
```
https://res.cloudinary.com/{cloud_name}/video/upload/q_auto,f_auto/{public_id}.mp4
```

### Current Implementation

- ✅ **Random Order**: Videos are shuffled randomly
- ✅ **20 Videos**: Supports exactly 20 videos
- ✅ **Error Handling**: Graceful error handling if videos fail to load
- ✅ **BLoC Integration**: Fully integrated with your existing BLoC pattern

### Future Enhancements (Optional)

1. **Dynamic Fetching**: Already enabled using the Admin API by prefix `reels`
2. **Video Transformations**: Add quality, format, and size optimizations
3. **Caching**: Implement caching for better performance
4. **Pagination**: Support loading more videos as user scrolls

---

## 🎥 Video Player Integration (Next Steps)

To enable actual video playback (currently using placeholder images), you'll need to:

1. **Update `reels_page.dart`** to use `video_player` package
2. **Add video playback controls**
3. **Handle video loading states**
4. **Implement auto-play on scroll**

Here's a basic example widget you can use:

```dart
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  
  const VideoPlayerWidget({required this.videoUrl});
  
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    
    await _videoPlayerController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      showControls: false,
    );
    
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    
    return Chewie(controller: _chewieController!);
  }
}
```

---

## 🧪 Testing

### Step 1: Install Dependencies

```bash
flutter pub get
```

### Step 2: Verify Environment Variables

Check that your `.env` file has all required Cloudinary credentials:
- `CLOUDINARY_CLOUD_NAME`
- `CLOUDINARY_API_KEY`
- `CLOUDINARY_API_SECRET`

### Step 3: Test Video URLs

You can test if your Cloudinary URLs are correct by:
1. Opening `lib/services/cloudinary_service.dart`
2. Temporarily adding a print statement:
```dart
print('Video URLs: $videoUrls');
```
3. Running the app and checking the console output

### Step 4: Run the App

```bash
flutter run
```

Navigate to the Reels page and verify:
- ✅ Videos load correctly
- ✅ Videos appear in random order
- ✅ All 20 videos are accessible
- ✅ Error handling works if videos are missing

---

## 🔍 Troubleshooting

### Videos Not Loading

1. **Check Public IDs**: Ensure public IDs in `CloudinaryService` match your Cloudinary uploads
2. **Check Folder**: If using folders, ensure public IDs include folder path (e.g., `reels/video1`)
3. **Check Permissions**: Ensure videos are set to "Public" in Cloudinary
4. **Check Network**: Verify internet connection
5. **Check Console**: Look for error messages in debug console

### Environment Variables Not Loading

1. Ensure `.env` file is in project root
2. Check that `.env` is listed in `pubspec.yaml` assets
3. Verify `flutter_dotenv` is loaded in `main.dart`
4. Restart the app after changing `.env`

### Videos Not Shuffling

- The shuffle happens automatically when `LoadReelsDataEvent` is triggered
- Each time the reels page loads, videos are in a new random order
- If you want persistent shuffling, consider saving the shuffled order to state

---

## 📚 Additional Resources

- [Cloudinary Documentation](https://cloudinary.com/documentation)
- [Cloudinary Video Transformations](https://cloudinary.com/documentation/video_transformation_reference)
- [Flutter video_player Package](https://pub.dev/packages/video_player)
- [Chewie Video Player](https://pub.dev/packages/chewie)

---

## ✨ Summary

Your reels page now:
1. ✅ Fetches 20 videos from Cloudinary
2. ✅ Displays them in random order
3. ✅ Integrates with your existing BLoC architecture
4. ✅ Handles errors gracefully
5. ✅ Ready for video player integration

**Next Steps**:
1. Upload 20 videos to Cloudinary
2. Update public IDs in `CloudinaryService`
3. Add Cloudinary credentials to `.env`
4. (Optional) Implement video player widget for actual playback
5. Test and enjoy! 🎉

