"""Python OOP: Four Pillars Assignment (Q1-Q8)
Runnable demonstrations using only the Python standard library.
"""

from abc import ABC, abstractmethod
from math import pi


# Q1. Student Result Manager - Encapsulation
class Student:
    def __init__(self, name, marks=0):
        self.name = name
        self._marks = 0
        self.__grade = "F"
        self.set_marks(marks)

    def set_marks(self, marks):
        if not isinstance(marks, (int, float)) or not 0 <= marks <= 100:
            print(f"Invalid marks for {self.name}: {marks}")
            return False
        self._marks = marks
        if marks >= 80:
            self.__grade = "A"
        elif marks >= 60:
            self.__grade = "B"
        elif marks >= 40:
            self.__grade = "C"
        else:
            self.__grade = "F"
        return True

    def get_marks(self):
        return self._marks

    def get_grade(self):
        return self.__grade


# Q2. Secure Bank Account - Encapsulation
class BankAccount:
    def __init__(self, account_holder, balance, pin):
        self.account_holder = account_holder
        self.__balance = balance
        self.__pin = str(pin)

    def deposit(self, amount):
        if amount <= 0:
            print("Rejected: deposit must be positive.")
            return False
        self.__balance += amount
        print(f"Deposit successful: Rs. {amount}")
        return True

    def withdraw(self, amount, pin):
        if str(pin) != self.__pin:
            print("Rejected: incorrect PIN.")
            return False
        if amount <= 0:
            print("Rejected: withdrawal must be positive.")
            return False
        if amount > self.__balance:
            print("Rejected: insufficient balance.")
            return False
        self.__balance -= amount
        print(f"Withdrawal successful: Rs. {amount}")
        return True

    def get_balance(self, pin):
        if str(pin) != self.__pin:
            print("Rejected: incorrect PIN.")
            return None
        return self.__balance


# Q3. Employee Roles - Inheritance
class Employee:
    def __init__(self, name, employee_id):
        self.name = name
        self.employee_id = employee_id

    def display_details(self):
        print(f"Name: {self.name} | ID: {self.employee_id}")


class Developer(Employee):
    def __init__(self, name, employee_id, programming_language):
        super().__init__(name, employee_id)
        self.programming_language = programming_language

    def display_details(self):
        print(f"Developer: {self.name} | ID: {self.employee_id} | "
              f"Language: {self.programming_language}")


class Manager(Employee):
    def __init__(self, name, employee_id, team_size):
        super().__init__(name, employee_id)
        self.team_size = team_size

    def display_details(self):
        print(f"Manager: {self.name} | ID: {self.employee_id} | "
              f"Team size: {self.team_size}")


# Q4. Vehicle Rental System - Inheritance
class Vehicle:
    def __init__(self, brand, model, daily_rate):
        self.brand = brand
        self.model = model
        self.daily_rate = daily_rate

    def calculate_rent(self, days):
        if days <= 0:
            raise ValueError("Rental duration must be greater than zero.")
        return self.daily_rate * days


class Car(Vehicle):
    INSURANCE_FEE = 1000

    def calculate_rent(self, days):
        return super().calculate_rent(days) + self.INSURANCE_FEE


class Bike(Vehicle):
    def calculate_rent(self, days):
        return super().calculate_rent(days) * 0.90


# Q5. Notification Dispatcher - Polymorphism
class EmailNotification:
    def send(self, message):
        print(f"Email notification: {message}")


class SMSNotification:
    def send(self, message):
        print(f"SMS notification: {message}")


class PushNotification:
    def send(self, message):
        print(f"Push notification: {message}")


class WhatsAppNotification:
    def send(self, message):
        print(f"WhatsApp notification: {message}")


def notify_all(notifications, message):
    for notification in notifications:
        notification.send(message)


# Q6. Checkout Discount Calculator - Polymorphism
class RegularCustomer:
    discount = 0.05

    def final_price(self, amount):
        if amount < 0:
            raise ValueError("Bill amount cannot be negative.")
        return amount * (1 - self.discount)


class PremiumCustomer:
    discount = 0.10

    def final_price(self, amount):
        if amount < 0:
            raise ValueError("Bill amount cannot be negative.")
        return amount * (1 - self.discount)


class VIPCustomer:
    discount = 0.20

    def final_price(self, amount):
        if amount < 0:
            raise ValueError("Bill amount cannot be negative.")
        return amount * (1 - self.discount)


