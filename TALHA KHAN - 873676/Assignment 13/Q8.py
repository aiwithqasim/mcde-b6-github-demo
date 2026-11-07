"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assignment   : Assignment 13 - Python Classes and OOP
Pillar 4     : Abstraction
Question 8   : Payment Gateway | Intermediate
=============================================================================
"""
from abc import ABC, abstractmethod

# Abstract Class PaymentMethod: Universal payment contract
class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount: float):
        pass

    @abstractmethod
    def refund(self, amount: float):
        pass


# Concrete Method 1: Credit/Debit Card Payment
class CardPayment(PaymentMethod):
    def pay(self, amount: float):
        print(f"[Card Payment]          TXN: PAYMENT | Amount: Rs. {amount:,.2f} | Status: Approved")

    def refund(self, amount: float):
        print(f"[Card Payment]          TXN: REFUND  | Amount: Rs. {amount:,.2f} | Status: Reversed")


# Concrete Method 2: Digital Wallet Payment (EasyPaisa/JazzCash)
class WalletPayment(PaymentMethod):
    def pay(self, amount: float):
        print(f"[Wallet Payment]        TXN: PAYMENT | Amount: Rs. {amount:,.2f} | Status: Deducted")

    def refund(self, amount: float):
        print(f"[Wallet Payment]        TXN: REFUND  | Amount: Rs. {amount:,.2f} | Status: Credited")


# Concrete Method 3: Direct Bank Transfer
class BankTransferPayment(PaymentMethod):
    def pay(self, amount: float):
        print(f"[Bank Transfer Payment] TXN: PAYMENT | Amount: Rs. {amount:,.2f} | Status: Transferred")

    def refund(self, amount: float):
        print(f"[Bank Transfer Payment] TXN: REFUND  | Amount: Rs. {amount:,.2f} | Status: Returned")


# Extension: Naya Payment Method (CryptoPayment)
class CryptoPayment(PaymentMethod):
    def pay(self, amount: float):
        print(f"[Crypto Payment]        TXN: PAYMENT | Amount: Rs. {amount:,.2f} | Status: Confirmed on Chain")

    def refund(self, amount: float):
        print(f"[Crypto Payment]        TXN: REFUND  | Amount: Rs. {amount:,.2f} | Status: Chain Refund Broadcast")


# Universal Transaction Processor Function
def process_transaction(method: PaymentMethod, amount: float):
    # Validation: Amount positive honi chahiye
    if amount <= 0:
        print(f"[Transaction Failed] Transaction amount positive honi chahiye: Rs. {amount:,.2f}")
        return False
        
    # Polymorphic call to pay()
    method.pay(amount)
    return True


# =============================================================================
# Testing & Demonstration
# =============================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("PILLAR 4 - Q8: PAYMENT GATEWAY (ABSTRACTION)")
    print("Student: TALHA KHAN | Roll No: 873676")
    print("=" * 70)

    # Mukhtalif payment methods banaye
    card = CardPayment()
    wallet = WalletPayment()
    bank = BankTransferPayment()
    crypto = CryptoPayment()  # Naya extension method

    # Payments process karna
    print("--- Common Gateway Se Payments Process Karna ---")
    process_transaction(card, 7500.0)
    process_transaction(wallet, 1500.0)
    process_transaction(bank, 45000.0)
    process_transaction(crypto, 90000.0)  # Bina process_transaction badle chal gaya!

    # Refunds process karna
    print("\n--- Refunds Process Karna ---")
    card.refund(2000.0)
    wallet.refund(500.0)

    # Validation: Negative amount rejection test
    print("\n--- [Validation Test] Negative Amount Rejection ---")
    process_transaction(card, -1000.0)
