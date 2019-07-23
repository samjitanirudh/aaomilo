import 'dart:async';


class NotificationItem {
  NotificationItem({this.notificationItem});
  final String notificationItem;

  StreamController<NotificationItem> _controller = StreamController<NotificationItem>.broadcast();
  Stream<NotificationItem> get onChanged => _controller.stream;

  String _status;
  String get data => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }
}