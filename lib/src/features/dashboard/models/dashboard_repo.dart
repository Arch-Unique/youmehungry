import 'dart:convert';

import 'package:biometric_signature/biometric_signature.dart';
import 'package:biometric_signature/signature_options.dart';
import 'package:crypto/crypto.dart';
import 'package:youmehungry/src/global/model/barrel.dart';
import 'package:youmehungry/src/plugin/paypal.dart';
import 'package:get/get.dart';

import '../../../global/services/barrel.dart';
import '../../../src_barrel.dart';

class DashboardRepo extends GetxController {
  final apiWorker = Get.find<ApiWorker>();
  final appService = Get.find<AppService>();
  final BiometricSignature _biometricSignature = BiometricSignature();

  //PROFILE
  Future<void> _updateProfile<T>(
    Map<String, dynamic> payload, [
    int? id,
  ]) async {
    await apiWorker.patch<T>(id, payload);
  }

  Future<void> _updateUserDetails(Map<String, dynamic> payload) async {
    await _updateProfile<User>(payload);
  }

  String _hashPin(String pin) {
    var bytes = utf8.encode(pin); // convert string to bytes
    var digest = sha256.convert(bytes);
    String hexOutput = digest.toString();
    return hexOutput;
  }

  String _signPinWithChallenge(
    Map<String, dynamic> payload,
    String hashPin,
    String nonce,
  ) {
    var hm = Hmac(
      sha256,
      utf8.encode(hashPin),
    ).convert(utf8.encode(nonce + jsonEncode(payload))).toString();
    return hm;
  }

  Future<String> _signBiometricWithChallenge(
    Map<String, dynamic> payload,
    String nonce,
  ) async {
    final bioAvailable = await _biometricSignature.biometricAuthAvailable();
    if (bioAvailable?.contains("none") ?? false) {
      throw "No Biometric found";
    }
    final bioPubToken2 = await _biometricSignature.createKeys();
    await _updateUserDetails({"biotoken": bioPubToken2});
    final bioPubToken = await _biometricSignature.createSignature(
      SignatureOptions(
        payload: nonce + jsonEncode(payload),
        promptMessage: "Authorize this transaction",
      ),
    );
    if (bioPubToken == null) {
      throw "An error occured during biometrics, please try again or use PIN";
    }
    return bioPubToken;
  }

  Future<Map<String, dynamic>> _getSignature(
    Map<String, dynamic> data, {
    String? pin,
  }) async {
    String sig;
    final nonce = await generateNonce();
    if (pin == null) {
      sig = await _signBiometricWithChallenge(data, nonce);
    } else {
      sig = _signPinWithChallenge(data, _hashPin(pin), nonce);
    }
    return {"data": data, "sig": sig, "isBio": pin == null};
  }

