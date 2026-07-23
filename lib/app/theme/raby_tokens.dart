import 'package:flutter/material.dart';

abstract final class RabySpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const ms = 12.0;
  static const md = 16.0;
  static const ml = 20.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class RabyRadius {
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 22.0;
  static const xl = 28.0;
  static const hero = 34.0;
  static const pill = 999.0;
}

abstract final class RabyShadows {
  static const card = <BoxShadow>[
    BoxShadow(
      color: Color(0x0FAE761B),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
    BoxShadow(
      color: Color(0x0F81520A),
      blurRadius: 4,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  static const topEdge = <BoxShadow>[
    BoxShadow(
      color: Color(0x0FAE761B),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset(0, -2),
    ),
  ];
}
