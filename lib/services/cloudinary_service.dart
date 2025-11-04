import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
// Using direct URL construction to avoid SDK API differences

/// Client-safe Cloudinary service for URL generation and uploads
class CloudinaryService {
  /// Build optimized image URL via direct URL construction
  static String imageUrl({
    required String publicId,
    int? width,
    int? height,
  }) {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    if (cloudName.isEmpty) return '';
    final transformations = <String, String>{
      'f': 'auto',
      'q': 'auto',
      if (width != null) 'w': width.toString(),
      if (height != null) 'h': height.toString(),
      if (width != null || height != null) 'c': 'fill',
    };
    final transString =
        transformations.entries.map((e) => '${e.key}_${e.value}').join(',');
    return 'https://res.cloudinary.com/$cloudName/image/upload/$transString/$publicId';
  }

  /// Build optimized video URL
  static String videoUrl({required String publicId}) {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    if (cloudName.isEmpty) return '';

    final transformations = <String, String>{
      'f': 'auto',
      'q': 'auto',
    };
    final transString =
        transformations.entries.map((e) => '${e.key}_${e.value}').join(',');

    // Add .mp4 extension if not already included
    final formattedId = publicId.endsWith('.mp4') ? publicId : '$publicId.mp4';

    return 'https://res.cloudinary.com/$cloudName/video/upload/$transString/$formattedId';
  }

  /// Unsigned upload (requires an unsigned upload preset in Cloudinary)
  static Future<Map<String, dynamic>> uploadUnsigned({
    required String filePath,
    required String uploadPreset,
    Map<String, String>? extra,
  }) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    if (cloudName == null || cloudName.isEmpty) {
      throw Exception('CLOUDINARY_CLOUD_NAME is not set');
    }

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');
    final req = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..fields.addAll(extra ?? {})
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final res = await req.send();
    final body = await res.stream.bytesToString();
    if (res.statusCode != 200) {
      throw Exception('Upload failed: ${res.statusCode} $body');
    }
    return jsonDecode(body) as Map<String, dynamic>;
  }

  /// Signed upload via backend-generated signature
  /// [signatureEndpoint] must return { api_key, timestamp, signature }
  static Future<Map<String, dynamic>> uploadSigned({
    required String filePath,
    required Uri signatureEndpoint,
    Map<String, String>? paramsNeedingSignature,
  }) async {
    final sigRes = await http.post(
      signatureEndpoint,
      body: paramsNeedingSignature,
    );
    if (sigRes.statusCode != 200) {
      throw Exception(
          'Signature endpoint error: ${sigRes.statusCode} ${sigRes.body}');
    }
    final sigJson = jsonDecode(sigRes.body) as Map<String, dynamic>;

    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    if (cloudName == null || cloudName.isEmpty) {
      throw Exception('CLOUDINARY_CLOUD_NAME is not set');
    }

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');
    final req = http.MultipartRequest('POST', uri)
      ..fields['api_key'] = sigJson['api_key']
      ..fields['timestamp'] = sigJson['timestamp'].toString()
      ..fields['signature'] = sigJson['signature']
      ..fields.addAll(paramsNeedingSignature ?? {})
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final res = await req.send();
    final body = await res.stream.bytesToString();
    if (res.statusCode != 200) {
      throw Exception('Upload failed: ${res.statusCode} $body');
    }
    return jsonDecode(body) as Map<String, dynamic>;
  }

  /// Fetch reels video URLs using Admin API (gets actual secure URLs with versions)
  /// Fetches all videos from the 'reels' folder
  static Future<List<String>> getReelsVideoUrls() async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    final apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
    final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

    if (cloudName.isEmpty || apiKey.isEmpty || apiSecret.isEmpty) {
      // Fallback to env-based method if Admin API credentials not available
      final ids = dotenv.env['CLOUDINARY_REELS_PUBLIC_IDS'] ?? '';
      if (ids.trim().isEmpty) return [];
      final publicIds = ids
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final urls = publicIds.map((id) => videoUrl(publicId: id)).toList();
      urls.shuffle(Random());
      return urls;
    }

    try {
      // Use Admin API to fetch actual secure URLs with version numbers
      // Try fetching from 'reels' folder first, then try root if empty
      List<String> urls = [];

      // First try: fetch from 'reels' folder
      var uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/resources/video?type=upload&prefix=reels&max_results=30');

      final credentials = base64Encode(utf8.encode('$apiKey:$apiSecret'));
      var response = await http.get(
        uri,
        headers: {'Authorization': 'Basic $credentials'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final resources = jsonData['resources'] as List<dynamic>?;

        if (resources != null && resources.isNotEmpty) {
          // Extract secure_url from each resource (includes version numbers)
          urls = resources
              .map((resource) {
                final resourceMap = resource as Map<String, dynamic>;
                return resourceMap['secure_url'] as String?;
              })
              .where((url) => url != null && url.isNotEmpty)
              .cast<String>()
              .toList();
        }
      }

      // If no videos found in 'reels' folder, try fetching all videos (root level)
      if (urls.isEmpty) {
        uri = Uri.parse(
            'https://api.cloudinary.com/v1_1/$cloudName/resources/video?type=upload&max_results=30');

        response = await http.get(
          uri,
          headers: {'Authorization': 'Basic $credentials'},
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
          final resources = jsonData['resources'] as List<dynamic>?;

          if (resources != null && resources.isNotEmpty) {
            // Extract secure_url from each resource (includes version numbers)
            urls = resources
                .map((resource) {
                  final resourceMap = resource as Map<String, dynamic>;
                  return resourceMap['secure_url'] as String?;
                })
                .where((url) => url != null && url.isNotEmpty)
                .cast<String>()
                .toList();
          }
        } else {
          throw Exception(
              'Admin API request failed: ${response.statusCode} ${response.body}');
        }
      }

      if (urls.isEmpty) {
        return [];
      }

      urls.shuffle(Random());
      return urls;
    } catch (e) {
      // Fallback to env-based method on error
      final ids = dotenv.env['CLOUDINARY_REELS_PUBLIC_IDS'] ?? '';
      if (ids.trim().isEmpty) return [];
      final publicIds = ids
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final urls = publicIds.map((id) => videoUrl(publicId: id)).toList();
      urls.shuffle(Random());
      return urls;
    }
  }

  /// Checks minimal configuration (no secrets on client)
  static bool isConfigured() {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    return cloudName.isNotEmpty;
  }
}
