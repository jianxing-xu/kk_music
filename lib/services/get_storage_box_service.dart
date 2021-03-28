import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class GetStoreageBox extends GetxService {
  Future<GetStorage> init() async {
    return GetStorage();
  }
}
