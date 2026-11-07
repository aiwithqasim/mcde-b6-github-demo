# Q6. Checkout Discount Calculator (Polymorphism - Intermediate)


class RegularCustomer:
    DISCOUNT = 0.05

    def final_price(self, amount):
        return amount * (1 - self.DISCOUNT)


class PremiumCustomer:
    DISCOUNT = 0.10

    def final_price(self, amount):
        return amount * (1 - self.DISCOUNT)


class VIPCustomer:
    DISCOUNT = 0.20

    def final_price(self, amount):
        return amount * (1 - self.DISCOUNT)


class GoldCustomer:
    DISCOUNT = 0.15

    def final_price(self, amount):
        return amount * (1 - self.DISCOUNT)


def print_receipt(customer, amount):
    if amount < 0:
        print(f"  [REJECTED] Bill amount Rs. {amount} is invalid: must not be negative.")
        return
    final = customer.final_price(amount)
    print(f"  {type(customer).__name__:18} | Bill Rs. {amount:>9,.2f} "
          f"| Final Rs. {final:>9,.2f}")


if __name__ == "__main__":
    bill = 10000

    print("=== Receipts for a bill of Rs. 10,000 ===")
    customers = [RegularCustomer(), PremiumCustomer(), VIPCustomer()]
    for customer in customers:
        print_receipt(customer, bill)

    print("\n=== Extension: GoldCustomer (15%) added, print_receipt unchanged ===")
    print_receipt(GoldCustomer(), bill)

    print("\n=== Rejected: negative bill amount ===")
    print_receipt(PremiumCustomer(), -500)

    print("\n=== Polymorphism ===")
    print("  print_receipt() works with any object that implements final_price(amount),")
    print("  regardless of its class - the discount is resolved at call time.")