  // Future registerUserBiometrics() async {
  //   final bioAvailable = await _biometricSignature.biometricAuthAvailable();
  //   if (bioAvailable?.contains("none") ?? true) {
  //     return;
  //   }
  //   try {
  //     final bioPubToken = await _biometricSignature.createKeys();
  //     await _updateUserDetails({"biotoken": bioPubToken});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String hashPin(String code) {
    return _hashPin(code);
  }

  Future<void> updateLocation(
    String address,
    String country,
    int locationid,
  ) async {
    await _updateUserDetails({
      "address": address,
      "country": country == "Special" ? "Nigeria" : country,
      "locationid": locationid,
    });
  }

  Future<void> updateLocationOnly(int locationid) async {
    await _updateUserDetails({"locationid": locationid});
  }

  Future<void> updateProfile(
    String fullname,
    String email,
    String phone,
    String address,
    String country, {
    String? dob,
  }) async {
    await _updateUserDetails(
      dob == null
          ? {
              "fullname": fullname,
              "email": email,
              "phone": phone,
              "address": address,
              "country": country == "Special" ? "Nigeria" : country,
            }
          : {
              "fullname": fullname,
              "email": email,
              "phone": phone,
              "address": address,
              "country": country == "Special" ? "Nigeria" : country,
              "dob": dob,
            },
    );
  }

  Future<void> updateFCMToken(String fcm) async {
    await _updateUserDetails({"fcmtoken": fcm});
  }

  ///id - categoryItemId
  Future<TotalResponse<CategoryItem>> getFavourites([int? id]) async {
    return await apiWorker.getAll<CategoryItem>(
      rurl: "${AppUrls.favourites}${id == null ? "" : "/$id"}",
    );
  }

  ///id - categoryItemId
  Future<void> addToFavourites(int id) async {
    await apiWorker.patch<Favourite>(id, {}, url: AppUrls.favouritesAdd);
  }

  ///id - fav id
  Future<void> removeFromFavourites(int id) async {
    await apiWorker.patch<Favourite>(id, {}, url: AppUrls.favouritesRemove);
  }

  //add to booking
  Future<void> addToBooking(int id) async {
    await apiWorker.create({}, url: "${AppUrls.booking}/$id/add");
  }

  Future<TotalResponse<CategoryItem>> getBookings() async {
    return await apiWorker.getAll<CategoryItem>(
      limit: 0,
      rurl: AppUrls.booking,
    );
  }

  Future<void> removeFromBooking(int id) async {
    await apiWorker.delete<CategoryItem>(
      "",
      url: "${AppUrls.booking}/$id/remove",
    );
  }

  Future<void> logout() async {}

  //CATEGORIES
  Future<TotalResponse<Category>> getAllCategory() async {
    return await apiWorker.getAll<Category>(limit: 100);
  }

  Future<TotalResponse<CategoryItem>> getAllCategoryItems(
    int location, {
    int? category,
  }) async {
    return await apiWorker.getAll<CategoryItem>(
      limit: 10000,
      categoryid: category,
      locationid: location,
      useOr: "true",
    );
  }

  Future<void> createReview(Review rev) async {
    await apiWorker.create<Review>(rev.toJson());
  }

  Future<TotalResponse<Review>> getReviewsForCategoryItem(
    int categoryItemId,
  ) async {
    return await apiWorker.getAll<Review>(
      limit: 100,
      categoryItemId: categoryItemId,
    );
  }

  //APPINFOS
  Future<TotalResponse<AppInfo>> getAllAppInfo() async {
    return await apiWorker.getAll<AppInfo>(limit: 10);
  }

  //LOCATIONS
  Future<TotalResponse<Location>> getAllLocations() async {
    return await apiWorker.getAll<Location>(limit: 10);
  }

  //XTRAS
  Future<dynamic> createFlight(Map<String, dynamic> data) async {
    final res = await apiWorker.apiService.post(AppUrls.flights, data: data);
    return res.data["data"];
  }

  Future<dynamic> createVISA(Map<String, dynamic> data) async {
    final res = await apiWorker.apiService.post(AppUrls.visa, data: data);
    return res.data["data"];
  }

  Future<List<Map<String, dynamic>>> getFlights() async {
    final res = await apiWorker.apiService.get(AppUrls.flights);
    return res.data["data"]["data"];
  }

  Future<List<Map<String, dynamic>>> getVISA() async {
    final res = await apiWorker.apiService.get(AppUrls.visa);
    return res.data["data"]["data"];
  }

  //TRANSACTIONS
  Future<String> generateNonce() async {
    final res = await apiWorker.apiService.get("${AppUrls.finance}/nonce");
    return res.data["data"];
  }

  Future<String?> verifyAcct(String bank, String acct) async {
    final res = await apiWorker.apiService.post(
      "${AppUrls.finance}/verifyAcct",
      data: {"bank": bank, "account": acct},
    );
    if (!res.statusCode!.isSuccess()) {
      return null;
    }
    return res.data["data"]["account_name"] ?? res.data["data"]["accountName"];
  }

  Future<void> createWallet(Map<String, dynamic> rev) async {
    await apiWorker.create<Wallet>(rev);
  }

  Future<void> updateWallet(int id, Map<String, dynamic> rev) async {
    await apiWorker.patch<Wallet>(id, rev);
  }

  Future<void> deleteWallet(int id) async {
    await apiWorker.delete<Wallet>(id.toString());
  }

  Future<Wallet?> getWallet() async {
    return await apiWorker.getOne<Wallet>(0, url: "${AppUrls.wallet}/user");
  }

  Future<TotalResponse<Transaction>> getAllTransactions(
    int walletId,
    String fromDate,
    String toDate, {
    int page = 1,
    int pageSize = 10,
  }) async {
    return await apiWorker.getAll<Transaction>(
      page: page,
      limit: pageSize,
      walletid: walletId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<OrderResponse> createPaypalOrder(Map<String, dynamic> rev) async {
    final f = await apiWorker.create<Transaction>(
      rev,
      url: "${AppUrls.transaction}/paypal",
    );
    return OrderResponse.fromJson(f);
  }

  Future<void> createTransfer(Map<String, dynamic> rev, String? pin) async {
    final sig = await _getSignature(rev, pin: pin);
    await apiWorker.create<Transaction>(
      sig,
      url: "${AppUrls.transaction}/transfer",
    );
  }

  Future<void> createTransferEsim(Map<String, dynamic> rev, String? pin) async {
    final sig = await _getSignature(rev, pin: pin);
    await apiWorker.create<Transaction>(
      sig,
      url: "${AppUrls.transaction}/esim",
    );
  }

  Future<void> createCard(
    String alias,
    int type,
    String pin,
    Map<String, dynamic> userData,
  ) async {
    await apiWorker.create<Card>({
      "cardData": {"alias": alias, "type": type, "pin": pin},
      "userData": userData,
    });
  }

  Future<void> changeCardPIN(int id, String oldPin, String newPin) async {
    await apiWorker.create<Card>({
      "oldPin": oldPin,
      "newPin": newPin,
    }, url: "${AppUrls.card}/change-pin/$id");
  }

  Future<void> fundCard(int id, double amount, String? pin) async {
    final data = {"amount": amount};
    final sig = await _getSignature(data, pin: pin);
    await apiWorker.create<Card>(sig, url: "${AppUrls.card}/fund/$id");
  }

  Future<void> withdrawCard(int id, double amount, String? pin) async {
    final data = {"amount": amount};
    final sig = await _getSignature(data, pin: pin);
    await apiWorker.create<Card>(sig, url: "${AppUrls.card}/withdraw/$id");
  }

  Future<void> changeCardLabel(int id, String alias, int type) async {
    await apiWorker.create<Card>({
      "alias": alias,
      "type": type,
    }, url: "${AppUrls.card}/change-label/$id");
  }

  Future<void> toggleCard(int id, bool isFrozen) async {
    await apiWorker.create<Card>({
      "isfrozen": isFrozen,
    }, url: "${AppUrls.card}/toggle-card/$id");
  }

  Future<List<Bank>> getAllBanks() async {
    try {
      return (await apiWorker.getAll<Bank>()).data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Esim>> getAllEsims() async {
    try {
      return (await apiWorker.getAll<Esim>()).data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<TotalResponse<Card>> getAllCards() async {
    return await apiWorker.getAll<Card>();
  }

  Future<Card?> getCard(int id) async {
    return await apiWorker.getOne<Card>(id);
  }

  //ADMIN
  Future<TotalResponse<User>> getAllUsers(
    int page,
    int limit, {
    String? q,
  }) async {
    return await apiWorker.getAll<User>(page: page, limit: limit, q: q);
  }

  Future<TotalResponse<Wallet>> getAllWallets() async {
    return await apiWorker.getAll<Wallet>(
      limit: 0,
      rurl: "${AppUrls.wallet}/admin",
    );
  }

  Future<void> saveEditCategoryItem(CategoryItem cit) async {
    if (cit.id != 0) {
      await apiWorker.patch<CategoryItem>(
        cit.id,
        cit.toJson(),
        url: AppUrls.categoryItemRaw,
      );
    } else {
      await apiWorker.create<CategoryItem>(
        cit.toJson(),
        url: AppUrls.categoryItemRaw,
      );
    }
  }

  Future<TotalResponse<Ads>> getAllAds() async {
    return await apiWorker.getAll<Ads>(limit: 0);
  }
}
