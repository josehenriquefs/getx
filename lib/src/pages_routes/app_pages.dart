import 'package:get/get.dart';
import 'package:getx/src/pages/auth/views/sign_in_screen.dart';
import 'package:getx/src/pages/auth/views/sign_up_screen.dart';
import 'package:getx/src/pages/base/base_screen.dart';
import 'package:getx/src/pages/base/binding/navigation_binding.dart';
import 'package:getx/src/pages/cart/binding/cart_binding.dart';
import 'package:getx/src/pages/home/binding/home_binding.dart';
import 'package:getx/src/pages/orders/binding/orders_binding.dart';
import 'package:getx/src/pages/product/product_screen.dart';
import 'package:getx/src/pages/splash/splash_screen.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      page: () => const SplashScreen(),
      name: PagesRoute.splashRoute,
    ),
    GetPage(
      page: () => SignInScreen(),
      name: PagesRoute.signInRoute,
    ),
    GetPage(
      page: () => SignUpScreen(),
      name: PagesRoute.signUpRoute,
    ),
    GetPage(
      page: () => const BaseScreen(),
      name: PagesRoute.baseRoute,
      bindings: [
        NavigationBinding(),
        HomeBinding(),
        CartBinding(),
        OrdersBinding(),
      ],
    ),
    GetPage(
      page: () => ProductScreen(),
      name: PagesRoute.productRoute,
    ),
  ];
}

abstract class PagesRoute {
  static const String splashRoute = '/splash';
  static const String signInRoute = '/signin';
  static const String signUpRoute = '/signup';
  static const String baseRoute = '/';
  static const String homeRoute = '/home';
  static const String productRoute = '/product';
}
