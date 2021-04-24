import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class GetStorageBox extends GetxService {
  Future<GetStorage> init() async {
    await GetStorage.init();
    return GetStorage();
  }
}
