# Question 1
class Student:
    def __init__(self, name, marks):
        self.name = name
        self._marks = 0
        self.__grade = "F"
        self.set_marks(marks)

    def set_marks(self, marks):
        if 0 <= marks <= 100:
            self._marks = marks

            if marks >= 80:
                self.__grade = "A"
            elif marks >= 60:
                self.__grade = "B"
            elif marks >= 40:
                self.__grade = "C"
            else:
                self.__grade = "F"

            print("Marks updated successfully.")
        else:
            print("Invalid marks! Enter marks between 0 and 100.")

    def get_marks(self):
        return self._marks

    def get_grade(self):
        return self.__grade


student = Student("Ali", 75)

print("Name:", student.name)
print("Marks:", student.get_marks())
print("Grade:", student.get_grade())

student.set_marks(90)
print("Updated Marks:", student.get_marks())
print("Updated Grade:", student.get_grade())

student.set_marks(120)

try:
    print(student.__grade)
except AttributeError:
    print("Cannot access private attribute directly.")


# Question 2
class BankAccount:
    def __init__(self, name, balance, pin):
        self.name = name
        self.__balance = balance
        self.__pin = pin

    def deposit(self, amount):
        if amount > 0:
            self.__balance += amount
            print("Deposit successful.")
        else:
            print("Invalid deposit amount.")

    def withdraw(self, amount, pin):
        if pin != self.__pin:
            print("Incorrect PIN.")
        elif amount <= 0:
            print("Invalid withdrawal amount.")
        elif amount > self.__balance:
            print("Insufficient balance.")
        else:
            self.__balance -= amount
            print("Withdrawal successful.")

    def get_balance(self, pin):
        if pin == self.__pin:
            return self.__balance
        else:
            print("Incorrect PIN.")
            return None


account = BankAccount("Ali", 10000, 1234)

print("\nAccount Holder:", account.name)

account.deposit(5000)
account.withdraw(2000, 1234)
account.deposit(-500)
account.withdraw(1000, 9999)

print("Current Balance:", account.get_balance(1234))


# Question 3
class Employee:
    def __init__(self, name, employee_id):
        self.name = name
        self.employee_id = employee_id

    def display_details(self):
        print("Name:", self.name)
        print("Employee ID:", self.employee_id)


class Developer(Employee):
    def __init__(self, name, employee_id, language):
        super().__init__(name, employee_id)
        self.language = language

    def display_details(self):
        print("\nDeveloper Details")
        super().display_details()
        print("Programming Language:", self.language)


class Manager(Employee):
    def __init__(self, name, employee_id, team_size):
        super().__init__(name, employee_id)
        self.team_size = team_size

    def display_details(self):
        print("\nManager Details")
        super().display_details()
        print("Team Size:", self.team_size)


developer = Developer("Ali", 101, "Python")
manager = Manager("Ahmed", 102, 8)

developer.display_details()
manager.display_details()


# Question 4
class Vehicle:
    def __init__(self, brand, model, daily_rate):
        self.brand = brand
        self.model = model
        self.daily_rate = daily_rate

    def calculate_rent(self, days):
        if days <= 0:
            raise ValueError("Rental days must be greater than zero.")

        return self.daily_rate * days


class Car(Vehicle):
    def calculate_rent(self, days):
        rent = super().calculate_rent(days)
        return rent + 1000


class Bike(Vehicle):
    def calculate_rent(self, days):
        rent = super().calculate_rent(days)
        return rent * 0.90


car = Car("Toyota", "Corolla", 5000)
bike = Bike("Honda", "CD 70", 1500)

try:
    print("\nCar Rent:", car.calculate_rent(3))
    print("Bike Rent:", bike.calculate_rent(3))
except ValueError as error:
    print(error)


# Question 5
class EmailNotification:
    def send(self, message):
        print("Email Notification:", message)


class SMSNotification:
    def send(self, message):
        print("SMS Notification:", message)


class PushNotification:
    def send(self, message):
        print("Push Notification:", message)


class WhatsAppNotification:
    def send(self, message):
        print("WhatsApp Notification:", message)


def notify_all(notifications, message):
    for notification in notifications:
        notification.send(message)


email = EmailNotification()
sms = SMSNotification()
push = PushNotification()
whatsapp = WhatsAppNotification()

notifications = [email, sms, push, whatsapp]

