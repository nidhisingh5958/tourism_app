import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_mate/screens/chat/chat.dart';
import 'package:travel_mate/screens/chat/chat_home.dart';
import 'package:travel_mate/screens/components/notifications.dart';
import 'package:travel_mate/screens/history.dart' show HistoryScreen;
import 'package:travel_mate/screens/home.dart';
import 'package:travel_mate/screens/voice_assistant/voice_assistant.dart';
import 'package:travel_mate/services/router_constants.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      name: RouteConstants.home,
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/notifications',
          name: RouteConstants.notifications,
          builder: (BuildContext context, GoRouterState state) {
            return NotificationScreen();
          },
        ),
        GoRoute(
          path: '/voiceAssistant',
          name: RouteConstants.voiceAssistant,
          builder: (BuildContext context, GoRouterState state) {
            return VoiceAssistantScreen();
          },
        ),
        GoRoute(
          path: '/chat_home',
          name: RouteConstants.chatHome,
          builder: (BuildContext context, GoRouterState state) {
            return ChatHome();
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/chat',
              name: RouteConstants.chat,
              builder: (BuildContext context, GoRouterState state) {
                return ChatScreen();
              },
            ),
          ],
        ),

        GoRoute(
          path: '/history',
          name: RouteConstants.history,
          builder: (BuildContext context, GoRouterState state) {
            return HistoryScreen();
          },
        ),
      ],
    ),
    // GoRoute(
    //   path: '/settings',
    //   name: RouteConstants.settings,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return SettingsScreen();
    //   },
    // ),
  ],
);