class GoldCustomer:
    discount = 0.15

    def final_price(self, amount):
        if amount < 0:
            raise ValueError("Bill amount cannot be negative.")
        return amount * (1 - self.discount)


def print_receipt(customer, amount):
    print(f"Final amount: Rs. {customer.final_price(amount):.2f}")


# Q7. Shape Calculator - Abstraction
class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

    @abstractmethod
    def perimeter(self):
        pass


class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return pi * self.radius ** 2

    def perimeter(self):
        return 2 * pi * self.radius


class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)


# Q8. Payment Gateway - Abstraction
class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount):
        pass

    @abstractmethod
    def refund(self, amount):
        pass

    @staticmethod
    def validate_amount(amount):
        if amount <= 0:
            raise ValueError("Transaction amount must be positive.")


class CardPayment(PaymentMethod):
    def pay(self, amount):
        self.validate_amount(amount)
        print(f"Card payment | Payment | Rs. {amount:.2f}")

    def refund(self, amount):
        self.validate_amount(amount)
        print(f"Card payment | Refund | Rs. {amount:.2f}")


class WalletPayment(PaymentMethod):
    def pay(self, amount):
        self.validate_amount(amount)
        print(f"Wallet payment | Payment | Rs. {amount:.2f}")

    def refund(self, amount):
        self.validate_amount(amount)
        print(f"Wallet payment | Refund | Rs. {amount:.2f}")


class BankTransferPayment(PaymentMethod):
    def pay(self, amount):
        self.validate_amount(amount)
        print(f"Bank transfer | Payment | Rs. {amount:.2f}")

    def refund(self, amount):
        self.validate_amount(amount)
        print(f"Bank transfer | Refund | Rs. {amount:.2f}")


def process_transaction(method, amount):
    method.pay(amount)


def main():
    print("\n--- Q1: Student Result Manager ---")
    student = Student("Ali", 85)
    print(student.name, student.get_marks(), student.get_grade())
    student.set_marks(105)
    student.set_marks(55)
    print(student.name, student.get_marks(), student.get_grade())
    try:
        print(student.__grade)
    except AttributeError:
        print("Direct access to private __grade is not allowed.")

    print("\n--- Q2: Secure Bank Account ---")
    account = BankAccount("Ali", 5000, "1234")
    account.deposit(2000)
    account.withdraw(1000, "1234")
    account.deposit(-100)
    account.withdraw(1000, "0000")
    print("Balance:", account.get_balance("1234"))

    print("\n--- Q3: Employee Roles ---")
    Developer("Sara", "D101", "Python").display_details()
    Manager("Ahmed", "M201", 8).display_details()

    print("\n--- Q4: Vehicle Rental System ---")
    car = Car("Toyota", "Corolla", 5000)
    bike = Bike("Honda", "CD70", 1500)
    print(f"Car rent for 3 days: Rs. {car.calculate_rent(3):.2f}")
    print(f"Bike rent for 3 days: Rs. {bike.calculate_rent(3):.2f}")
    try:
        car.calculate_rent(0)
    except ValueError as error:
        print(error)

    print("\n--- Q5: Notification Dispatcher ---")
    notify_all(
        [EmailNotification(), SMSNotification(), PushNotification(),
         WhatsAppNotification()],
        "Your order has been confirmed."
    )

    print("\n--- Q6: Checkout Discount Calculator ---")
    for customer in (RegularCustomer(), PremiumCustomer(), VIPCustomer(),
                    GoldCustomer()):
        print_receipt(customer, 10000)

    print("\n--- Q7: Shape Calculator ---")
    circle = Circle(5)
    rectangle = Rectangle(4, 6)
    print(f"Circle area: {circle.area():.2f}, perimeter: {circle.perimeter():.2f}")
    print(f"Rectangle area: {rectangle.area():.2f}, perimeter: {rectangle.perimeter():.2f}")
    try:
        Shape()
    except TypeError:
        print("Shape is abstract and cannot be instantiated directly.")

    print("\n--- Q8: Payment Gateway ---")
    process_transaction(CardPayment(), 2500)
    process_transaction(WalletPayment(), 1500)
    process_transaction(BankTransferPayment(), 3000)
    CardPayment().refund(500)
    try:
        process_transaction(CardPayment(), 0)
    except ValueError as error:
        print(error)


if __name__ == "__main__":
    main()
