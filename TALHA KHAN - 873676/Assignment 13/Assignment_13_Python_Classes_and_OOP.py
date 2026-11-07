"""
================================================================================
STUDENT DETAILS
================================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Course       : Python Programming & Cloud Computing
Assignment   : Assignment 13: Python Classes and OOP
Topic        : The Four Fundamental Pillars of Object-Oriented Programming (OOP)
               1. Encapsulation (Q1, Q2)
               2. Inheritance   (Q3, Q4)
               3. Polymorphism  (Q5, Q6)
               4. Abstraction   (Q7, Q8)
================================================================================
"""

from abc import ABC, abstractmethod


# ==============================================================================
# PILLAR 1: ENCAPSULATION
# ==============================================================================

# ------------------------------------------------------------------------------
# Q1. Student Result Manager | Beginner
# ------------------------------------------------------------------------------
# Student Class: Data hiding (Public, Protected, Private) dikhane ke liye
class Student:
    def __init__(self, name: str, marks: float):
        # Public attribute: Isko koi bhi bahar se direct access kar sakta hai
        self.name: str = name
        # Protected attribute: Single underscore convention
        self._marks: float = 0.0
        # Private attribute: Double underscore se data hide kiya
        self.__grade: str = "F"
        # Setter method se marks validate karke set karna
        self.set_marks(marks)

    # Setter method: Marks 0 se 100 ke darmiyan validate karke grade nikalna
    def set_marks(self, marks: float) -> bool:
        if not (isinstance(marks, (int, float)) and 0 <= marks <= 100):
            print(f"[Error] Invalid marks: {marks}. Marks lazmi 0 se 100 ke beech hon.")
            return False

        self._marks = float(marks)

        # Grade criteria: 80-100: A | 60-79: B | 40-59: C | Below 40: F
        if self._marks >= 80:
            self.__grade = "A"
        elif self._marks >= 60:
            self.__grade = "B"
        elif self._marks >= 40:
            self.__grade = "C"
        else:
            self.__grade = "F"

        print(f"[Success] Marks updated to {self._marks} for '{self.name}'. Assigned Grade: {self.__grade}")
        return True

    # Getter methods: Protected aur private data safely dekhne ke liye
    def get_marks(self) -> float:
        return self._marks

    def get_grade(self) -> str:
        return self.__grade


def run_q1():
    print("\n" + "=" * 70)
    print("PILLAR 1 - Q1: STUDENT RESULT MANAGER (ENCAPSULATION)")
    print("=" * 70)

    s1 = Student(name="Talha Khan", marks=85)
    print(f"Student: {s1.name} | Marks: {s1.get_marks()} | Grade: {s1.get_grade()}")

    print("\n[Test 1] Sahi Marks Update Karna (72 marks):")
    s1.set_marks(72)
    print(f"Student: {s1.name} | Updated Marks: {s1.get_marks()} | Grade: {s1.get_grade()}")

    print("\n[Test 2] Galat Marks Rejection (110 aur -10):")
    s1.set_marks(110)
    s1.set_marks(-10)
    print(f"Student: {s1.name} | Final Marks: {s1.get_marks()} | Grade: {s1.get_grade()}")

    print("\n[Extension] Private Attribute '__grade' Ko Direct Access Karne Ki Koshish:")
    try:
        print(s1.__grade)
    except AttributeError as err:
        print(f"Caught Expected AttributeError: {err}")
        print("EXPLANATION:")
        print("Python me '__' lagane se Name Mangling ho jati hai aur attribute '_Student__grade' ban jata hai.")
        print("Isi wajah se direct access block ho kar data secure rehta hai.")


