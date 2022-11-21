import 'package:get/get.dart';
import 'package:getx/src/models/order_model.dart';
import 'package:getx/src/pages/auth/controller/auth_controller.dart';
import 'package:getx/src/pages/orders/repository/orders_repository.dart';
import 'package:getx/src/pages/orders/result/orders_result.dart';
import 'package:getx/src/services/util_services.dart';

class AllOrdersController extends GetxController {
  List<OrderModel> allOrders = [];
  final ordersRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utilServices = UtilsServices();

  @override
  void onInit() {
    super.onInit();
    getAllOrders();
  }

  Future<void> getAllOrders() async {
    OrdersResult<List<OrderModel>> result = await ordersRepository.getAllOrders(
      token: authController.user.token!,
      userId: authController.user.id!,
    );

    result.when(
      success: (orders) {
        allOrders = orders
          ..sort((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));
        update();
      },
      error: (message) {
        utilServices.showToast(message: message, isError: true);
      },
    );
  }
}
