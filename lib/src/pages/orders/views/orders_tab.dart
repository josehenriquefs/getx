import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/src/pages/orders/controller/all_orders_controller.dart';
import 'package:getx/src/pages/orders/views/components/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (ordersController) {
          return RefreshIndicator(
            onRefresh: () => ordersController.getAllOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: ordersController.allOrders.length,
              itemBuilder: (_, index) => OrderTile(
                order: ordersController.allOrders[index],
              ),
              separatorBuilder: (_, index) => const SizedBox(
                height: 10,
              ),
            ),
          );
        },
      ),
    );
  }
}
