import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/src/models/cart_item_model.dart';
import 'package:getx/src/models/item_model.dart';
import 'package:getx/src/models/order_model.dart';
import 'package:getx/src/pages/auth/controller/auth_controller.dart';
import 'package:getx/src/pages/cart/repository/cart_repository.dart';
import 'package:getx/src/pages/cart/result/cart_result.dart';
import 'package:getx/src/pages/widgets/payment_dialog.dart';
import 'package:getx/src/services/util_services.dart';

class CartController extends GetxController {
  bool isCheckoutLoading = false;

  final cartRepository = CartRepository();

  final authController = Get.find<AuthController>();
  final utilServices = UtilsServices();

  List<CartItemModel> cartItems = [];

  void setCheckoutLoading(bool newValue) {
    isCheckoutLoading = newValue;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getCartItems();
  }

  double cartTotalPrice() {
    double total = 0;
    for (final item in cartItems) {
      total += item.totalPrice();
    }
    return total;
  }

  Future checkoutCart() async {
    setCheckoutLoading(true);

    CartResult<OrderModel> result = await cartRepository.checkoutCart(
        token: authController.user.token!, total: cartTotalPrice());

    setCheckoutLoading(false);

    result.when(success: (order) {
      cartItems.clear();
      update();

      showDialog(
          context: Get.context!,
          builder: (_) {
            return PaymentDialog(
              order: order,
            );
          });
    }, error: (message) {
      utilServices.showToast(message: message, isError: true);
    });
  }

  Future<bool> changeItemQuantity({
    required CartItemModel item,
    required int quantity,
  }) async {
    final result = await cartRepository.changeItemQuantity(
        token: authController.user.token!,
        cartItemId: item.id,
        quantity: quantity);

    if (result) {
      if (quantity == 0) {
        cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      } else {
        cartItems.firstWhere((cartItem) => cartItem.id == item.id).quantity =
            quantity;
      }
      update();
    } else {
      utilServices.showToast(
        message: 'Ocorreu um erro ao alterar a quantidade do produto',
        isError: true,
      );
    }

    return result;
  }

  Future<void> getCartItems() async {
    final CartResult<List<CartItemModel>> result =
        await cartRepository.getCartItems(
      token: authController.user.token!,
      userId: authController.user.id!,
    );

    result.when(success: (data) {
      cartItems = data;
      update();
    }, error: (message) {
      utilServices.showToast(message: message, isError: true);
    });
  }

  int getItemIndex(ItemModel item) {
    return cartItems.indexWhere((itemInList) => itemInList.item.id == item.id);
  }

  Future<void> addItemToCart(
      {required ItemModel item, int quantity = 1}) async {
    int itemIndex = getItemIndex(item);
    if (itemIndex >= 0) {
      final product = cartItems[itemIndex];

      await changeItemQuantity(
          item: product, quantity: (product.quantity + quantity));
    } else {
      final CartResult<String> result = await cartRepository.addItemToCart(
          userId: authController.user.id!,
          token: authController.user.token!,
          productId: item.id,
          quantity: quantity);

      result.when(
        success: (cartItemId) {
          cartItems.add(
            CartItemModel(item: item, quantity: quantity, id: cartItemId),
          );
          update();
        },
        error: (message) {
          utilServices.showToast(
            message: message,
            isError: true,
          );
        },
      );
    }
  }
}
