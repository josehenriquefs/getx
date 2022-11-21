import 'package:flutter/material.dart';
import 'package:getx/src/config/custom_colors.dart';

class QuantityWidget extends StatelessWidget {
  final int value;
  final String suffixText;
  final Function(int quantity) result;
  final bool isRemovable;

  const QuantityWidget(
      {Key? key,
      required this.result,
      required this.suffixText,
      this.isRemovable = false,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Remover
          _QuantityButton(
              icon: !isRemovable || value > 1
                  ? Icons.remove
                  : Icons.delete_forever,
              color: !isRemovable || value > 1 ? Colors.grey : Colors.red,
              onPressed: () {
                if (value == 1 && !isRemovable) return;
                int resultCount = value - 1;
                result(resultCount);
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$value$suffixText',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          // Adicionar
          _QuantityButton(
              icon: Icons.add,
              color: CustomColors.customSwatchColor,
              onPressed: () {
                int resultCount = value + 1;
                result(resultCount);
              }),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton(
      {Key? key,
      required this.icon,
      required this.color,
      required this.onPressed})
      : super(key: key);

  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressed,
        child: Ink(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
