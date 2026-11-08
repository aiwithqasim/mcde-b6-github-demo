# Q2: Secure Bank Account - Encapsulation

class BankAccount:
    def __init__(self, account_holder, pin, initial_balance=0):
        self.account_holder = account_holder  # Public attribute
        self.__pin = str(pin)                  # Private attribute
        self.__balance = 0                     # Private attribute

        if initial_balance < 0:
            raise ValueError("Initial balance cannot be negative.")
        self.__balance = initial_balance

    def deposit(self, amount):
        if not isinstance(amount, (int, float)) or isinstance(amount, bool) or amount <= 0:
            print("Deposit rejected: amount must be positive.")
            return False

        self.__balance += amount
        print(f"Deposit successful: Rs. {amount:,.2f}")
        return True

    def withdraw(self, amount, pin):
        if str(pin) != self.__pin:
            print("Withdrawal rejected: incorrect PIN.")
            return False

        if not isinstance(amount, (int, float)) or isinstance(amount, bool) or amount <= 0:
            print("Withdrawal rejected: amount must be positive.")
            return False

        if amount > self.__balance:
            print("Withdrawal rejected: insufficient balance.")
            return False

        self.__balance -= amount
        print(f"Withdrawal successful: Rs. {amount:,.2f}")
        return True

    def get_balance(self, pin):
        if str(pin) != self.__pin:
            print("Balance unavailable: incorrect PIN.")
            return None
        return self.__balance


if __name__ == "__main__":
    account1 = BankAccount("Ahmed", "1234", 5000)
    account2 = BankAccount("Ayesha", "5678", 2500)

    print("Account holder:", account1.account_holder)
    account1.deposit(2000)
    account1.withdraw(1500, "1234")
    account1.withdraw(500, "0000")       # Rejected: incorrect PIN
    account1.withdraw(10000, "1234")     # Rejected: insufficient balance
    print(f"Final balance: Rs. {account1.get_balance('1234'):,.2f}")
    print(f"{account2.account_holder}'s balance: Rs. {account2.get_balance('5678'):,.2f}")

    # Double underscores trigger name mangling, not encryption or true security.
    # They discourage accidental access but can still be accessed by using
    # the mangled name (for example, account1._BankAccount__balance).
