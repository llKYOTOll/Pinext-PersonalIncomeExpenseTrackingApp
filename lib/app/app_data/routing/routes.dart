import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/screens/add_transaction/add_transaction.dart';
import 'package:pinext/app/screens/home/homeframe.dart';

import '../../screens/signin/signin_screen.dart';
import '../../screens/signup/signup_screen.dart';
import '../../screens/splash/splash_screen.dart';

class ROUTECONTROLLER {
  static Route<dynamic> routeController(RouteSettings settings) {
    switch (settings.name) {
      case ROUTES.getSplashRoute:
        return CustomTransitionPageRoute(
          childWidget: const SplashScreen(),
        );

      case ROUTES.getLoginRoute:
        return CustomTransitionPageRoute(
          childWidget: const SigninScreen(),
        );
      case ROUTES.getSignupRoute:
        return CustomTransitionPageRoute(
          childWidget: const SignupScreen(),
        );
      case ROUTES.getHomeframeRoute:
        return CustomTransitionPageRoute(
          childWidget: const Homeframe(),
        );
      case ROUTES.getAddTransactionsRoute:
        return CustomTransitionPageRoute(
          childWidget: AddTransactionScreen(),
        );
      default:
        log(settings.name.toString());
        throw ("Not a valid route ");
    }
  }
}

class ROUTES {
  static const getSplashRoute = '/';
  static const getLoginRoute = '/login';
  static const getSignupRoute = '/signup';
  static const getHomeframeRoute = '/homeframe';
  static const getAddTransactionsRoute = '/homeframe/add_transactions';
  // static const getAddPinextCardRoute = '/homeframe/add_pinext_card';
}
