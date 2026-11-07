# Q5. Notification Dispatcher (Polymorphism - Beginner)


class EmailNotification:
    def send(self, message):
        print(f"  [EMAIL]    To: user@example.com | Body: {message}")


class SMSNotification:
    def send(self, message):
        print(f"  [SMS]      To: +92-300-1234567 | Text: {message}")


class PushNotification:
    def send(self, message):
        print(f"  [PUSH]     To: mobile-app | Alert: {message}")


class WhatsAppNotification:
    def send(self, message):
        print(f"  [WHATSAPP] To: +92-300-1234567 | Chat: {message}")


def notify_all(notifications, message):
    for notification in notifications:
        notification.send(message)


if __name__ == "__main__":
    print("=== Dispatcher with original three channels ===")
    channels = [EmailNotification(), SMSNotification(), PushNotification()]
    notify_all(channels, "Your order has been shipped!")

    print("\n=== WhatsAppNotification added WITHOUT changing notify_all ===")
    channels.append(WhatsAppNotification())
    notify_all(channels, "Your order has been shipped!")

    print("\n=== Where does polymorphism occur? ===")
    print("  In notify_all(): the loop calls .send(message) on each object without")
    print("  knowing its concrete class. Each class provides its own implementation")
    print("  of send(), so the same call produces channel-specific behaviour.")
    print("  This is duck typing / polymorphism in action - new notification classes")
    print("  work with the dispatcher as long as they implement send(message).")
