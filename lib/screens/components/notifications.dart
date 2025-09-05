import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import 'package:travel_mate/screens/components/colors.dart';
import 'package:travel_mate/services/router_constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          // Background with gradient blobs and blur (matching home screen)
          Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // Gradient Blobs
                Positioned(
                  top: -100,
                  left: -60,
                  child: _buildBlob(const [
                    Color(0xFFd4145a),
                    Color(0xFFfbb03b),
                  ], 300),
                ),
                Positioned(
                  top: 800,
                  right: -100,
                  child: _buildBlob(const [
                    Color(0xFF662d8c),
                    Color(0xFFd4145a),
                  ], 250),
                ),

                // Blur Layer
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
                  child: Container(color: black.withOpacity(0.25)),
                ),
              ],
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '5 new travel updates',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'settings') {
                            Navigator.pushNamed(
                              context,
                              RouteConstants.profileSettings,
                            );
                          } else if (value == 'clear') {
                            // Handle clear all action
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'settings',
                            child: Text('Settings'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'clear',
                            child: Text('Clear all'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable notifications
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'Today',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return _NotificationCard(
                            notification: _demoTravelNotifications[index],
                          );
                        }, childCount: _demoTravelNotifications.length),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(List<Color> colors, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors,
          center: Alignment.center,
          radius: 0.7,
        ),
      ),
    );
  }
}

class TravelNotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final TravelNotificationType type;
  final bool isRead;

  TravelNotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

enum TravelNotificationType { flight, hotel, activity, safety, weather, visa }

extension TravelNotificationTypeExtension on TravelNotificationType {
  IconData get icon {
    switch (this) {
      case TravelNotificationType.flight:
        return Icons.flight_takeoff;
      case TravelNotificationType.hotel:
        return Icons.hotel;
      case TravelNotificationType.activity:
        return Icons.local_activity;
      case TravelNotificationType.safety:
        return Icons.shield;
      case TravelNotificationType.weather:
        return Icons.wb_cloudy;
      case TravelNotificationType.visa:
        return Icons.card_travel;
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case TravelNotificationType.flight:
        return [const Color(0xFFd4145a), const Color(0xFF662d8c)];
      case TravelNotificationType.hotel:
        return [const Color(0xFF662d8c), const Color(0xFFfbb03b)];
      case TravelNotificationType.activity:
        return [const Color(0xFFfbb03b), const Color(0xFFd4145a)];
      case TravelNotificationType.safety:
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case TravelNotificationType.weather:
        return [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
      case TravelNotificationType.visa:
        return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final TravelNotificationItem notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: GestureDetector(
        onTap: () {
          // Handle notification tap
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: notification.type.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  notification.type.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatTime(notification.time),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: notification.type.gradientColors.first,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle view action
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: notification.type.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'View',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day) {
      return DateFormat('HH:mm').format(time);
    } else {
      return DateFormat('MMM d, HH:mm').format(time);
    }
  }
}

// Demo travel notifications data
final List<TravelNotificationItem> _demoTravelNotifications = [
  TravelNotificationItem(
    title: 'Flight Check-in Available',
    message:
        'Check-in is now open for your flight to Paris (AF 1234) departing tomorrow at 10:30 AM. Check in now to secure your seat.',
    time: DateTime.now().subtract(const Duration(minutes: 15)),
    type: TravelNotificationType.flight,
  ),
  TravelNotificationItem(
    title: 'Hotel Booking Confirmed',
    message:
        'Your reservation at Hotel Le Marais has been confirmed. Check-in: Dec 15, 3:00 PM. Confirmation: #HLM789123',
    time: DateTime.now().subtract(const Duration(hours: 1)),
    type: TravelNotificationType.hotel,
    isRead: false,
  ),
  TravelNotificationItem(
    title: 'Weather Alert - Paris',
    message:
        'Rain expected in Paris during your visit (Dec 15-18). Pack an umbrella and waterproof jacket for outdoor activities.',
    time: DateTime.now().subtract(const Duration(hours: 2)),
    type: TravelNotificationType.weather,
  ),
  TravelNotificationItem(
    title: 'Travel Safety Update',
    message:
        'Current safety level in Paris: Low Risk. No travel advisories in effect. Emergency contacts have been updated in your profile.',
    time: DateTime.now().subtract(const Duration(hours: 4)),
    type: TravelNotificationType.safety,
    isRead: true,
  ),
  TravelNotificationItem(
    title: 'Activity Recommendation',
    message:
        'Based on your preferences, we recommend booking the Louvre Museum skip-the-line tour. 20% discount available until Dec 10.',
    time: DateTime.now().subtract(const Duration(hours: 6)),
    type: TravelNotificationType.activity,
    isRead: false,
  ),
  TravelNotificationItem(
    title: 'Visa Reminder',
    message:
        'Your Schengen visa expires in 60 days. Consider renewing if you have future travel plans to Europe.',
    time: DateTime.now().subtract(const Duration(days: 1)),
    type: TravelNotificationType.visa,
    isRead: true,
  ),
  TravelNotificationItem(
    title: 'Flight Delay Notification',
    message:
        'Your return flight (AF 4321) has been delayed by 45 minutes. New departure time: 2:15 PM. Gate B12.',
    time: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    type: TravelNotificationType.flight,
    isRead: true,
  ),
  TravelNotificationItem(
    title: 'Hotel Upgrade Available',
    message:
        'Complimentary room upgrade to Junior Suite available for your stay. Contact hotel reception to confirm.',
    time: DateTime.now().subtract(const Duration(days: 2)),
    type: TravelNotificationType.hotel,
    isRead: true,
  ),
];
