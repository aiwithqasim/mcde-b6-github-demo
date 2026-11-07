class Payment:

  def process_payment(self, amount):
    raise NotImplementedError("Subclasses must implement abstract operation")


class CreditCardPayment(Payment):

  def __init__(self, card_number):
    self.card_number = card_number

  def process_payment(self, amount):
    masked_card = f"****-****-****-{self.card_number[-4:]}"
    print(
        f"Processing credit card payment of Rs. {amount:.2f} using card"
        f" {masked_card}..."
    )


class PayPalPayment(Payment):

  def __init__(self, email):
    self.email = email

  def process_payment(self, amount):
    print(
        f"Processing PayPal payment of Rs. {amount:.2f} using account"
        f" {self.email}..."
    )


def execute_checkout(payment_gateway: Payment, amount: float):
  """Common interface demonstrating polymorphism."""
  payment_gateway.process_payment(amount)


# --- Demonstration ---
if __name__ == "__main__":
  print("--- Q5: Payment Gateway System Demonstration ---")
  gateway1 = CreditCardPayment("4111222233334444")
  gateway2 = PayPalPayment("user@example.com")

  execute_checkout(gateway1, 4500.0)
  execute_checkout(gateway2, 1250.50)