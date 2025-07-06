import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

// The provider of the app's theme
final themeProvider = StateProvider<ThemeMode>((ref)=> ThemeMode.dark);