notify_all(notifications, "Your order has been confirmed.")


# Question 6
class RegularCustomer:
    def final_price(self, amount):
        if amount < 0:
            raise ValueError("Bill amount cannot be negative.")

        return amount - (amount * 0.05)


class PremiumCustomer:
    def final_price(self, amount):
        if amount < 0:
            raise ValueError("Bill amount cannot be negative.")

        return amount - (amount * 0.10)


class VIPCustomer:
    def final_price(self, amount):
        if amount < 0:
            raise ValueError("Bill amount cannot be negative.")

        return amount - (amount * 0.20)


class GoldCustomer:
    def final_price(self, amount):
        if amount < 0:
            raise ValueError("Bill amount cannot be negative.")

        return amount - (amount * 0.15)


def print_receipt(customer, amount):
    print("Original Amount: Rs.", amount)
    print("Final Amount: Rs.", customer.final_price(amount))
    print("------------------------")


regular = RegularCustomer()
premium = PremiumCustomer()
vip = VIPCustomer()
gold = GoldCustomer()

print("\nRegular Customer")
print_receipt(regular, 10000)

print("Premium Customer")
print_receipt(premium, 10000)

print("VIP Customer")
print_receipt(vip, 10000)

print("Gold Customer")
print_receipt(gold, 10000)


# Question 7
from abc import ABC, abstractmethod


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
        pi = 3.14159
        return pi * self.radius * self.radius

    def perimeter(self):
        pi = 3.14159
        return 2 * pi * self.radius


class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)


circle = Circle(5)
rectangle = Rectangle(4, 6)

print("\nCircle")
print("Area:", circle.area())
print("Perimeter:", circle.perimeter())

print("\nRectangle")
print("Area:", rectangle.area())
print("Perimeter:", rectangle.perimeter())

try:
    shape = Shape()
except TypeError:
    print("Cannot create an object of abstract Shape class.")


# Question 8
from abc import ABC, abstractmethod


class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount):
        pass

    @abstractmethod
    def refund(self, amount):
        pass


class CardPayment(PaymentMethod):
    def pay(self, amount):
        if amount <= 0:
            print("Invalid payment amount.")
            return

        print("Method: Card")
        print("Transaction: Payment")
        print("Amount: Rs.", amount)

    def refund(self, amount):
        if amount <= 0:
            print("Invalid refund amount.")
            return

        print("Method: Card")
        print("Transaction: Refund")
        print("Amount: Rs.", amount)


class WalletPayment(PaymentMethod):
    def pay(self, amount):
        if amount <= 0:
            print("Invalid payment amount.")
            return

        print("Method: Wallet")
        print("Transaction: Payment")
        print("Amount: Rs.", amount)

    def refund(self, amount):
        if amount <= 0:
            print("Invalid refund amount.")
            return

        print("Method: Wallet")
        print("Transaction: Refund")
        print("Amount: Rs.", amount)


class BankTransferPayment(PaymentMethod):
    def pay(self, amount):
        if amount <= 0:
            print("Invalid payment amount.")
            return

        print("Method: Bank Transfer")
        print("Transaction: Payment")
        print("Amount: Rs.", amount)

    def refund(self, amount):
        if amount <= 0:
            print("Invalid refund amount.")
            return

        print("Method: Bank Transfer")
        print("Transaction: Refund")
        print("Amount: Rs.", amount)


class CashPayment(PaymentMethod):
    def pay(self, amount):
        if amount <= 0:
            print("Invalid payment amount.")
            return

        print("Method: Cash")
        print("Transaction: Payment")
        print("Amount: Rs.", amount)

    def refund(self, amount):
        if amount <= 0:
            print("Invalid refund amount.")
            return

        print("Method: Cash")
        print("Transaction: Refund")
        print("Amount: Rs.", amount)


def process_transaction(method, amount):
    method.pay(amount)


card = CardPayment()
wallet = WalletPayment()
bank = BankTransferPayment()
cash = CashPayment()

print("\nCard Payment")
process_transaction(card, 5000)

print("\nWallet Payment")
process_transaction(wallet, 3000)

print("\nBank Transfer")
process_transaction(bank, 7000)

print("\nCash Payment")
process_transaction(cash, 2000)

print("\nCard Refund")
card.refund(1000)

print("\nInvalid Payment")
process_transaction(wallet, -500)