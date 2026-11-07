"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assignment   : Assignment 13 - Python Classes and OOP
Pillar 3     : Polymorphism
Question 5   : Notification Dispatcher | Beginner
=============================================================================
"""

# Channel 1: Email Notification
class EmailNotification:
    def send(self, message: str):
        print(f"[Email Notification] User ke email inbox me send hua -> '{message}'")


# Channel 2: SMS Notification
class SMSNotification:
    def send(self, message: str):
        print(f"[SMS Notification] Cellular SMS phone par send hua -> '{message}'")


# Channel 3: Push Notification
class PushNotification:
    def send(self, message: str):
        print(f"[Push Notification] Mobile screen par popup alert aaya -> '{message}'")


# Single Dispatcher Function (Polymorphism ka asal jaadu yahan hai)
# Basic loop chala kar sab notification channels ko message bhejna
def notify_all(notifications, message: str):
    """
    Polymorphic Dispatcher:
    Is loop ko farq nahi padta ke object Email hai, SMS hai ya WhatsApp.
    Ye sirf har object ka .send() method call karta hai.
    """
    for notifier in notifications:
        notifier.send(message)


# Extension: Nayi WhatsApp notification class add ki bina dispatcher badle
class WhatsAppNotification:
    def send(self, message: str):
        print(f"[WhatsApp Notification] Encrypted WhatsApp chat ping gaya -> '{message}'")


# =============================================================================
# Testing & Demonstration
# =============================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("PILLAR 3 - Q5: NOTIFICATION DISPATCHER (POLYMORPHISM)")
    print("Student: TALHA KHAN | Roll No: 873676")
    print("=" * 70)

    # Tamam channels ki list banayi (WhatsApp extension samait)
    channel_list = [
        EmailNotification(),
        SMSNotification(),
        PushNotification(),
        WhatsAppNotification()  # Naya channel seamlessly add ho gaya
    ]

    broadcast_msg = "Talha Khan, aapki Python OOP Assignment verify ho chuki hai!"
    print(f"Sab channels ko message bhejna: '{broadcast_msg}'\n")

    # Single polymorphic function se sab ko send karna
    notify_all(channel_list, broadcast_msg)

    print("\n--- Where Polymorphism Occurs (Wazahat) ---")
    print("EXPLANATION:")
    print("Polymorphism 'notify_all()' function ke andar loop 'notifier.send(message)' me ho rahi hai.")
    print("Python runtime par khud decide karta hai ke konsi class ka 'send()' chalana hai.")
    print("Jab humne 'WhatsAppNotification' add kiya, to dispatcher me ek lafz bhi change nahi karna pada.")
