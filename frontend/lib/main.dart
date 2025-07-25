import 'dart:io'; // For platform check
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'theme.dart';
import 'screens/dashboard_screen.dart';

// Initialize Flutter Local Notifications
final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

/// Background network monitoring callback
Future<void> backgroundNetworkMonitorTask() async {
  debugPrint("Background task triggered.");
  await showNotification();
}

/// Function to show a notification
Future<void> showNotification() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'network_monitor_channel', // Channel ID
    'Network Monitoring', // Channel name
    channelDescription: 'Alerts for suspicious network activity',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

  await notificationsPlugin.show(
    0, // Notification ID
    'Network Alert', // Title
    'Suspicious activity detected on the network.', // Body
    notificationDetails,
  );
}

/// Callback dispatcher for iOS WorkManager
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await backgroundNetworkMonitorTask();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Conditionally initialize plugins
  if (Platform.isAndroid) {
    // Android-specific initialization
    await AndroidAlarmManager.initialize();
  }
  if (Platform.isIOS) {
    // iOS-specific initialization
    Workmanager().initialize(callbackDispatcher);
  }

  // Initialize Flutter Local Notifications
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  await notificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

// ThemeProvider for light/dark mode switching
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Tshella Security',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode, // Uses the current theme mode
            home: DashboardScreen(),
          );
        },
      ),
    );
  }
}
