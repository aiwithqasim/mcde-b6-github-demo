class BankAccount:

  def __init__(self, account_holder, initial_balance, pin):
    self.account_holder = account_holder  # Public
    self.__balance = max(0.0, float(initial_balance))  # Private balance
    self.__pin = str(pin)  # Private PIN

  def deposit(self, amount):
    if amount > 0:
      self.__balance += amount
      print(
          f"✅ Successfully deposited Rs. {amount:.2f}. New Balance:"
          f" Rs. {self.__balance:.2f}"
      )
    else:
      print("❌ Error: Deposit amount must be greater than zero.")

  def withdraw(self, amount, pin):
    if str(pin) != self.__pin:
      print("❌ Error: Incorrect PIN. Withdrawal denied.")
      return
    if amount <= 0:
      print("❌ Error: Withdrawal amount must be greater than zero.")
      return
    if amount > self.__balance:
      print("❌ Error: Insufficient funds.")
      return

    self.__balance -= amount
    print(
        f"✅ Successfully withdrew Rs. {amount:.2f}. Remaining Balance:"
        f" Rs. {self.__balance:.2f}"
    )

  def get_balance(self, pin):
    if str(pin) == self.__pin:
      return self.__balance
    else:
      print("❌ Error: Incorrect PIN. Access denied.")
      return None


# --- Demonstration ---
if __name__ == "__main__":
  print("--- Q2: Secure Bank Account Demonstration ---")
  acc = BankAccount("Bob Smith", 5000, "1234")

  # 1. Successful deposit
  acc.deposit(1500)

  # 2. Successful withdrawal
  acc.withdraw(2000, "1234")

  # 3. Rejected operation 1: Incorrect PIN
  acc.withdraw(500, "9999")

  # 4. Rejected operation 2: Withdrawal exceeding balance
  acc.withdraw(10000, "1234")