# ------------------------------------------------------------------------------
# Q2. Secure Bank Account | Intermediate
# ------------------------------------------------------------------------------
# BankAccount Class: Balance aur PIN secure rakhne ke liye
class BankAccount:
    def __init__(self, account_holder: str, initial_balance: float, pin: str):
        self.account_holder: str = account_holder
        # Private attributes: direct change rokne ke liye
        self.__balance: float = float(initial_balance) if initial_balance >= 0 else 0.0
        self.__pin: str = str(pin)

    # Deposit method: negative amounts reject karna
    def deposit(self, amount: float) -> bool:
        if amount <= 0:
            print(f"[Deposit Rejected] Amount positive honi chahiye: Rs. {amount:,.2f}")
            return False
        self.__balance += amount
        print(f"[Deposit Success] Rs. {amount:,.2f} jama ho gaye. Balance: Rs. {self.__balance:,.2f}")
        return True

    # Withdraw method: PIN aur balance check karke paise nikalna
    def withdraw(self, amount: float, pin: str) -> bool:
        if str(pin) != self.__pin:
            print(f"[Withdrawal Rejected] Galat PIN! Transaction reject ho gayi.")
            return False
        if amount <= 0:
            print(f"[Withdrawal Rejected] Amount 0 se barhi honi chahiye: Rs. {amount:,.2f}")
            return False
        if amount > self.__balance:
            print(f"[Withdrawal Rejected] Insufficient balance! Manga: Rs. {amount:,.2f}, Mojood: Rs. {self.__balance:,.2f}")
            return False

        self.__balance -= amount
        print(f"[Withdrawal Success] Rs. {amount:,.2f} nikal gaye. Baqi Balance: Rs. {self.__balance:,.2f}")
        return True

    # Getter: PIN match hone par balance dikhana
    def get_balance(self, pin: str):
        if str(pin) != self.__pin:
            print("[Access Denied] Incorrect PIN.")
            return None
        return self.__balance


def run_q2():
    print("\n" + "=" * 70)
    print("PILLAR 1 - Q2: SECURE BANK ACCOUNT (ENCAPSULATION)")
    print("=" * 70)

    acc = BankAccount(account_holder="Talha Khan", initial_balance=10000.0, pin="1234")
    print(f"Account Holder: {acc.account_holder}")

    print("\n[Operation 1] Sahi Deposit (Rs. 5,000):")
    acc.deposit(5000.0)

    print("\n[Operation 2] Sahi Withdrawal (Rs. 3,000 with PIN 1234):")
    acc.withdraw(3000.0, pin="1234")

    print("\n[Operation 3] Rejection 1 - Galat PIN (9999):")
    acc.withdraw(2000.0, pin="9999")

    print("\n[Operation 4] Rejection 2 - Balance se zyada withdrawal (Rs. 50,000):")
    acc.withdraw(50000.0, pin="1234")

    print("\n[Operation 5] Rejection 3 - Negative deposit (-Rs. 500):")
    acc.deposit(-500.0)

    print("\n[Extension] Double Underscores True Security Kyu Nahi Hai:")
    print("EXPLANATION:")
    print("Python me double underscore sirf Name Mangling hai, koi encryption nahi.")
    print(f"Direct bypass: acc._BankAccount__balance = Rs. {acc._BankAccount__balance:,.2f}")


# ==============================================================================
# PILLAR 2: INHERITANCE
# ==============================================================================

# ------------------------------------------------------------------------------
# Q3. Employee Roles | Beginner
# ------------------------------------------------------------------------------
# Parent Class Employee
class Employee:
    def __init__(self, name: str, employee_id: int):
        self.name: str = name
        self.employee_id: int = employee_id

    def display_details(self):
        print(f"ID: {self.employee_id} | Name: {self.name}", end="")


# Child Class Developer (Employee se inherit kiya)
class Developer(Employee):
    def __init__(self, name: str, employee_id: int, programming_language: str):
        # super() se parent attributes initialize kiye
        super().__init__(name, employee_id)
        self.programming_language: str = programming_language

    # Method Overriding: Role info add ki
    def display_details(self):
        super().display_details()
        print(f" | Role: Developer | Language: {self.programming_language}")


# Child Class Manager (Employee se inherit kiya)
class Manager(Employee):
    def __init__(self, name: str, employee_id: int, team_size: int):
        super().__init__(name, employee_id)
        self.team_size: int = team_size

    def display_details(self):
        super().display_details()
        print(f" | Role: Manager | Team Size: {self.team_size} members")


