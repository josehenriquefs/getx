// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      item: ItemModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      id: json['id'] as String,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'product': instance.item,
      'quantity': instance.quantity,
      'id': instance.id,
    };
