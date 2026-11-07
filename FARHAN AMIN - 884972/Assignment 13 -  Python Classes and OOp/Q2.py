class BankAccount:
    def __init__(self, account_holder, initial_balance, pin):
        self.account_holder = account_holder  # Public
        self.__balance = initial_balance      # Private
        self.__pin = pin                      # Private

    def deposit(self, amount):
        # Zero ya negative deposit reject karein
        if amount > 0:
            self.__balance += amount
            print(f"✅ Successfully deposited Rs. {amount}. New Balance: Rs. {self.__balance}")
        else:
            print(f"❌ Deposit Rejected: Amount Rs. {amount} must be greater than zero.")

    def withdraw(self, amount, pin):
        # PIN check
        if pin != self.__pin:
            print("❌ Withdrawal Rejected: Incorrect PIN.")
            return
        
        # Balance check
        if amount <= 0:
            print("❌ Withdrawal Rejected: Amount must be greater than zero.")
        elif amount > self.__balance:
            print(f"❌ Withdrawal Rejected: Insufficient balance. Available: Rs. {self.__balance}")
        else:
            self.__balance -= amount
            print(f"✅ Successfully withdrew Rs. {amount}. Remaining Balance: Rs. {self.__balance}")

    def get_balance(self, pin):
        if pin == self.__pin:
            return self.__balance
        else:
            print("❌ Access Denied: Incorrect PIN.")
            return None


# --- Test Cases ---
account = BankAccount("Zain", 5000, "1234")

print("--- 1. Successful Deposit ---")
account.deposit(2000)

print("\n--- 2. Successful Withdrawal ---")
account.withdraw(1500, "1234")

print("\n--- 3. Rejected Operation: Incorrect PIN ---")
account.withdraw(500, "9999")

print("\n--- 4. Rejected Operation: Insufficient Balance ---")
account.withdraw(10000, "1234")

print("\n--- 5. Rejected Operation: Negative Deposit ---")
account.deposit(-500)

print("\n--- Extension Check: Accessing via Name Mangling ---")
print(f"balance access from outside (Name Mangling): Rs. {account._BankAccount__balance}")
