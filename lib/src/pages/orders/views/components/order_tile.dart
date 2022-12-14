import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/src/config/custom_colors.dart';
import 'package:getx/src/models/cart_item_model.dart';
import 'package:getx/src/models/order_model.dart';
import 'package:getx/src/pages/orders/controller/order_controller.dart';
import 'package:getx/src/pages/orders/views/components/order_status_widget.dart';
import 'package:getx/src/pages/widgets/payment_dialog.dart';
import 'package:getx/src/services/util_services.dart';

class OrderTile extends StatelessWidget {
  OrderTile({Key? key, required this.order}) : super(key: key);

  final OrderModel order;

  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: GetBuilder<OrderController>(
          init: OrderController(order),
          global: false,
          builder: (orderController) {
            return ExpansionTile(
              onExpansionChanged: (value) {
                if (value && order.items.isEmpty) {
                  orderController.getOrderItems();
                }
              },
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido: ${order.id}',
                    style: TextStyle(color: CustomColors.customSwatchColor),
                  ),
                  Text(
                    utilsServices.formatDateTime(order.createdDateTime!),
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  )
                ],
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              children: orderController.isLoading
                  ? [
                      Container(
                        height: 80,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    ]
                  : [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            // Lista de Produtos
                            Expanded(
                              child: SizedBox(
                                height: 150,
                                child: ListView(
                                  children: order.items.map((orderItem) {
                                    return _OrderItemWidget(
                                      utilsServices: utilsServices,
                                      orderItem: orderItem,
                                    );
                                  }).toList(),
                                ),
                              ),
                              flex: 3,
                            ),
                            // Divis??o
                            VerticalDivider(
                              color: Colors.grey.shade300,
                              thickness: 2,
                              width: 8,
                            ),
                            // Status do Pedido
                            Expanded(
                              child: OrderStatusWidget(
                                isOverdue: order.overdueDateTime
                                    .isBefore(DateTime.now()),
                                status: order.status,
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                      // Total
                      Text.rich(
                        TextSpan(
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Total ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    utilsServices.priceToCurrency(order.total),
                              ),
                            ]),
                      ),
                      // Bot??o pagamento
                      Visibility(
                        visible: order.status == 'pending_payment' &&
                            !order.isOverdue,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return PaymentDialog(
                                    order: order,
                                  );
                                });
                          },
                          label: const Text('Ver QR Code Pix'),
                          icon: Image.asset(
                            'assets/app_images/pix.png',
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                    ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  const _OrderItemWidget({
    Key? key,
    required this.utilsServices,
    required this.orderItem,
  }) : super(key: key);

  final UtilsServices utilsServices;
  final CartItemModel orderItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '${orderItem.quantity} ${orderItem.item.unit} ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(orderItem.item.itemName)),
          Text(
            utilsServices.priceToCurrency(
              orderItem.totalPrice(),
            ),
          ),
        ],
      ),
    );
  }
}
