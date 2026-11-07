"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assignment   : Assignment 13 - Python Classes and OOP
Pillar 1     : Encapsulation
Question 2   : Secure Bank Account | Intermediate
=============================================================================
"""

# BankAccount Class: Paise aur PIN ko encapsulation ke zariye secure rakhna
class BankAccount:
    def __init__(self, account_holder: str, initial_balance: float, pin: str):
        # Public: Account holder ka naam sab dekh sakte hain
        self.account_holder: str = account_holder
        
        # Private: Balance ko double underscore se chupa diya taake koi direct change na kare
        self.__balance: float = float(initial_balance) if initial_balance >= 0 else 0.0
        
        # Private: PIN security ke liye chupa hua hai
        self.__pin: str = str(pin)

    # Paise jama (deposit) karne ka method
    def deposit(self, amount: float) -> bool:
        # Zero ya negative amount reject karna
        if amount <= 0:
            print(f"[Deposit Rejected] Deposit amount positive honi chahiye. Aapne di: Rs. {amount:,.2f}")
            return False
            
        # Sahi amount ho to balance me add karna
        self.__balance += amount
        print(f"[Deposit Success] Rs. {amount:,.2f} jama ho gaye. Naya Balance: Rs. {self.__balance:,.2f}")
        return True

    # Paise nikalne (withdraw) karne ka method
    def withdraw(self, amount: float, pin: str) -> bool:
        # Pehle check karo PIN sahi hai ya nahi
        if str(pin) != self.__pin:
            print(f"[Withdrawal Rejected] Galat PIN! Transaction cancel ho gayi.")
            return False
            
        # Check karo amount 0 se barhi hai ya nahi
        if amount <= 0:
            print(f"[Withdrawal Rejected] Nikalwane ki amount 0 se barhi honi chahiye: Rs. {amount:,.2f}")
            return False
            
        # Check karo account me itne paise mojood bhi hain ya nahi
        if amount > self.__balance:
            print(f"[Withdrawal Rejected] Balance kam hai! Manga: Rs. {amount:,.2f}, Mojood: Rs. {self.__balance:,.2f}")
            return False

        # Agar sab theek hai to balance minus kar do
        self.__balance -= amount
        print(f"[Withdrawal Success] Rs. {amount:,.2f} nikal gaye. Baqi Balance: Rs. {self.__balance:,.2f}")
        return True

    # PIN check karke balance dekhne ka getter method
    def get_balance(self, pin: str):
        if str(pin) != self.__pin:
            print("[Access Denied] Balance dekhne ke liye sahi PIN enter karein.")
            return None
        return self.__balance


# =============================================================================
# Testing & Demonstration
# =============================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("PILLAR 1 - Q2: SECURE BANK ACCOUNT (ENCAPSULATION)")
    print("Student: TALHA KHAN | Roll No: 873676")
    print("=" * 70)

    # Account ka object banaya 10,000 balance aur PIN 1234 ke sath
    account = BankAccount(account_holder="Talha Khan", initial_balance=10000.0, pin="1234")
    print(f"Account Holder: {account.account_holder}")

    # 1. Sahi deposit test karna
    print("\n--- [Operation 1] Successful Deposit (Rs. 5,000) ---")
    account.deposit(5000.0)

    # 2. Sahi withdrawal test karna (Sahi PIN ke sath)
    print("\n--- [Operation 2] Successful Withdrawal (Rs. 3,000) ---")
    account.withdraw(3000.0, pin="1234")

    # 3. Rejection Test 1: Galat PIN de kar withdraw karna
    print("\n--- [Operation 3] Rejection Test 1: Galat PIN (9999) ---")
    account.withdraw(2000.0, pin="9999")

    # 4. Rejection Test 2: Balance se zyada paise nikalne ki koshish
    print("\n--- [Operation 4] Rejection Test 2: Insufficient Balance (Rs. 50,000) ---")
    account.withdraw(50000.0, pin="1234")

    # 5. Rejection Test 3: Negative paise deposit karna
    print("\n--- [Operation 5] Rejection Test 3: Negative Deposit (-500) ---")
    account.deposit(-500.0)

    # 6. Extension: Double underscore asal security kyu nahi deta
    print("\n--- [Extension] Double Underscores Asal Security Kyu Nahi Dete? ---")
    print("WAZAHAT (EXPLANATION):")
    print("Python me double underscore '__' sirf 'Name Mangling' karta hai, data ko encrypt nahi karta.")
    print("Bahar se koi bhi hacker ya coder class ka naam jorh kar variable access kar sakta hai jaise:")
    print(f"Bypass karke balance access: account._BankAccount__balance = Rs. {account._BankAccount__balance:,.2f}")
    print("Is liye true security ke liye backend API aur proper authorization zaroori hoti hai.")
