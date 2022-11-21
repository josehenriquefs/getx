import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/src/pages/base/controller/navigation_controller.dart';
import 'package:getx/src/pages/cart/controller/cart_controller.dart';
import 'package:getx/src/pages/home/controller/home_controller.dart';
import 'package:getx/src/pages/home/view/components/category_tile.dart';
import 'package:getx/src/pages/home/view/components/item_tile.dart';
import 'package:getx/src/pages/widgets/custom_shimmer.dart';
import 'package:getx/src/services/util_services.dart';

import '../../../config/custom_colors.dart';
import '../../widgets/app_name_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final UtilsServices utilsServices = UtilsServices();

  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();

  late Function(GlobalKey) runAddToCartAnimation;

  void itemSelectedCartAnimations(GlobalKey gkImage) {
    runAddToCartAnimation(gkImage);
  }

  final searchController = TextEditingController();
  final navController = Get.find<NavigationController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: GetBuilder<CartController>(
              builder: (cartController) {
                return GestureDetector(
                  onTap: () =>
                      navController.navigatePageView(NavigationTabs.cart),
                  child: Badge(
                    badgeColor: CustomColors.customContrastColor,
                    badgeContent: Text(
                      cartController.cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    child: AddToCartIcon(
                      key: globalKeyCartItems,
                      icon: Icon(
                        Icons.shopping_cart,
                        color: CustomColors.customSwatchColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),

      // Campo pesquisa
      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 50),
        previewCurve: Curves.easeInOutQuad,
        receiveCreateAddToCardAnimationMethod: (addToCartAnimationMethod) {
          runAddToCartAnimation = addToCartAnimationMethod;
        },
        child: Column(
          children: [
            // Barra de pesquisa
            GetBuilder<HomeController>(
              builder: (homeController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (newValue) {
                      homeController.searchTitle.value = newValue;
                    },
                    decoration: InputDecoration(
                      suffixIcon: homeController.searchTitle.value.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                homeController.searchTitle.value = '';
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(
                                Icons.close,
                                color: CustomColors.customContrastColor,
                                size: 21,
                              ),
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      hintText: 'Pesquise Aqui',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CustomColors.customContrastColor,
                        size: 21,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            //Categorias
            GetBuilder<HomeController>(
              builder: (homeController) {
                return Container(
                  padding: const EdgeInsets.only(left: 25),
                  height: 40,
                  child: !homeController.isCategoryLoading
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return CategoryTile(
                              onPressed: () {
                                homeController.selectCategory(
                                    homeController.allCategories[index]);
                              },
                              category:
                                  homeController.allCategories[index].title,
                              isSelected: homeController.allCategories[index] ==
                                  homeController.currentCategory,
                            );
                          },
                          separatorBuilder: (_, index) => Container(
                                width: 10,
                                padding: const EdgeInsets.only(left: 25),
                              ),
                          itemCount: homeController.allCategories.length)
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            6,
                            (index) => Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 12),
                              child: CustomShimmer(
                                height: 25,
                                width: 80,
                                borderRadius: BorderRadius.circular(20),
                                isRounded: true,
                              ),
                            ),
                          ),
                        ),
                );
              },
            ),
            //Grid
            GetBuilder<HomeController>(
              builder: (homeController) {
                return Expanded(
                  child: !homeController.isProductLoading
                      ? Visibility(
                          visible: (homeController.currentCategory?.items ?? [])
                              .isNotEmpty,
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 9 / 11.5),
                            itemCount: homeController.allProducts.length,
                            itemBuilder: (_, index) {
                              if (((index + 1) ==
                                      homeController.allProducts.length) &&
                                  !homeController.isLastPage) {
                                homeController.loadMoreProducts();
                              }
                              return ItemTile(
                                  item: homeController.allProducts[index],
                                  cartAnimationMethod:
                                      itemSelectedCartAnimations);
                            },
                          ),
                          replacement: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 40,
                                color: CustomColors.customSwatchColor,
                              ),
                              Text('Não há itens para apresentar')
                            ],
                          ),
                        )
                      : GridView.count(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 9 / 11.5,
                          children: List.generate(
                            10,
                            (index) => CustomShimmer(
                                height: double.infinity,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