def run_q3():
    print("\n" + "=" * 70)
    print("PILLAR 2 - Q3: EMPLOYEE ROLES (INHERITANCE)")
    print("=" * 70)

    dev = Developer(name="Talha Khan", employee_id=873676, programming_language="Python")
    mgr = Manager(name="Zubair Ahmed", employee_id=402110, team_size=8)

    print("Developer Object:")
    dev.display_details()

    print("\nManager Object:")
    mgr.display_details()


# ------------------------------------------------------------------------------
# Q4. Vehicle Rental System | Intermediate
# ------------------------------------------------------------------------------
# Base Class Vehicle
class Vehicle:
    def __init__(self, brand: str, model: str, daily_rental_rate: float):
        self.brand: str = brand
        self.model: str = model
        self.daily_rental_rate: float = float(daily_rental_rate)

    # Base rent calculate karne ka method
    def calculate_rent(self, days: int) -> float:
        if days <= 0:
            raise ValueError(f"Rental din kam az kam 1 hona chahiye: {days}")
        return self.daily_rental_rate * days


# Child Class Car: Fixed Rs. 1,000 insurance add karna
class Car(Vehicle):
    INSURANCE_FEE: float = 1000.0

    def calculate_rent(self, days: int) -> float:
        base_rent = super().calculate_rent(days)
        return base_rent + self.INSURANCE_FEE


# Child Class Bike: 10% discount apply karna
class Bike(Vehicle):
    DISCOUNT_RATE: float = 0.10

    def calculate_rent(self, days: int) -> float:
        base_rent = super().calculate_rent(days)
        return base_rent * (1 - self.DISCOUNT_RATE)


def run_q4():
    print("\n" + "=" * 70)
    print("PILLAR 2 - Q4: VEHICLE RENTAL SYSTEM (INHERITANCE)")
    print("=" * 70)

    car = Car(brand="Honda", model="Civic", daily_rental_rate=4500.0)
    bike = Bike(brand="Suzuki", model="GS 150", daily_rental_rate=1200.0)

    rental_days = 3
    print(f"Rental Duration: {rental_days} Days")

    car_total = car.calculate_rent(rental_days)
    print(f"\nCar: {car.brand} {car.model}")
    print(f"  Daily Rate     : Rs. {car.daily_rental_rate:,.2f}")
    print(f"  Total Car Rent : Rs. {car_total:,.2f}")

    bike_total = bike.calculate_rent(rental_days)
    print(f"\nBike: {bike.brand} {bike.model}")
    print(f"  Daily Rate     : Rs. {bike.daily_rental_rate:,.2f}")
    print(f"  Total Bike Rent: Rs. {bike_total:,.2f}")

    print("\n[Validation Test] Zero ya negative din reject karna:")
    for d in [0, -2]:
        try:
            car.calculate_rent(d)
        except ValueError as err:
            print(f"  Rejection for {d} days -> {err}")


# ==============================================================================
# PILLAR 3: POLYMORPHISM
# ==============================================================================

# ------------------------------------------------------------------------------
# Q5. Notification Dispatcher | Beginner
# ------------------------------------------------------------------------------
class EmailNotification:
    def send(self, message: str):
        print(f"[Email Notification] Sending to mailbox: '{message}'")


class SMSNotification:
    def send(self, message: str):
        print(f"[SMS Notification] Sending SMS to phone: '{message}'")


class PushNotification:
    def send(self, message: str):
        print(f"[Push Notification] Displaying mobile alert: '{message}'")


# Extension: WhatsApp Notification
class WhatsAppNotification:
    def send(self, message: str):
        print(f"[WhatsApp Notification] Sending chat ping: '{message}'")


# Single Dispatcher Function: Basic loop se sab notification objects ko send karna
def notify_all(notifications, message: str):
    for n in notifications:
        n.send(message)


