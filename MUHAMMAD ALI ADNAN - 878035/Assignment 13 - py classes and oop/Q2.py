# Q2. Secure Bank Account (Encapsulation - Intermediate)


class BankAccount:
    def __init__(self, account_holder, balance, pin):
        self.account_holder = account_holder   # public attribute
        self.__balance = balance               # private attribute
        self.__pin = pin                       # private attribute

    def deposit(self, amount):
        if amount <= 0:
            print(f"  [REJECTED] Deposit of Rs. {amount} failed: amount must be positive.")
            return False
        self.__balance += amount
        print(f"  [OK] Deposited Rs. {amount}. Balance = Rs. {self.__balance}")
        return True

    def withdraw(self, amount, pin):
        if pin != self.__pin:
            print(f"  [REJECTED] Withdrawal of Rs. {amount} failed: incorrect PIN.")
            return False
        if amount <= 0:
            print(f"  [REJECTED] Withdrawal of Rs. {amount} failed: amount must be positive.")
            return False
        if amount > self.__balance:
            print(f"  [REJECTED] Withdrawal of Rs. {amount} failed: insufficient balance "
                  f"(available Rs. {self.__balance}).")
            return False
        self.__balance -= amount
        print(f"  [OK] Withdrawn Rs. {amount}. Balance = Rs. {self.__balance}")
        return True

    def get_balance(self, pin):
        if pin != self.__pin:
            print("  [REJECTED] Balance inquiry failed: incorrect PIN.")
            return None
        return self.__balance


if __name__ == "__main__":
    acc = BankAccount("Ali Adnan", 5000, 1234)

    print("=== Test 1: successful deposit ===")
    acc.deposit(2500)

    print("\n=== Test 2: successful withdrawal ===")
    acc.withdraw(1000, 1234)

    print("\n=== Test 3: rejected - withdrawal with wrong PIN ===")
    acc.withdraw(500, 9999)

    print("\n=== Test 4: rejected - withdrawal exceeding balance ===")
    acc.withdraw(100000, 1234)

    print(f"\nFinal balance (correct PIN): Rs. {acc.get_balance(1234)}")
    print(f"Final balance (wrong PIN):   {acc.get_balance(0000)}")

    print("\n=== Extension: why double underscores are not true security ===")
    print("  Double underscores only trigger name mangling (__balance -> _BankAccount__balance).")
    print("  It hides the attribute from casual access, but anyone can still read it via")
    print("  acc._BankAccount__balance. Real security requires language-level enforcement")
    print("  or cryptographic measures, not name mangling.")
    print(f"  acc._BankAccount__balance = {acc._BankAccount__balance}  (proof it is still reachable)")
