from abc import ABC, abstractmethod

class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount):
        pass

    @abstractmethod
    def refund(self, amount):
        pass


class CardPayment(PaymentMethod):
    def pay(self, amount):
        print(f"💳 [Card Payment] - Processing Success! Type: Charge | Amount: Rs. {amount:,}")

    def refund(self, amount):
        print(f"💳 [Card Payment] - Processing Success! Type: Refund | Amount: Rs. {amount:,}")


class WalletPayment(PaymentMethod):
    def pay(self, amount):
        print(f"📱 [Wallet Payment] - Processing Success! Type: Charge | Amount: Rs. {amount:,}")

    def refund(self, amount):
        print(f"📱 [Wallet Payment] - Processing Success! Type: Refund | Amount: Rs. {amount:,}")


class BankTransferPayment(PaymentMethod):
    def pay(self, amount):
        print(f"🏦 [Bank Transfer] - Processing Success! Type: Charge | Amount: Rs. {amount:,}")

    def refund(self, amount):
        print(f"🏦 [Bank Transfer] - Processing Success! Type: Refund | Amount: Rs. {amount:,}")


# Extension: Adding a new payment method without changing process_transaction
class CryptoPayment(PaymentMethod):
    def pay(self, amount):
        print(f"🪙 [Crypto Payment] - Processing Success! Type: Charge | Amount: Rs. {amount:,}")

    def refund(self, amount):
        print(f"🪙 [Crypto Payment] - Processing Success! Type: Refund | Amount: Rs. {amount:,}")


# Core transaction processor function
def process_transaction(method, amount):
    # Validation: Amount must be positive
    if amount <= 0:
        print(f"❌ Transaction Failed: Amount Rs. {amount} must be positive.")
        return
    
    # Polymorphic call to pay method
    method.pay(amount)


# --- Test Cases ---
print("--- Processing Supported Payments (Rs. 5,000) ---")
process_transaction(CardPayment(), 5000)
process_transaction(WalletPayment(), 5000)
process_transaction(BankTransferPayment(), 5000)

print("\n--- Extension: Testing New Payment Method Without Changing Core Code ---")
process_transaction(CryptoPayment(), 7500)  # Plugs in seamlessly!

print("\n--- Testing Transaction Input Validation ---")
process_transaction(CardPayment(), -1500)  # Negative check
