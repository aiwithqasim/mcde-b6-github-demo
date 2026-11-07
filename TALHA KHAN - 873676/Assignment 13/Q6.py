"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assignment   : Assignment 13 - Python Classes and OOP
Pillar 3     : Polymorphism
Question 6   : Checkout Discount Calculator | Intermediate
=============================================================================
"""

# Regular Customer: 5% discount
class RegularCustomer:
    def final_price(self, amount: float) -> float:
        return amount * (1 - 0.05)


# Premium Customer: 10% discount
class PremiumCustomer:
    def final_price(self, amount: float) -> float:
        return amount * (1 - 0.10)


# VIP Customer: 20% discount
class VIPCustomer:
    def final_price(self, amount: float) -> float:
        return amount * (1 - 0.20)


# Extension: Gold Customer: 15% discount
class GoldCustomer:
    def final_price(self, amount: float) -> float:
        return amount * (1 - 0.15)


# Polymorphic Function: Har customer type ki receipt print karna
def print_receipt(customer, amount: float):
    # Validation: Negative bill amount reject karna
    if amount < 0:
        print(f"[Error] Bill amount negative nahi ho sakti! Received: Rs. {amount:,.2f}")
        return

    # Polymorphic call: customer ka apna final_price chalega
    discounted_amount = customer.final_price(amount)
    savings = amount - discounted_amount
    customer_type = customer.__class__.__name__

    print(f"Receipt | {customer_type:<18} | Original: Rs. {amount:,.2f} | Bachat: Rs. {savings:,.2f} | Adaigi: Rs. {discounted_amount:,.2f}")


# =============================================================================
# Testing & Demonstration
# =============================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("PILLAR 3 - Q6: CHECKOUT DISCOUNT CALCULATOR (POLYMORPHISM)")
    print("Student: TALHA KHAN | Roll No: 873676")
    print("=" * 70)

    bill_amount = 10000.0
    print(f"Total Bill Amount: Rs. {bill_amount:,.2f}\n")

    # Sabhi customer types ki list
    customers = [
        RegularCustomer(),
        PremiumCustomer(),
        VIPCustomer(),
        GoldCustomer()  # Extension class
    ]

    # Basic loop chala kar har customer ki receipt nikalna
    for cust in customers:
        print_receipt(cust, bill_amount)

    # Negative amount rejection test
    print("\n--- [Validation Test] Negative Bill Amount Rejection ---")
    print_receipt(RegularCustomer(), -2000.0)
