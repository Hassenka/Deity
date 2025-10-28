import 'dart:async';
import 'package:diety/presentation/screens/internet/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onReconnect;

  const InternetConnectionWrapper({
    super.key,
    required this.child,
    this.onReconnect,
  });

  @override
  State<InternetConnectionWrapper> createState() =>
      _InternetConnectionWrapperState();
}

class _InternetConnectionWrapperState extends State<InternetConnectionWrapper> {
  late final StreamSubscription<InternetStatus> _subscription;
  InternetStatus _currentStatus =
      InternetStatus.connected; // Assume connected initially
  late final InternetConnection _internetConnection;

  @override
  void initState() {
    super.initState();
    // Create a default instance of InternetConnection (remove custom options
    // because AddressCheckOptions isn't available/imported).
    _internetConnection = InternetConnection.createInstance();
    _subscription = _internetConnection.onStatusChange.listen((
      InternetStatus status,
    ) {
      final wasOffline = _currentStatus == InternetStatus.disconnected;
      final isNowOnline = status == InternetStatus.connected;

      if (mounted) {
        setState(() {
          _currentStatus = status;
        });

        if (wasOffline && isNowOnline) {
          widget.onReconnect?.call();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = _currentStatus == InternetStatus.disconnected;
    return Stack(
      children: [
        widget.child,
        if (isOffline)
          const Positioned.fill(
            child: SelectionContainer.disabled(child: NoInternetScreen()),
          ),
      ],
    );
  }
}
