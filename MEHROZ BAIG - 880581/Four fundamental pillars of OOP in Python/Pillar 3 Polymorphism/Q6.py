from abc import ABC, abstractmethod


class Notification(ABC):

  @abstractmethod
  def send(self, message):
    pass


class EmailNotification(Notification):

  def __init__(self, recipient_email):
    self.recipient_email = recipient_email

  def send(self, message):
    print(f"📧 Sending Email to {self.recipient_email}: '{message}'")


class SMSNotification(Notification):

  def __init__(self, phone_number):
    self.phone_number = phone_number

  def send(self, message):
    print(f"📱 Sending SMS to {self.phone_number}: '{message}'")


class PushNotification(Notification):

  def __init__(self, device_token):
    self.device_token = device_token

  def send(self, message):
    print(
        f"🔔 Sending Push Notification to Device [{self.device_token}]:"
        f" '{message}'"
    )


# --- Demonstration ---
if __name__ == "__main__":
  print("--- Q6: Notification System Demonstration ---")
  notifications = [
      EmailNotification("alice@work.com"),
      SMSNotification("+923001234567"),
      PushNotification("dev_token_xyz987"),
  ]

  alert_message = "Your system security update is complete."

  for notif in notifications:
    notif.send(alert_message)