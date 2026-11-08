# Q5: Notification Dispatcher - Polymorphism

class EmailNotification:
    def send(self, message):
        print(f"EMAIL: {message}")


class SMSNotification:
    def send(self, message):
        print(f"SMS: {message}")


class PushNotification:
    def send(self, message):
        print(f"PUSH NOTIFICATION: {message}")


class WhatsAppNotification:
    def send(self, message):
        print(f"WHATSAPP: {message}")


def notify_all(notifications, message):
    """Send the same message through any objects with a send() method."""
    for notification in notifications:
        notification.send(message)


if __name__ == "__main__":
    notification_services = [
        EmailNotification(),
        SMSNotification(),
        PushNotification(),
        WhatsAppNotification()
    ]

    notify_all(notification_services, "Your order has been shipped.")

    # Polymorphism occurs when notify_all() calls the same send() method
    # on different object types. WhatsApp was added without changing the
    # dispatcher function.
