import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:youmehungry/src/features/dashboard/views/wallet/views/transfer_process.dart';
import 'package:youmehungry/src/features/shared.dart';
import 'package:youmehungry/src/global/model/barrel.dart';
import 'package:youmehungry/src/global/model/esim.dart';
import 'package:youmehungry/src/global/services/barrel.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/plugin/paypal.dart';
import 'package:youmehungry/src/src_barrel.dart';
import 'package:youmehungry/src/utils/constants/countries.dart';
import 'package:flutter/foundation.dart' as fff;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/dashboard_repo.dart';

class DashboardController extends GetxController {
  Rx<DashboardMode> currentDashboardMode = DashboardMode.home.obs;
  Rx<WebDashboardMode> currentWebDashboardMode = WebDashboardMode.dashboard.obs;
  Rx<Location> currentLocation = Location(
    name: "Lagos",
    address: "Lekki",
    images: [''],
  ).obs;
  int get currentDashboardModeIndex => currentDashboardMode.value.index;
  RxInt curScreen = 0.obs;
  RxBool isEditMode = false.obs;
  RxBool isDetailMode = false.obs;
  RxBool isLoading = false.obs;
  RxBool isResetPinMode = false.obs;
  Rx<Uint8List> u8 = Uint8List(0).obs;

  RxInt curPaginatorPage = 1.obs;
  RxInt curPaginatorTotal = 1.obs;
  RxInt curPaginatorTotalPages = 1.obs;
  RxInt curPaginatorRows = 10.obs;
  RxString curQuery = "".obs;

  Rx<Transaction> currentTransaction = Transaction().obs;
  Rx<Card> currentCardItem = Card().obs;
  Rx<Category> curCategory = Category().obs;
  Rx<CategoryItem> currentCategoryItem = CategoryItem().obs;
  Rx<Wallet> currentWallet = Wallet(userId: 0).obs;

  RxList<Card> allCardItems = <Card>[].obs;
  RxList<Ads> allAds = <Ads>[].obs;
  RxList<CategoryItem> allBookingsItem = <CategoryItem>[].obs;
  RxList<Esim> allEsims = <Esim>[].obs;

  RxList<Transaction> recentTransactions = <Transaction>[].obs;
  RxList<Location> allLocations = <Location>[].obs;
  RxList<Location> allCountryLocations = <Location>[].obs;
  RxList<Map<String, String>> allAvailableCountries =
      <Map<String, String>>[].obs; //from constants
  List<Bank> allBanks = <Bank>[];

  /// events,accoms,concierge,beauty,foods,shopping
  RxList<Category> allCategory = <Category>[].obs;
  List<TextEditingController> tecs = List.generate(
    11,
    (i) => TextEditingController(),
  );
  List<TextEditingController> walletTecs = List.generate(
    15,
    (i) => TextEditingController(),
  );

  RxList<CategoryItem> allCatItems = <CategoryItem>[].obs;
  RxList<CategoryItem> allFavItems = <CategoryItem>[].obs;
  RxBool dataLoading = false.obs;
  RxBool needsUpdate = false.obs;
  Map<Category, List<CategoryItem>> allCategoryItems = {};
  RxMap<Category, List<CategoryItem>> allFavouritesItems =
      <Category, List<CategoryItem>>{}.obs;
  List<CategoryItem> get allFavouritesItemsCT =>
      allFavouritesItems.values.expand((items) => items).toList();
  Map<String, String> get currentLocMap =>
      countriesData
          .where(
            (test) =>
                test["name"] == (currentLocation.value.country ?? "Nigeria"),
          )
          .firstOrNull ??
      (countriesData.where((test) => test["name"] == "Nigeria").first);

  //ADMIN
  Rx<TotalResponse<User>> allUsers = TotalResponse<User>(0, [], 0).obs;
  Rx<TotalResponse<User>> allUsersTotal = TotalResponse<User>(0, [], 0).obs;
  Rx<TotalResponse<Transaction>> allTransaction = TotalResponse<Transaction>(
    0,
    [],
    0,
  ).obs;
  Rx<TotalResponse<Wallet>> allWallet = TotalResponse<Wallet>(0, [], 0).obs;
  RxList<EsimProduct> allEsimProducts = <EsimProduct>[].obs;
  Rx<EsimProduct?> currentEsimProduct = (null as EsimProduct?).obs;
  RxList<AppInfo> allAppInfos = <AppInfo>[].obs;
  AddressFieldController afcController = AddressFieldController(
    TextEditingController(),
    true,
  );
  AddressFieldController afcController2 = AddressFieldController(
    TextEditingController(),
    false,
  );

