import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveListToShared(List<String> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('\n\ntotal value saveListToShared: $list\n\n');
  return list != null && list.length > 0
      ? await prefs.setStringList("savedList", list)
      : false;
}

Future<bool> updateSavedListAtShared(List<String> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('\n\ntotal value updateSavedListAtShared: $list\n\n');
  return list != null && list.length > 0
      ? await prefs.remove("savedList").then((removed) async {
          if (removed)
            return await prefs.setStringList("savedList", list);
          else
            return false;
        })
      : false;
}

Future<List<String>> getListFromShared() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getStringList("savedList") ?? List<String>();
}

Future removeListFromShared() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("savedList");
  await prefs.remove("totalPrice");
  await prefs.remove("userHasCards");
}

Future<double> getTotalPrice() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble("totalPrice") ?? 0.0;
}

Future<bool> addTotalPrice(double totalPrice) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setDouble("totalPrice", totalPrice).then((isSaved) async {
    if (isSaved) await prefs.setBool("userHasCards", true);
  });

  return await prefs.setDouble("totalPrice", totalPrice) ?? false;
}

Future<bool> addPaymentMethodName(String paymentName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString("paymentName", paymentName) ?? false;
}

Future<String> getPaymentMethodName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("paymentName");
}

Future<String> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<bool> clearShared() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}
