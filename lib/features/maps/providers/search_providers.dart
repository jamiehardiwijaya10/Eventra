import 'package:dio/dio.dart';
import 'package:eventra/core/constant/map_constants.dart';
import 'package:eventra/features/maps/search/models/place_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final dioProvider = Provider<Dio>((ref){
  return Dio(
    BaseOptions(
      baseUrl: AppConstants.nominatimBaseUrl,
      headers: {'User-Agent' : 'OsmFlutterApp/1.0'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchSuggestionsProvider = FutureProvider.autoDispose<List<PlaceModel>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider);

  debugPrint('PROVIDER QUERY: "$query"');

  if (query.trim().length < 3) {
    debugPrint('QUERY TOO SHORT');
    
    return [];
  }
  
  final dio = ref.watch(dioProvider);

  try {
    debugPrint('CALLING NOMINATIM...');

    final response = await dio.get(
      '/search',
      queryParameters: {
        'q': query.trim(),
        'format': 'jsonv2',
        'limit': 5,
        'addressdetails': 1,
      },
    );
    
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('DATA: ${response.data}');

    final List data = response.data as List;

    return data
      .map((e) => PlaceModel.fromJson(e as Map<String, dynamic>))
      .toList();
  } on DioException catch (e){
    debugPrint('DIO ERROR: ${e.message}');
    debugPrint('DIO TYPE: ${e.type}');
    debugPrint('DIO STATUS: ${e.response?.statusCode}');
    debugPrint('DIO RESPONSE: ${e.response?.data}');

    rethrow;
  }
});

final selectedPlaceProvider = StateProvider<PlaceModel?>((ref) => null);