  final dbRepo = Get.find<DashboardRepo>();
  final profkey = GlobalKey<FormState>();
  final walletkey = GlobalKey<FormState>();
  late PackageInfo packageInfo;

  void resetInit() {
    currentLocation.value = Location(
      name: "Lagos",
      address: "Lekki",
      images: [''],
    );
    currentDashboardMode.value = DashboardMode.home;
    currentWebDashboardMode.value = WebDashboardMode.dashboard;
    curScreen.value = 0;
    isEditMode.value = false;
    isDetailMode.value = false;
    isLoading.value = false;
    u8.value = Uint8List(0);
    curPaginatorPage.value = 1;
    curPaginatorTotal.value = 1;
    curPaginatorTotalPages.value = 1;
    curPaginatorRows.value = 10;
    curQuery.value = "";
    currentTransaction.value = Transaction();
    currentCardItem.value = Card();
    curCategory.value = Category();
    currentWallet.value = Wallet(userId: 0);
    allFavItems.value = <CategoryItem>[];
    allFavouritesItems.value = <Category, List<CategoryItem>>{};
    allCardItems.value = <Card>[];
    allBookingsItem.value = <CategoryItem>[];
    recentTransactions.value = <Transaction>[];
    allEsims.value = <Esim>[];
  }

  List<CategoryItem> getCategoryItemsFromIndex(int id) {
    return allCategoryItems[allCategory.where((test) => test.id == id).first] ??
        [];
  }

  List<CategoryItem> getFeaturedCategoryItemsFromIndex(int id) {
    final b = getCategoryItemsFromIndex(id);
    if (b.length < 5) {
      return b;
    }
    return b.sublist(0, 5);
  }

  List<CategoryItem> getCategoryItemsByActivityFromIndex(int id, String act) {
    return getCategoryItemsFromIndex(
      id,
    ).where((test) => test.activity == act).toList();
  }

  List<String> getCategoryActivitiesFromIndex(int id) {
    return allCategory.where((test) => test.id == id).first.activities;
  }

  Future<void> getAds() async {
    allAds.value = (await dbRepo.getAllAds()).data;
  }

  Future<CategoryItem> getCategoryItemById(int id) async {
    final f = await dbRepo.apiWorker.getOne<CategoryItem>(
      id,
      url: "${AppUrls.categoryItemRaw}/$id",
    );
    return f!;
  }

  List<CategoryItem> getFavouriteCategoryItemsFromIndex(int id) {
    return allFavouritesItems[allCategory
        .where((test) => test.id == id)
        .first]!;
  }

  Future<void> startApp() async {
    if (dbRepo.appService.isLoggedIn.value) {
      initApp();
    }
  }

  void gotoNextPage() {
    //increase page
  }

  void gotoPreviousPage() {
    //decrease page
  }

  void gotoFirstPage() {
    //page = 1
  }

  void gotoLastPage() {
    //page = total
  }

  Future<void> initLocation() async {
    allLocations.value = (await dbRepo.getAllLocations()).data;
    final ct = allLocations.map((e) => e.country ?? "Nigeria").toSet().toList();
    List<Map<String, String>> dg = List.from(countriesData);
    dg.retainWhere((element) => ct.contains(element['name']));
    allAvailableCountries.value = List.from(dg);
    ct.removeLast();
    allCountryLocations.value = [];
    for (var element in ct) {
      allCountryLocations.add(
        element == "South Africa"
            ? allLocations.lastWhere((test) => test.country == element)
            : allLocations.firstWhere((test) => test.country == element),
      );
    }
  }

