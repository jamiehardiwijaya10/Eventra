import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class ProductCopyData {
  final String name;
  final String category;
  final String description;
  final num price;
  final int availableStock;
  final String image;
  final bool isAvailable;

  ProductCopyData({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.availableStock,
    required this.image,
    required this.isAvailable,
  });
}

class BoothService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>> createBooth({
    required String eventId,
    required String name,
    required String description,
    required String category,
    required String businessType,
    required String ownerName,
    required String phone,
    required String email,
    required String instagram,
    String? logo,
    String? banner,
    String? boothPhoto,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final data = <String, dynamic>{
      'event_id': eventId,
      'owner_id': user.id,
      'name': name,
      'description': description,
      'category': category,
      'business_type': businessType,
      'owner_name': ownerName,
      'phone': phone,
      'email': email,
      'instagram': instagram,
      'status': 'pending',
    };

    if (logo != null && logo.isNotEmpty) {
      data['logo'] = logo;
    }

    if (banner != null && banner.isNotEmpty) {
      data['banner'] = banner;
    }

    if (boothPhoto != null && boothPhoto.isNotEmpty) {
      data['booth_photo'] = boothPhoto;
    }

    final response = await _client
        .from('booths')
        .insert(data)
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<List<Map<String, dynamic>>> getMyProducts() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('products')
        .select('''
          id,
          booth_id,
          owner_id,
          name,
          description,
          price,
          available_stock,
          image,
          is_available,
          category
        ''')
        .eq('owner_id', user.id)
        .isFilter('booth_id', null)
        .eq('is_available', true)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> copyProductsToBooth({
    required String boothId,
    required List<ProductCopyData> products,
  }) async {
    if (products.isEmpty) return;

    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final payload = products.map((product) {
    return {
      'booth_id': boothId,
      'owner_id': user.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'available_stock': product.availableStock,
      'image': product.image,
      'is_available': product.isAvailable,
      'category': product.category,
    };
  }).toList();

    await _client.from('products').insert(payload);
  }

  Future<List<Map<String, dynamic>>> getMyBooths() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
      .from('booths')
      .select('''
        id,
        event_id,
        owner_id,
        name,
        description,
        category,
        business_type,
        owner_name,
        phone,
        email,
        instagram,
        status,
        queue_status,
        stock_status,
        opening_hours,
        closing_hours,
        logo,
        banner,
        booth_photo,
        latitude,
        longitude,
        created_at,
        events (
          id,
          title,
          start_date,
          end_date,
          location,
          venue_name
        )
      ''')
      .eq('owner_id', user.id)
      .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<int> getBoothProductCount(String boothId) async {
    final response = await _client
        .from('products')
        .select('id')
        .eq('booth_id', boothId);

    return response.length;
  }

  Future<List<Map<String, dynamic>>> getBoothProducts(String boothId) async {
    final response = await _client
        .from('products')
        .select('''
          id,
          booth_id,
          owner_id,
          name,
          category,
          description,
          price,
          available_stock,
          image,
          is_available,
          stock_status,
          created_at
        ''')
        .eq('booth_id', boothId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateProduct({
    required String productId,
    required String name,
    required String category,
    required String description,
    required num price,
    required int availableStock,
    required bool isAvailable,
    String? image,
  }) async {
    final data = {
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'available_stock': availableStock,
      'is_available': isAvailable,
    };

    if (image != null && image.isNotEmpty) {
      data['image'] = image;
    }

    await _client.from('products').update(data).eq('id', productId);
  }

  Future<void> deleteProduct({
    required String productId,
    String? imageUrl,
  }) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final uri = Uri.tryParse(imageUrl);

      if (uri != null) {
        final pathIndex = uri.path.indexOf('/product_images/');

        if (pathIndex != -1) {
          final filePath = uri.path.substring(
            pathIndex + '/product_images/'.length,
          );

          await _client.storage.from('product_images').remove([filePath]);
        }
      }
    }

    await _client.from('products').delete().eq('id', productId);
  }

  Future<void> updateBooth({
    required String boothId,
    required String name,
    required String description,
    required String category,
    required String businessType,
    required String ownerName,
    required String phone,
    required String email,
    required String instagram,
    String? logo,
    String? banner,
    String? boothPhoto,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'description': description,
      'category': category,
      'business_type': businessType,
      'owner_name': ownerName,
      'phone': phone,
      'email': email,
      'instagram': instagram,
    };

    if (logo != null) {
      data['logo'] = logo;
    }

    if (banner != null) {
      data['banner'] = banner;
    }

    if (boothPhoto != null) {
      data['booth_photo'] = boothPhoto;
    }

    await _client
        .from('booths')
        .update(data)
        .eq('id', boothId);
  }


  Future<String> uploadBoothImage({
    required String type,
    required Uint8List image,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final fileName =
        '${user.id}/${type}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage
        .from('booth_images')
        .uploadBinary(
          fileName,
          image,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );

    return _client.storage.from('booth_images').getPublicUrl(fileName);
  }

  Future<Map<String, dynamic>> createProduct({
    required String boothId,
    required String name,
    required String category,
    required String description,
    required num price,
    required int availableStock,
    required bool isAvailable,
    String? image,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final data = <String, dynamic>{
      'booth_id': boothId,
      'owner_id': user.id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'available_stock': availableStock,
      'is_available': isAvailable,
    };

    if (image != null && image.isNotEmpty) {
      data['image'] = image;
    }

    final response = await _client
        .from('products')
        .insert(data)
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<List<Map<String, dynamic>>> getCustomerBooths() async {
    final response = await _client
        .from('booths')
        .select('''
          id,
          event_id,
          owner_id,
          name,
          description,
          category,
          business_type,
          owner_name,
          status,
          queue_status,
          stock_status,
          opening_hours,
          closing_hours,
          logo,
          banner,
          booth_photo,
          latitude,
          longitude,
          created_at,
          events (
            id,
            title,
            start_date,
            end_date,
            location,
            venue_name
          )
        ''')
        .eq('status', 'approved')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
