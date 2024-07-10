import 'package:flutter/material.dart';
import 'package:veneza/named_routes.dart';
import 'package:veneza/screens/auth/login.dart';
import 'package:veneza/screens/home/home.dart';
import 'package:veneza/screens/atendente/adm/pizza.dart';

Map<String, Widget Function(BuildContext)> routes = {
  LoginViewRoute: (p0) => const LoginPage(),
  InitialViemRoute: (p0) => const HomePage(),
  PizzaViewRoute:(p0) => const PizzaPage(),
};