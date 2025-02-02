import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tlmc_player_app/models/application_pages.dart';

class ApplicationStates {
  ApplicationPages currentPage;
  GlobalKey<NavigatorState> currentNavigationKey;

  ApplicationStates(
      {required this.currentPage, required this.currentNavigationKey});
}

class ApplicationController extends GetxController
    with StateMixin<ApplicationStates> {
  final Map<ApplicationPages, GlobalKey<NavigatorState>> navigatorKeys;

  ApplicationController()
      : navigatorKeys = {
          ApplicationPages.home: GlobalKey<NavigatorState>(),
          ApplicationPages.explore: GlobalKey<NavigatorState>(),
          ApplicationPages.library: GlobalKey<NavigatorState>(),
        };

  @override
  void onInit() {
    super.onInit();
    changePage(ApplicationPages.home);
  }

  GlobalKey<NavigatorState>? getPageKey(ApplicationPages page) {
    return navigatorKeys[page];
  }

  GlobalKey<NavigatorState>? getCurrentPageKey() {
    return navigatorKeys[state!.currentPage];
  }

  void changePage(ApplicationPages page) {
    change(
        ApplicationStates(
            currentPage: page, currentNavigationKey: navigatorKeys[page]!),
        status: RxStatus.success());
  }

  String? getCurrentPath() {
    String? path;
    getCurrentPageKey()!.currentState!.popUntil((route) {
      path = route.settings.name;
      return true;
    });

    return path;
  }

  void navigateOrPopToRoute(String routeName) {
    final BuildContext? context = getCurrentPageKey()?.currentContext;
    if (context == null) return;

    bool canPop = Navigator.canPop(context);
    if (canPop) {
      // Attempt to pop to the route if it exists in the stack
      Navigator.popUntil(context, (route) {
        return route.settings.name == routeName;
      });
    } else {
      // If the route does not exist in the stack, push it
      Navigator.pushNamed(context, routeName);
    }
  }
}
