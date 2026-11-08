# Q6: Checkout Discount Calculator - Polymorphism

class RegularCustomer:
    DISCOUNT = 0.05

    def final_price(self, amount):
        validate_amount(amount)
        return amount * (1 - self.DISCOUNT)


class PremiumCustomer:
    DISCOUNT = 0.10

    def final_price(self, amount):
        validate_amount(amount)
        return amount * (1 - self.DISCOUNT)


class VIPCustomer:
    DISCOUNT = 0.20

    def final_price(self, amount):
        validate_amount(amount)
        return amount * (1 - self.DISCOUNT)


class GoldCustomer:
    DISCOUNT = 0.15

    def final_price(self, amount):
        validate_amount(amount)
        return amount * (1 - self.DISCOUNT)


def validate_amount(amount):
    if not isinstance(amount, (int, float)) or isinstance(amount, bool) or amount < 0:
        raise ValueError("Bill amount cannot be negative and must be numeric.")


def print_receipt(customer, amount):
    validate_amount(amount)
    final_amount = customer.final_price(amount)
    print(f"{customer.__class__.__name__}:")
    print(f"  Original bill: Rs. {amount:,.2f}")
    print(f"  Final amount:  Rs. {final_amount:,.2f}")


if __name__ == "__main__":
    customers = [
        RegularCustomer(),
        PremiumCustomer(),
        VIPCustomer(),
        GoldCustomer()
    ]

    for customer in customers:
        print_receipt(customer, 10000)
        print()

    try:
        print_receipt(RegularCustomer(), -500)
    except ValueError as error:
        print("Invalid bill:", error)

    # GoldCustomer works with print_receipt() without modifying that function.
