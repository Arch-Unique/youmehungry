// import 'dart:io';
import 'dart:typed_data';
import 'package:youmehungry/src/global/interfaces/api_service.dart';
import 'package:youmehungry/src/global/model/barrel.dart';
import 'package:youmehungry/src/global/services/barrel.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:youmehungry/src/utils/constants/prefs/prefs.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

import '../model/esim.dart';

typedef FromJsonFactory<T> = T Function(Map<String, dynamic>);

class JsonParser {
  static TotalResponse<T> parseList<T>(
    dynamic response,
    FromJsonFactory<dynamic> fromJson,
  ) {
    if (!(response.statusCode! as int).isSuccess()) {
      return TotalResponse<T>(0, <T>[], 0);
    }
    final data =
        (response.data["data"]["data"] ?? response.data["data"])
            as List<dynamic>;
    final tt =
        response.data["data"]["total"] ??
        (response.data["data"] as List<dynamic>).length;
    final tp = response.data["data"]["totalPages"] ?? 1;
    List<T> dt = <T>[];
    if (data.isNotEmpty) {
      dt = data
          .map((item) => fromJson(item as Map<String, dynamic>) as T)
          .toList();
    }
    return TotalResponse<T>(tt, dt, tp);
  }

  static T? parse<T>(dynamic response, FromJsonFactory<dynamic> fromJson) {
    if (!(response.statusCode! as int).isSuccess()) {
      return null;
    }
    return fromJson(response.data["data"] as Map<String, dynamic>) as T;
  }
}

class TotalResponse<T> {
  final int total;
  final int totalPages;
  final List<T> data;

  TotalResponse(this.total, this.data, this.totalPages);
}

class ApiWorker extends GetxController {
  final apiService = Get.find<DioApiService>();
  static final Map<Type, FromJsonFactory> factories = {
    User: User.fromJson,
    Category: Category.fromJson,
    CategoryItem: CategoryItem.fromJson,
    Review: Review.fromJson,
    Location: Location.fromJson,
    Card: Card.fromJson,
    Transaction: Transaction.fromJson,
    Favourite: Favourite.fromJson,
    AppInfo: AppInfo.fromJson,
    Wallet: Wallet.fromJson,
    Ads: Ads.fromJson,
    Bank: Bank.fromJson,
    Esim: Esim.fromJson,
  };

  static final Map<Type, String> urls = {
    User: AppUrls.getUser,
    Category: AppUrls.categories,
    CategoryItem: AppUrls.categoryItem,
    Review: AppUrls.review,
    Location: AppUrls.location,
    Card: AppUrls.card,
    Transaction: AppUrls.transaction,
    Favourite: AppUrls.favourites,
    AppInfo: AppUrls.appinfo,
    Wallet: AppUrls.wallet,
    Bank: AppUrls.bank,
    Ads: AppUrls.ads,
    Esim: AppUrls.esim,
  };

  static TotalResponse<T> getListOf<T>(dynamic res) {
    return JsonParser.parseList<T>(res, factories[T]!);
  }

  static T? getOf<T>(dynamic res) {
    return JsonParser.parse<T>(res, factories[T]!);
  }

  Future<dynamic> create<T>(Map<String, dynamic> data, {String? url}) async {
    final res = await apiService.post(url ?? urls[T]!, data: data);
    if (!res.statusCode!.isSuccess()) {
      throw res.data["error"];
    }
    return res.data["data"];
  }

  Future<dynamic> patch<T>(
    int? id,
    Map<String, dynamic> data, {
    String? url,
  }) async {
    final curl = url ?? urls[T]!;
    final res = await apiService.patch(
      id == null ? curl : "$curl/$id",
      data: data,
    );
    if (!res.statusCode!.isSuccess()) {
      throw res.data["error"];
    }
    return res.data["data"];
  }

  Future<T?> getOne<T>(int id, {String? url}) async {
    final res = await apiService.get(url ?? "${urls[T]!}/$id");
    print(res.data);
    return getOf<T>(res);
  }

