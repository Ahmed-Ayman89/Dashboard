import 'package:flutter/material.dart';

class NavItem {
  final String title;
  final IconData icon;
  final Widget destination;

  const NavItem({
    required this.title,
    required this.icon,
    required this.destination,
  });
}
