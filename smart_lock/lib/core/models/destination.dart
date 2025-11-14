import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: 'Door', icon: Icons.meeting_room),
  Destination(label: 'Pin', icon: Icons.lock_open),
  Destination(label: 'Control', icon: Icons.bolt),
];