  Future<TotalResponse<T>> getAll<T>({
    int page = 1,
    int limit = 10,
    String? rurl,
    int? categoryid,
    int? locationid,
    int? walletid,
    int? categoryItemId,
    String? q,
    String? activity,
    String? fromDate,
    String? toDate,
    String? status,
    String? type,
    String? useOr,
  }) async {
    // Construct query parameters as an object
    Map<String, dynamic> queryParams = {
      'page': page.toString(),
      'pageSize': limit.toString(),
      'q': q,
      'fromDate': fromDate,
      'toDate': toDate,
      'activity': activity,
      'categoryid': categoryid?.toString(),
      'locationid': locationid?.toString(),
      'walletId': walletid?.toString(),
      'status': status,
      'type': type,
      'useOr': useOr?.toString(),
      'categoryItemId': categoryItemId?.toString(),
    };

    // Remove null or empty values
    queryParams.removeWhere(
      (key, value) => value == null || value.toString().isEmpty,
    );

    // Convert query parameters to URL-encoded string
    String queryString = Uri(queryParameters: queryParams).query;

    // Construct full URL
    final url = '${rurl ?? urls[T]!}?$queryString';

    final res = await apiService.get(url);
    return getListOf<T>(res);
  }

  Future<dynamic> delete<T>(String id, {String? url}) async {
    final res = await apiService.delete(url ?? "${urls[T]!}/$id");
    if (!res.statusCode!.isSuccess()) {
      throw res.data["error"];
    }
    return res.data["data"];
  }

  Future<String?> uploadPhoto(Uint8List? body) async {
    if (body == null) return null;
    final res = await apiService.post(
      AppUrls.upload,
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(
          body,
          filename: "imageupload.png",
          contentType: DioMediaType.parse("image/png"),
        ),
        'type': 2,
      }),
    );

    print(res);
    if (res.statusCode!.isSuccess()) {
      return res.data["data"];
    }
    return null;
  }

  Future<bool> getOTP() async {
    final res = await apiService.post("${AppUrls.profile}/send-otp");
    if (res.statusCode!.isSuccess()) {
      return true;
    }
    return false;
  }

  Future<bool> verifyOTP(String otp) async {
    final res = await apiService.post(
      "${AppUrls.profile}/verify-otp",
      data: {"otp": otp},
    );
    if (!res.statusCode!.isSuccess()) {
      throw "Invalid/Expired OTP";
    }
    return true;
  }

  Future<Map<String, String>> getUserLoc() async {
    final res = await Dio().getUri(
      Uri.parse("https://get.geojs.io/v1/ip/geo.json"),
    );
    return {
      "country": res.data["country"] ?? "Nigeria",
      "state": res.data["city"] ?? res.data["region"] ?? "Lagos",
    };
  }
}

class DioApiService extends GetxService implements ApiService {
  final Dio _dio;
  RequestOptions? _lastRequestOptions;
  CancelToken _cancelToken = CancelToken();
  final prefService = Get.find<MyPrefService>();
  Rx<ErrorTypes> currentErrorType = ErrorTypes.noInternet.obs;

  DioApiService() : _dio = Dio(BaseOptions(baseUrl: AppUrls.baseURL)) {
    _dio.interceptors.add(AppDioInterceptor());
  }

  @override
  Future<Response> delete(String url, {data, bool hasToken = true}) async {
    final response = await _dio.delete(
      url,
      data: data,
      cancelToken: _cancelToken,
      options: Options(headers: _getHeader(hasToken)),
    );
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> get(String url, {data, bool hasToken = true}) async {
    final response = await _dio.get(
      url,
      cancelToken: _cancelToken,
      data: data,
      options: Options(headers: _getHeader(hasToken)),
    );
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> patch(String url, {data, bool hasToken = true}) async {
    final response = await _dio.patch(
      url,
      data: data,
      cancelToken: _cancelToken,
      options: Options(headers: _getHeader(hasToken)),
    );
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> post(String url, {data, bool hasToken = true}) async {
    final response = await _dio.post(
      url,
      data: data,
      cancelToken: _cancelToken,
      options: Options(headers: _getHeader(hasToken)),
    );
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> retryLastRequest() async {
    if (_lastRequestOptions != null) {
      final response = await _dio.request(
        _lastRequestOptions!.path,
        data: _lastRequestOptions!.data,
        options: Options(
          method: _lastRequestOptions!.method,
          headers: _lastRequestOptions!.headers,
          // Add any other options if needed
        ),
        cancelToken: _cancelToken,
      );

      return response;
    }
    return Response(
      requestOptions: RequestOptions(),
      statusCode: 404,
      statusMessage: "No Last Request",
    );
  }

  @override
  void cancelLastRequest() {
    _cancelToken.cancel('Request cancelled');
    _cancelToken = CancelToken();
  }

  isSuccess(int? statusCode) {
    return UtilFunctions.isSuccess(statusCode);
  }

  Map<String, dynamic>? _getHeader([bool hasToken = true]) {
    return hasToken
        ? {
            "Authorization":
                "Bearer ${prefService.get(MyPrefs.mpUserJWT) ?? ""}",
          }
        : {};
  }
}
