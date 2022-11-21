import 'package:get/get.dart';
import 'package:getx/src/models/cart_item_model.dart';
import 'package:getx/src/models/order_model.dart';
import 'package:getx/src/pages/auth/controller/auth_controller.dart';
import 'package:getx/src/pages/orders/repository/orders_repository.dart';
import 'package:getx/src/pages/orders/result/orders_result.dart';
import 'package:getx/src/services/util_services.dart';

class OrderController extends GetxController {
  OrderModel order;

  OrderController(this.order);

  final orderRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utilServices = UtilsServices();
  bool isLoading = false;

  void setLoading(newValue) {
    isLoading = newValue;
    update();
  }

  Future<void> getOrderItems() async {
    setLoading(true);
    final OrdersResult<List<CartItemModel>> result = await orderRepository
        .getOrderItems(token: authController.user.token!, orderId: order.id);
    setLoading(false);

    result.when(success: (items) {
      order.items = items;
      update();
    }, error: (message) {
      utilServices.showToast(
        message: message,
        isError: true,
      );
    });
  }
}
