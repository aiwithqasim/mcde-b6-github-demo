# Q8: Payment Gateway - Abstraction

from abc import ABC, abstractmethod


def validate_amount(amount):
    if not isinstance(amount, (int, float)) or isinstance(amount, bool) or amount <= 0:
        raise ValueError("Transaction amount must be a positive number.")


class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount):
        pass

    @abstractmethod
    def refund(self, amount):
        pass


class CardPayment(PaymentMethod):
    def pay(self, amount):
        validate_amount(amount)
        print(f"Card Payment | Payment | Rs. {amount:,.2f}")

    def refund(self, amount):
        validate_amount(amount)
        print(f"Card Payment | Refund | Rs. {amount:,.2f}")


class WalletPayment(PaymentMethod):
    def pay(self, amount):
        validate_amount(amount)
        print(f"Wallet Payment | Payment | Rs. {amount:,.2f}")

    def refund(self, amount):
        validate_amount(amount)
        print(f"Wallet Payment | Refund | Rs. {amount:,.2f}")


class BankTransferPayment(PaymentMethod):
    def pay(self, amount):
        validate_amount(amount)
        print(f"Bank Transfer | Payment | Rs. {amount:,.2f}")

    def refund(self, amount):
        validate_amount(amount)
        print(f"Bank Transfer | Refund | Rs. {amount:,.2f}")


def process_transaction(method, amount):
    """Process payment using any PaymentMethod subclass."""
    method.pay(amount)


if __name__ == "__main__":
    payment_methods = [
        CardPayment(),
        WalletPayment(),
        BankTransferPayment()
    ]

    for payment_method in payment_methods:
        process_transaction(payment_method, 2500)
        payment_method.refund(500)

    try:
        process_transaction(CardPayment(), 0)
    except ValueError as error:
        print("Invalid transaction:", error)

    # A new class can inherit PaymentMethod and implement pay() and refund().
    # process_transaction() does not need to change.
