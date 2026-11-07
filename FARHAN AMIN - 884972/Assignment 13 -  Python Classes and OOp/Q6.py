class RegularCustomer:
    def final_price(self, amount):
        return amount * 0.95  # 5% Discount

class PremiumCustomer:
    def final_price(self, amount):
        return amount * 0.90  # 10% Discount

class VIPCustomer:
    def final_price(self, amount):
        return amount * 0.80  # 20% Discount

# Extension: Adding GoldCustomer without modifying print_receipt
class GoldCustomer:
    def final_price(self, amount):
        return amount * 0.85  # 15% Discount

# Generic function that works with any customer type
def print_receipt(customer, amount):
    if amount < 0:
        print("❌ Error: Bill amount cannot be negative.")
        return

    # Dynamic method lookup based on customer type
    discounted_price = customer.final_price(amount)
    customer_type = customer.__class__.__name__
    print(f"👤 {customer_type:<17} | Original: Rs. {amount:,} | Final Bill: Rs. {discounted_price:,.2f}")


# --- Test Cases ---
bill_amount = 10000

print(f"--- Processing Receipts for Bill: Rs. {bill_amount:,} ---")
print_receipt(RegularCustomer(), bill_amount)
print_receipt(PremiumCustomer(), bill_amount)
print_receipt(VIPCustomer(), bill_amount)
print_receipt(GoldCustomer(), bill_amount)  # Works flawlessly without modifying the function

print("\n--- Testing Input Validation ---")
print_receipt(RegularCustomer(), -500)  # Negative check