def run_q5():
    print("\n" + "=" * 70)
    print("PILLAR 3 - Q5: NOTIFICATION DISPATCHER (POLYMORPHISM)")
    print("=" * 70)

    channel_list = [
        EmailNotification(),
        SMSNotification(),
        PushNotification(),
        WhatsAppNotification()  # Extension class
    ]

    msg = "Talha Khan, aapki Python OOP Assignment complete ho chuki hai!"
    print(f"Broadcasting Notification: '{msg}'\n")
    notify_all(channel_list, msg)

    print("\n--- Where Polymorphism Occurs ---")
    print("EXPLANATION:")
    print("Polymorphism 'notify_all()' me loop 'n.send(message)' ke waqt occur hoti hai.")
    print("Har object apne tareeqay se message bhejta hai aur dispatcher ko change nahi karna padta.")


# ------------------------------------------------------------------------------
# Q6. Checkout Discount Calculator | Intermediate
# ------------------------------------------------------------------------------
class RegularCustomer:
    def final_price(self, amount: float) -> float:
        return amount * (1 - 0.05)  # 5% discount


class PremiumCustomer:
    def final_price(self, amount: float) -> float:
        return amount * (1 - 0.10)  # 10% discount


class VIPCustomer:
    def final_price(self, amount: float) -> float:
        return amount * (1 - 0.20)  # 20% discount


class GoldCustomer:
    def final_price(self, amount: float) -> float:
        return amount * (1 - 0.15)  # 15% discount (Extension)


# Polymorphic receipt printer
def print_receipt(customer, amount: float):
    if amount < 0:
        print(f"[Error] Bill amount negative nahi ho sakti: Rs. {amount:,.2f}")
        return

    final = customer.final_price(amount)
    savings = amount - final
    customer_class_name = customer.__class__.__name__

    print(f"Receipt | {customer_class_name:<18} | Original: Rs. {amount:,.2f} | Discount: Rs. {savings:,.2f} | Pay: Rs. {final:,.2f}")


def run_q6():
    print("\n" + "=" * 70)
    print("PILLAR 3 - Q6: CHECKOUT DISCOUNT CALCULATOR (POLYMORPHISM)")
    print("=" * 70)

    bill = 10000.0
    print(f"Checkout Bill Amount: Rs. {bill:,.2f}\n")

    customers = [
        RegularCustomer(),
        PremiumCustomer(),
        VIPCustomer(),
        GoldCustomer()
    ]

    # Basic loop chala kar har customer ka bill print karna
    for cust in customers:
        print_receipt(cust, bill)

    print("\n[Validation Test] Negative bill rejection:")
    print_receipt(RegularCustomer(), -2500.0)


# ==============================================================================
# PILLAR 4: ABSTRACTION
# ==============================================================================

# ------------------------------------------------------------------------------
# Q7. Shape Calculator | Beginner
# ------------------------------------------------------------------------------
# Abstract Base Class Shape
class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

    @abstractmethod
    def perimeter(self) -> float:
        pass


# Concrete Circle Class
class Circle(Shape):
    PI: float = 3.14159

    def __init__(self, radius: float):
        if radius <= 0:
            raise ValueError("Radius positive hona chahiye.")
        self.radius: float = float(radius)

    def area(self) -> float:
        return self.PI * (self.radius ** 2)

    def perimeter(self) -> float:
        return 2 * self.PI * self.radius


# Concrete Rectangle Class
class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        if width <= 0 or height <= 0:
            raise ValueError("Dimensions positive honi chahiye.")
        self.width: float = float(width)
        self.height: float = float(height)

    def area(self) -> float:
        return self.width * self.height

    def perimeter(self) -> float:
        return 2 * (self.width + self.height)


