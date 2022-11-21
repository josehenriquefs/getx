import 'package:getx/src/constants/endpoints.dart';
import 'package:getx/src/models/category_model.dart';
import 'package:getx/src/models/item_model.dart';
import 'package:getx/src/services/http_manager.dart';

import '../result/home_result.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllCategories, method: HttpMethods.post);
    if (result['result'] != null) {
      // Lista
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();

      return HomeResult<CategoryModel>.success(data);
    } else {
      // Erro
      return HomeResult<CategoryModel>.error(
          'Ocorreu um erro inesperado ao recuperar as categorias');
    }
  }

  Future<HomeResult<ItemModel>> getAllProducts(
      Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.searchProducts,
      method: HttpMethods.post,
      body: body,
    );
    if (result['result'] != null) {
      List<ItemModel> data = List<Map<String, dynamic>>.from(result['result'])
          .map(ItemModel.fromJson)
          .toList();
      return HomeResult<ItemModel>.success(data);
    } else {
      return HomeResult.error(
          'Ocorreu um erro inesperado ao recuperar os itens');
    }
  }
}