  Future<void> initApp({Location? loc}) async {
    try {
      isLoading.value = true;
      packageInfo = await PackageInfo.fromPlatform();
      allAppInfos.value = (await dbRepo.getAllAppInfo()).data;

      if ((allAppInfos[1].numberValue?.toInt() ?? 0) >
          (int.tryParse(packageInfo.buildNumber) ?? 1)) {
        needsUpdate.value = true;
      }
      await refreshFinance();
      await refreshEsims();
      await refreshBanks();
      await initLocation();
      final ml = await dbRepo.apiWorker.getUserLoc();
      currentLocation.value =
          loc ??
          allLocations
              .where(
                (test) => dbRepo.appService.currentUser.value.locationId == null
                    ? test.country == ml["country"] && test.name == ml["state"]
                    : test.id ==
                          (dbRepo.appService.currentUser.value.locationId),
              )
              .firstOrNull ??
          allLocations[0];
      allCategory.value = (await dbRepo.getAllCategory()).data;
      await refreshCategory();
      await refreshBookings();
      await getAds();
      isLoading.value = false;
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }

  Future<void> refreshBanks() async {
    if (dbRepo.appService.currentUser.value.id != 0) {
      allBanks = await dbRepo.getAllBanks();
    }
  }

  Future<void> refreshEsims() async {
    allEsims.value = await dbRepo.getAllEsims();
  }

  Future<bool> validateCredentials(String passportImage) async {
    try {
      // Upload and verify passport image
      final imageBytes = await File(passportImage).readAsBytes();
      final uploadedImageUrl = await dbRepo.apiWorker.uploadPhoto(imageBytes);

      final response = await dbRepo.apiWorker.apiService.get(
        "${AppUrls.utils}/passport/verify/$uploadedImageUrl",
      );

      final passportData = response.data["data"];

      // Validate name - check if any part of the entered name exists in passport
      if (!_validateName(passportData["name"], walletTecs[0].text)) {
        throw "Name does not match Passport";
      }
      // Validate passport number (exact match required)
      if (!_validatePassportNumber(
        passportData["passportno"],
        walletTecs[4].text,
      )) {
        throw "Passport Number does not match Passport";
      }

      // Validate expiry date (exact match required)
      if (!_validateExpiryDate(
        passportData["expirydate"],
        walletTecs[5].text,
      )) {
        throw "Expiry Date does not match Passport";
      }

      // Validate date of birth (exact match required)
      if (!_validateDateOfBirth(passportData["dob"], walletTecs[3].text)) {
        throw "Date Of Birth does not match Passport";
      }
      walletTecs[11].text = uploadedImageUrl!;

      // All validations passed
      return true;
    } catch (e) {
      Ui.showError(e.toString());
      return false;
    }
  }

  Future<bool> validateVISACredentials(String passportImage) async {
    try {
      // Upload and verify passport image
      final imageBytes = await File(passportImage).readAsBytes();
      final uploadedImageUrl = await dbRepo.apiWorker.uploadPhoto(imageBytes);

      final response = await dbRepo.apiWorker.apiService.get(
        "${AppUrls.utils}/visa/verify/$uploadedImageUrl",
      );

      final passportData = response.data["data"];

      // Validate name - check if any part of the entered name exists in passport
      if (!_validateName(passportData["name"], walletTecs[0].text)) {
        throw "Name does not match VISA";
      }
      // Validate passport number (exact match required)
      if (!_validatePassportNumber(
        passportData["visano"],
        walletTecs[7].text,
      )) {
        throw "VISA Number does not match VISA";
      }

      // Validate expiry date (exact match required)
      if (!_validateExpiryDate(
        passportData["expirydate"],
        walletTecs[8].text,
      )) {
        throw "Expiry Date does not match VISA";
      }
      walletTecs[12].text = uploadedImageUrl!;

      // All validations passed
      return true;
    } catch (e) {
      Ui.showError(e.toString());
      return false;
    }
  }

  // Helper method: Validate name
  bool _validateName(String? passportName, String enteredName) {
    if (passportName == null || passportName.isEmpty) return false;
    if (enteredName.isEmpty) return false;

    final pName = passportName.toLowerCase().trim();
    final enteredNames = enteredName.toLowerCase().trim().split(" ");

    // Check if at least one part of the entered name exists in passport name
    return enteredNames.any((name) => pName.contains(name));
  }

  // Helper method: Validate passport number
  bool _validatePassportNumber(String? passportNumber, String enteredNumber) {
    if (passportNumber == null || passportNumber.isEmpty) return false;
    if (enteredNumber.isEmpty) return false;

    return passportNumber.toLowerCase().trim() ==
        enteredNumber.toLowerCase().trim();
  }

  // Helper method: Validate expiry date
  bool _validateExpiryDate(String? expiryDate, String enteredDate) {
    if (expiryDate == null || expiryDate.isEmpty) return false;
    if (enteredDate.isEmpty) return false;

    return expiryDate.toLowerCase().trim() == enteredDate.toLowerCase().trim();
  }

  // Helper method: Validate date of birth
  bool _validateDateOfBirth(String? dob, String enteredDob) {
    if (dob == null || dob.isEmpty) return false;
    if (enteredDob.isEmpty) return false;

    return dob.toLowerCase().trim() == enteredDob.toLowerCase().trim();
  }

  Future refreshCategory() async {
    allCatItems.value = (await dbRepo.getAllCategoryItems(
      currentLocation.value.id,
      category: currentLocation.value.country == "Special" ? 9 : null,
    )).data;
    allCatItems.sort((a, b) {
      final ad = a.createdAt;
      final bd = b.createdAt;
      if (ad == null && bd == null) return 0;
      if (ad == null) return 1; // a is older -> after b
      if (bd == null) return -1; // b is older -> after a
      return bd.compareTo(ad); // newest first
    });

    allFavItems.value = (await dbRepo.getFavourites()).data;
    allCategoryItems.clear();
    allFavouritesItems.clear();
    for (var element in allCategory) {
      allCategoryItems[element] = allCatItems
          .where((test) => test.categoryId == element.id)
          .toList();
      allFavouritesItems[element] = allFavItems
          .where((test) => test.categoryId == element.id)
          .toList();

      if (element.id == 8) {
        final essentialChecklist = (await dbRepo.getAllCategoryItems(
          0,
          category: 8,
        )).data;
        allCategoryItems[element] = essentialChecklist
            .where(
              (cit) =>
                  allLocations
                      .where((test) => test.id == cit.locationId)
                      .first
                      .country ==
                  currentLocation.value.country,
            )
            .toList();
      }
    }
  }

  Future refreshFavs() async {
    allFavItems.value = (await dbRepo.getFavourites()).data;

    allFavouritesItems.clear();
    for (var element in allCategory) {
      allFavouritesItems[element] = allFavItems
          .where((test) => test.categoryId == element.id)
          .toList();
    }
  }

  Future<void> refreshFinance() async {
    currentWallet.value = (await dbRepo.getWallet()) ?? Wallet(userId: 0);
    if (currentWallet.value.id != 0) {
      allCardItems.value = (await dbRepo.getAllCards()).data;
      final dt = DateTime.now();
      recentTransactions.value = (await dbRepo.getAllTransactions(
        currentWallet.value.id,
        DateTime(2025).toSQLDate(),
        DateTime(
          dt.year,
          dt.month,
          dt.day,
          dt.hour,
          dt.minute,
          dt.second,
        ).toSQLDate(),
      )).data..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    }
  }

  Future<void> updateLocation(String address, String country, int id) async {
    if (dbRepo.appService.currentUser.value.id != 0) {
      // await dbRepo.updateLocation(address, country, id);
      currentLocation.value = allLocations.where((test) => test.id == id).first
        ..address = address;

      await dbRepo.appService.refreshUser();
    }

    await refreshCategory();
  }

  String getRealCountry(String country) {
    return country == "Special" ? "Nigeria" : country;
  }

  Future<void> refreshBookings() async {
    if (dbRepo.appService.currentUser.value.id != 0) {
      final f = await dbRepo.getBookings();
      allBookingsItem.value = f.data;
    }
  }

  bool isInFavs(int id) {
    return allFavouritesItemsCT.any((f) => f.id == id);
  }

  Future<void> addToFavs(id) async {
    dbRepo
        .addToFavourites(id)
        .then((_) {
          refreshFavs().then((_) => {});
        })
        .catchError((e) {
          Ui.showError(e.toString());
        });
  }

  Future<void> removeFromFavs(id) async {
    dbRepo
        .removeFromFavourites(id)
        .then((_) {
          refreshFavs().then((_) => {});
        })
        .catchError((e) {
          Ui.showError(e.toString());
        });
  }

  void initUserDetails() {
    tecs[0].text = dbRepo.appService.currentUser.value.fullname;
    tecs[1].text = dbRepo.appService.currentUser.value.email;
    tecs[2].text = dbRepo.appService.currentUser.value.phone ?? "";
    afcController.tec.text = dbRepo.appService.currentUser.value.address ?? "";
    afcController.country =
        dbRepo.appService.currentUser.value.country ?? "Nigeria";
    tecs[3].text = dbRepo.appService.currentUser.value.dob == null
        ? ""
        : DateFormat(
            "yyyy-MM-dd",
          ).format(dbRepo.appService.currentUser.value.dob!);
    tecs[4].text = dbRepo.appService.currentUser.value.country ?? "Nigeria";
  }

  Future<void> saveUserDetails() async {
    try {
      if (profkey.currentState!.validate()) {
        await dbRepo.updateProfile(
          tecs[0].text,
          tecs[1].text,
          tecs[2].text,
          afcController.tec.text,
          afcController.country,
          dob: tecs[3].text,
        );
        await dbRepo.appService.refreshUser();
        Ui.showInfo("Profile updated successfully");
      }
    } catch (e) {
      Ui.showError(e.toString());
    }
  }

  Future<List<dynamic>> getReviewsForCIT(int id) async {
    final reviews = (await dbRepo.getReviewsForCategoryItem(id));
    final reviewTotal = reviews.data
        .map((e) => e.rating ?? 0)
        .fold(0.0, (a, b) => a + b);
    return [reviewTotal / (reviews.total == 0 ? 1 : reviews.total), reviews];
  }

  Future<List<Transaction>> getTransactionItemFromMonthYear(
    int m,
    int year,
  ) async {
    final trx = await dbRepo.getAllTransactions(
      currentWallet.value.id,
      DateTime(year, m, 1).toSQLDate(),
      DateTime(year, m + 1, 1).toSQLDate(),
    );
    return trx.data..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }

  Future<void> createReview(String description, int cit, double rating) async {
    try {
      await dbRepo.createReview(
        Review(
          description: description,
          userId: dbRepo.appService.currentUser.value.id,
          categoryItemsId: cit,
          rating: rating,
        ),
      );
    } catch (e) {
      Ui.showError(e.toString());
    }
  }

  //WALLET
  Future<bool> verifyPinCode(String code) async {
    return verifyOTP(code);
  }

  Future<void> resendCode() async {
    await sendOTP();
  }

  Future<void> updateWallet() async {
    await loadAsyncFunction(() async {
      try {
        final payload = {"pin": walletTecs[4].text};
        await dbRepo.updateWallet(currentWallet.value.id, payload);
      } catch (e) {
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> updateWalletStatus(bool isActive) async {
    await loadAsyncFunction(() async {
      try {
        final payload = {"status": isActive ? "active" : "closed"};
        await dbRepo.updateWallet(currentWallet.value.id, payload);
        await refreshFinance();
      } catch (e) {
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> deleteWallet() async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.deleteWallet(currentWallet.value.id);
        await refreshFinance();

        Ui.showInfo("Account Closed");
      } catch (e) {
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> createWallet() async {
    await loadAsyncFunction(() async {
      try {
        final payload = {
          // "bvn": walletTecs[3].text,
          // "nin": walletTecs[4].text,
          "pin": walletTecs[4].text,
          // "ninImg": walletTecs[11].text,
          "address": afcController2.tec.text,
          "phone": walletTecs[10].text,
          "passportexpiry": walletTecs[5].text,
          "passportno": walletTecs[4].text,
          "passportimage": walletTecs[6].text,
          "visaexpiry": walletTecs[8].text,
          "visano": walletTecs[7].text,
          "visaimage": walletTecs[9].text,
        };

        await dbRepo.appService.refreshUser();
        await dbRepo.createWallet(payload);
        await refreshFinance();
      } catch (e) {
        Ui.showError(e.toString());
      }
    });
  }

  void initWalletTecs() {
    walletTecs[0].text = dbRepo.appService.currentUser.value.fullname;
    walletTecs[1].text = dbRepo.appService.currentUser.value.email;
    walletTecs[2].text = dbRepo.appService.currentUser.value.phone ?? "";
    walletTecs[3].text = dbRepo.appService.currentUser.value.dob == null
        ? ""
        : DateFormat(
            "yyyy-MM-dd",
          ).format(dbRepo.appService.currentUser.value.dob!);
    afcController.tec.text = dbRepo.appService.currentUser.value.address ?? "";
    afcController.country =
        dbRepo.appService.currentUser.value.country ?? "Nigeria";
    afcController2.country =
        allAvailableCountries
            .where(
              (test) =>
                  test["name"] == (currentLocation.value.country ?? "Nigeria"),
            )
            .firstOrNull?["name"] ??
        "Nigeria";
    // afcController2.tec.text = dbRepo.appService.currentUser.value.address ?? "";
  }

  Future<bool> resolveBankAcct(String bank, String acct) async {
    try {
      if (bank.isEmpty || acct.isEmpty || acct.length != 10) {
        Ui.showError("Invalid Bank / Acct No");
        return false;
      }
      if (acct == currentWallet.value.bankAcct) {
        Ui.showError("Cannot send to ones self");
        return false;
      }
      final acctName = await dbRepo.verifyAcct(bank, acct);
      if (acctName != null) {
        currentTransaction.value.txAcctBankCode = bank;
        currentTransaction.value.txAcctNo = acct;
        currentTransaction.value.txAcctName = acctName;
      } else {
        Ui.showError("Acct not found for this number and bank");
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> transferMoney({String? pin}) async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.createTransfer({
          "amount": (currentTransaction.value.txAmount ?? 0.0).toInt(),
          "acctno": currentTransaction.value.txAcctNo ?? "0000000000",
          "acctname": currentTransaction.value.txAcctName ?? "Tester Name",
          "acctbank": currentTransaction.value.txAcctBankCode ?? "033",
          "description": currentTransaction.value.txDescription ?? "",
        }, pin);
        showTransactionStatus(true);
      } catch (e) {
        Ui.showError(e.toString());
        showTransactionStatus(false);
      }
    });
  }

  Future<void> esimPurchase(int qty, {String? pin}) async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.createTransferEsim({
          "variantId": currentEsimProduct.value?.id ?? "",
          "quantity": qty,
        }, pin);
        showTransactionStatus(true);
      } catch (e) {
        Ui.showError(e.toString());
        showTransactionStatus(false);
      }
    });
  }

  Future<void> createCard(String pin, Map<String, dynamic> userData) async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.createCard(
          currentCardItem.value.cardAlias!,
          currentCardItem.value.cardType ?? 0,
          pin,
          userData,
        );
        await refreshFinance();
      } catch (e) {
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> changeCardPIN(String oldPin, String newPin) async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.changeCardPIN(currentCardItem.value.id, oldPin, newPin);
        await refreshFinance();
      } catch (e) {
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> fundCard(double amount, {String? pin}) async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.fundCard(currentCardItem.value.id, amount, pin);
        await refreshFinance();
        showTransactionStatus(true);
      } catch (e) {
        showTransactionStatus(false);
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> withdrawCard(double amount, {String? pin}) async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.withdrawCard(currentCardItem.value.id, amount, pin);
        await refreshFinance();
        showTransactionStatus(true);
      } catch (e) {
        showTransactionStatus(false);
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> changeLabelCard() async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.changeCardLabel(
          currentCardItem.value.id,
          currentCardItem.value.cardAlias!,
          currentCardItem.value.cardType ?? 0,
        );
        await refreshFinance();
      } catch (e) {
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> toggleCard(bool isFrozen) async {
    await loadAsyncFunction(() async {
      try {
        await dbRepo.toggleCard(currentCardItem.value.id, isFrozen);
        await refreshFinance();
      } catch (e) {
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> startPayPal(
    double usdAmt, {
    String? variantId,
    int? quantity,
  }) async {
    await loadAsyncFunction(() async {
      try {
        final orderResp = await createPaypalOrder(
          usdAmt,
          variantId: variantId,
          quantity: quantity,
        );
        if (orderResp != null) {
          Get.to(
            PayPalPaymentScreen(
              link: orderResp.getApprovalUrl() ?? "",
              onPaymentSuccess: () async {
                showTransactionStatus(true);
                refreshFinance();
              },
              onPaymentError: () {
                showTransactionStatus(false);
              },
            ),
          );
        }
      } catch (e) {
        showTransactionStatus(false);
        Ui.showError(e.toString());
      }
    });
  }

  Future<void> addToBooking(int id) async {
    await dbRepo.addToBooking(id);
  }

  Future<OrderResponse?> createPaypalOrder(
    double amt, {
    String? variantId,
    int? quantity,
  }) async {
    try {
      return await dbRepo.createPaypalOrder({
        "amount": amt,
        if (variantId != null) "variantId": variantId,
        if (quantity != null) "quantity": quantity,
      });
    } catch (e) {
      return null;
    }
  }

  Future<void> getEsimVariants(String isocode) async {
    allEsimProducts.value = await dbRepo.apiWorker.getEsimVariants(isocode);
    setCurrentEsimProduct(1);
  }

  void setCurrentEsimProduct(int days) {
    currentEsimProduct.value = allEsimProducts.firstWhereOrNull(
      (e) => int.parse(e.days) == days,
    );
  }

  Future<void> sendOTP() async {
    final f = await dbRepo.apiWorker.getOTP();
    if (f) {
      Ui.showInfo("OTP Code sent");
    }
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      await dbRepo.apiWorker.verifyOTP(otp);
      return true;
    } catch (e) {
      Ui.showInfo("Invalid/Expired OTP Code");
      return false;
    }
  }
}
