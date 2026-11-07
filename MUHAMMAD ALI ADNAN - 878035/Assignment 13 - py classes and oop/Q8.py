# Q8. Payment Gateway (Abstraction - Intermediate)

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
        if amount <= 0:
            print("  [REJECTED] Payment amount must be positive.")
            return False
        print(f"  [CARD]           PAY      Rs. {amount:,.2f}")
        return True

    def refund(self, amount):
        if amount <= 0:
            print("  [REJECTED] Refund amount must be positive.")
            return False
        print(f"  [CARD]           REFUND   Rs. {amount:,.2f}")
        return True


class WalletPayment(PaymentMethod):
    def pay(self, amount):
        if amount <= 0:
            print("  [REJECTED] Payment amount must be positive.")
            return False
        print(f"  [WALLET]         PAY      Rs. {amount:,.2f}")
        return True

    def refund(self, amount):
        if amount <= 0:
            print("  [REJECTED] Refund amount must be positive.")
            return False
        print(f"  [WALLET]         REFUND   Rs. {amount:,.2f}")
        return True


class BankTransferPayment(PaymentMethod):
    def pay(self, amount):
        if amount <= 0:
            print("  [REJECTED] Payment amount must be positive.")
            return False
        print(f"  [BANK TRANSFER]  PAY      Rs. {amount:,.2f}")
        return True

    def refund(self, amount):
        if amount <= 0:
            print("  [REJECTED] Refund amount must be positive.")
            return False
        print(f"  [BANK TRANSFER]  REFUND   Rs. {amount:,.2f}")
        return True


class CryptoPayment(PaymentMethod):
    """Extension: new payment method added without changing process_transaction()."""

    def pay(self, amount):
        if amount <= 0:
            print("  [REJECTED] Payment amount must be positive.")
            return False
        print(f"  [CRYPTO]         PAY      Rs. {amount:,.2f}")
        return True

    def refund(self, amount):
        if amount <= 0:
            print("  [REJECTED] Refund amount must be positive.")
            return False
        print(f"  [CRYPTO]         REFUND   Rs. {amount:,.2f}")
        return True


def process_transaction(method, amount):
    method.pay(amount)


if __name__ == "__main__":
    print("=== Successful payments ===")
    methods = [CardPayment(), WalletPayment(), BankTransferPayment()]
    for method in methods:
        process_transaction(method, 2500)

    print("\n=== Rejected: non-positive amounts ===")
    for method in methods:
        process_transaction(method, 0)

    print("\n=== Refunds ===")
    for method in methods:
        method.refund(2500)

    print("\n=== Extension: CryptoPayment added, process_transaction unchanged ===")
    process_transaction(CryptoPayment(), 2500)

    print("\n=== Abstraction check ===")
    try:
        PaymentMethod()
    except TypeError as e:
        print(f"  TypeError: {e}")
    print("  process_transaction() only depends on the pay() interface, so any class")
    print("  that implements the abstract methods works without modifying the function.")