def run_q7():
    print("\n" + "=" * 70)
    print("PILLAR 4 - Q7: SHAPE CALCULATOR (ABSTRACTION)")
    print("=" * 70)

    circle = Circle(radius=5)
    print(f"Circle (Radius: {circle.radius}):")
    print(f"  Area      : {circle.area():.4f}")
    print(f"  Perimeter : {circle.perimeter():.4f}")

    rect = Rectangle(width=4, height=6)
    print(f"\nRectangle (Width: {rect.width}, Height: {rect.height}):")
    print(f"  Area      : {rect.area():.4f}")
    print(f"  Perimeter : {rect.perimeter():.4f}")

    print("\n[Extension] Shape Class Ka Direct Object Banane Ki Koshish:")
    try:
        s = Shape()
    except TypeError as err:
        print(f"Caught Expected TypeError: {err}")
        print("EXPLANATION:")
        print("Abstract class jisme '@abstractmethod' ho, uska direct object nahi banaya ja sakta.")


# ------------------------------------------------------------------------------
# Q8. Payment Gateway | Intermediate
# ------------------------------------------------------------------------------
# Abstract Class PaymentMethod
class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount: float):
        pass

    @abstractmethod
    def refund(self, amount: float):
        pass


class CardPayment(PaymentMethod):
    def pay(self, amount: float):
        print(f"[Card Payment]          TXN: PAYMENT | Amount: Rs. {amount:,.2f} | Status: Approved")

    def refund(self, amount: float):
        print(f"[Card Payment]          TXN: REFUND  | Amount: Rs. {amount:,.2f} | Status: Reversed")


class WalletPayment(PaymentMethod):
    def pay(self, amount: float):
        print(f"[Wallet Payment]        TXN: PAYMENT | Amount: Rs. {amount:,.2f} | Status: Deducted")

    def refund(self, amount: float):
        print(f"[Wallet Payment]        TXN: REFUND  | Amount: Rs. {amount:,.2f} | Status: Credited")


class BankTransferPayment(PaymentMethod):
    def pay(self, amount: float):
        print(f"[Bank Transfer Payment] TXN: PAYMENT | Amount: Rs. {amount:,.2f} | Status: Transferred")

    def refund(self, amount: float):
        print(f"[Bank Transfer Payment] TXN: REFUND  | Amount: Rs. {amount:,.2f} | Status: Returned")


class CryptoPayment(PaymentMethod):
    def pay(self, amount: float):
        print(f"[Crypto Payment]        TXN: PAYMENT | Amount: Rs. {amount:,.2f} | Status: Confirmed on Chain")

    def refund(self, amount: float):
        print(f"[Crypto Payment]        TXN: REFUND  | Amount: Rs. {amount:,.2f} | Status: Broadcasted")


# Universal Transaction Processor
def process_transaction(method: PaymentMethod, amount: float):
    if amount <= 0:
        print(f"[Transaction Failed] Amount positive honi chahiye: Rs. {amount:,.2f}")
        return False
    method.pay(amount)
    return True


def run_q8():
    print("\n" + "=" * 70)
    print("PILLAR 4 - Q8: PAYMENT GATEWAY (ABSTRACTION)")
    print("=" * 70)

    card = CardPayment()
    wallet = WalletPayment()
    bank = BankTransferPayment()
    crypto = CryptoPayment()

    print("--- Common Gateway Se Payments Process Karna ---")
    process_transaction(card, 7500.0)
    process_transaction(wallet, 1500.0)
    process_transaction(bank, 45000.0)
    process_transaction(crypto, 90000.0)

    print("\n--- Refunds Process Karna ---")
    card.refund(2000.0)
    wallet.refund(500.0)

    print("\n[Validation Test] Negative amount rejection:")
    process_transaction(card, -1000.0)


# ==============================================================================
# MAIN ENTRY POINT
# ==============================================================================
if __name__ == "__main__":
    print("*" * 70)
    print("  ASSIGNMENT 13: PYTHON CLASSES AND OOP - FOUR PILLARS")
    print("  STUDENT: TALHA KHAN | ROLL NUMBER: 873676")
    print("*" * 70)

    run_q1()
    run_q2()
    run_q3()
    run_q4()
    run_q5()
    run_q6()
    run_q7()
    run_q8()

    print("\n" + "*" * 70)
    print("  ALL 8 QUESTIONS EXECUTED AND DEMONSTRATED SUCCESSFULLY!")
    print("*" * 70)
