// 路由管理
import 'package:flutter/material.dart';
import 'package:tsty_app/pages/main/index.dart';
import 'package:tsty_app/style/app_theme.dart';

// 返回App根组件
Widget myApp() {
  final AppTheme appTheme = AppTheme();

  return MaterialApp(
    theme: appTheme.light(),
    initialRoute: '/',
    routes: getRootRoutes(),
  );
}

Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {
    "/": (context) => MainPage(), // 主页路由
    //"/login": (context) => LoginPage(), // 登录页路由
  };
}
