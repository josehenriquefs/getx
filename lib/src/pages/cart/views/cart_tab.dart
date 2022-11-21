import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/src/config/custom_colors.dart';
import 'package:getx/src/pages/cart/controller/cart_controller.dart';
import 'package:getx/src/pages/cart/views/components/cart_tile.dart';
import 'package:getx/src/services/util_services.dart';

class CartTab extends StatefulWidget {
  const CartTab({Key? key}) : super(key: key);

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilsServices utilServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          // Produtos
          Expanded(
            child: GetBuilder<CartController>(
              builder: (cartController) {
                if (cartController.cartItems.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_shopping_cart,
                        size: 40,
                        color: CustomColors.customSwatchColor,
                      ),
                      const Text('Não há itens no carrinho'),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (_, index) {
                    return CartTile(
                      cartItem: cartController.cartItems[index],
                    );
                  },
                );
              },
            ),
          ),
          // Finalizar pedido
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total geral',
                  style: TextStyle(fontSize: 14),
                ),
                GetBuilder<CartController>(
                  builder: (cartController) {
                    return Text(
                      utilServices
                          .priceToCurrency(cartController.cartTotalPrice()),
                      style: TextStyle(
                        fontSize: 22,
                        color: CustomColors.customSwatchColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                  child: GetBuilder<CartController>(
                    builder: (cartController) {
                      return ElevatedButton(
                        onPressed: (cartController.isCheckoutLoading ||
                                cartController.cartItems.isEmpty)
                            ? null
                            : () async {
                                bool? result = await showOrderConfirmation();
                                if (result ?? false) {
                                  cartController.checkoutCart();
                                } else {
                                  utilServices.showToast(
                                      message: 'Pedido não confirmado',
                                      isError: true);
                                }
                              },
                        child: cartController.isCheckoutLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Concluir Pedido',
                                style: TextStyle(fontSize: 18),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.customSwatchColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Confirmação'),
            content: const Text('Deseja realmente concluir o pedido?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Não'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sim'),
              ),
            ],
          );
        });
  }
}
