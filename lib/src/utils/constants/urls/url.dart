abstract class AppUrls {
  static const String baseURL = 'https://dettyprod.archyuniq.com';
  static const String auth = "/auth";
  static const String profile = "/profile";
  static const String finance = "/finance";
  static const String category = "/category";
  static const String utils = "/utils";
  static const String extras = "/extras";

//auth repo
  static const String login = "$auth/login";
  static const String loginSocial = "$auth/login-social";
  static const String logout = "$auth/logout";
  static const String register = "$auth/register";
  static const String forgotPassword = "$auth/forgot-password";

  //profile repo
  static const String getUser = "$profile/user";
  static const String getProfile = "$profile/user/p";
  static const String refreshToken = "$profile/refresh-token";
  static const String changePassword = "$profile/reset-password";
  static const String favourites = "$profile/favourites";
  static const String favouritesAdd = "$profile/favourites/add";
  static const String favouritesRemove = "$profile/favourites/remove";

  //finance repo
  static const String wallet = "$finance/wallets";
  static const String bank = "$finance/banks";
  static const String card = "$finance/cards";
  static const String transaction = "$finance/transactions";

  //category repo
  static const String categories = "$category/categories";
  static const String categoryItem = "$category/category-items-search";
  static const String categoryItemRaw = "$category/category-items";
  static const String review = "$category/reviews";

  //utils repo
  static const String location = "$utils/locations";
  static const String appinfo = "$utils/appinfos";
  static const String upload = "$utils/upload";

  //extras repo
  static const String flights = "$extras/flights";
  static const String visa = "$extras/visa";

  //ads
  static const String ads = "/ads";

  //esim
  static const String esim = "/esims/user/active";

  //chat repo
  static const String chat = "/chat";

  //bookings repo
  static const String booking = "$profile/bookings";
}
