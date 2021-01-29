import 'dart:io';

import 'package:defichainwallet/crypto/database/wallet_database.dart';
import 'package:defichainwallet/crypto/database/wallet_db_sembast.dart';
import 'package:defichainwallet/network/account_service.dart';
import 'package:defichainwallet/network/balance_service.dart';
import 'package:defichainwallet/network/http_service.dart';
import 'package:defichainwallet/network/transaction_service.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';

import 'package:defichainwallet/util/sharedprefsutil.dart';
import 'package:defichainwallet/network/model/vault.dart';
import 'package:path_provider/path_provider.dart';
import 'network/api_service.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<SharedPrefsUtil>(() => SharedPrefsUtil());
  sl.registerLazySingleton<Vault>(() => Vault());
  sl.registerSingletonAsync<HttpService>(() async {
    var service = HttpService();
    await service.init();
    return service;
  });

  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => AccountService());
  sl.registerLazySingleton(() => TransactionService());
  sl.registerLazySingleton(() => BalanceService());

  sl.registerSingletonAsync<IWalletDatabase>(() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, "db", "wallet.db");
    var db = SembastWalletDatabase(path);
    await db.open();
    return db;
  });
}
