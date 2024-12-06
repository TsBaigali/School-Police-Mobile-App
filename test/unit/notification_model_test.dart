import 'package:flutter_test/flutter_test.dart';
import 'package:school_police/models/notification.dart';

void main() {
  test('NotificationModel should assign values correctly', () {
    final notification = NotificationModel(
      id: '1',
      title: 'New Alert',
      message: 'This is a test notification',
      time: '2024-12-06 10:00',
      imageUrl: 'https://example.com/image.png',
    );
    expect(notification.id, '1');
    expect(notification.title, 'New Alert');
    expect(notification.message, 'This is a test notification');
  });
}
