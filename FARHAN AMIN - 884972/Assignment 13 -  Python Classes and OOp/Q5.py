class EmailNotification:
    def send(self, message):
        print(f"📧 Sending Email: {message}")

class SMSNotification:
    def send(self, message):
        print(f"💬 Sending SMS: {message}")

class PushNotification:
    def send(self, message):
        print(f"🔔 Sending Push Notification: {message}")

# Extension: Adding WhatsAppNotification without changing the dispatcher
class WhatsAppNotification:
    def send(self, message):
        print(f"🟢 Sending WhatsApp Message: {message}")

# Single dispatcher function working with any notification object
def notify_all(notifications, message):
    for notification in notifications:
        notification.send(message)  # Polymorphism occurs here

# --- Test Cases ---
print("--- Testing Notification Dispatcher ---")

notification_list = [
    EmailNotification(),
    SMSNotification(),
    PushNotification(),
    WhatsAppNotification()  # Plugged in seamlessly
]

msg = "Your OTP code is 1234. Do not share it."
notify_all(notification_list, msg)
