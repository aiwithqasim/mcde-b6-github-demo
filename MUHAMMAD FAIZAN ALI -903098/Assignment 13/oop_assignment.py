# Python OOP: 

# PILLAR 1: ENCAPSULATION

# Q1. Student Result Manager

# class Student:
#     def __init__(self, name, marks=0):
#         self.name = name       
#         self._marks = 0           
#         self.__grade = "F"       
#         self.set_marks(marks)

#     def set_marks(self, marks):
#         """Accept only marks from 0 to 100."""
#         if isinstance(marks, (int, float)) and 0 <= marks <= 100:
#             self._marks = marks
#             self.__grade = self.__calculate_grade()
#             print(f"[OK] Marks updated to {marks} for {self.name}.")
#             return True
#         print(f"[ERROR] Invalid marks '{marks}' for {self.name}. Must be 0 to 100.")
#         return False

#     def __calculate_grade(self):
#         if self._marks >= 80:
#             return "A"
#         elif self._marks >= 60:
#             return "B"
#         elif self._marks >= 40:
#             return "C"
#         return "F"

#     def get_marks(self):
#         return self._marks

#     def get_grade(self):
#         return self.__grade


# print("Q1: Student Result Manager ")
# s1 = Student("Ali", 85)
# s2 = Student("Sara", 55)

# print(f"{s1.name}: Marks = {s1.get_marks()}, Grade = {s1.get_grade()}")
# print(f"{s2.name}: Marks = {s2.get_marks()}, Grade = {s2.get_grade()}")

# print("\n-- Valid update --")
# s2.set_marks(72)
# print(f"{s2.name}: Marks = {s2.get_marks()}, Grade = {s2.get_grade()}")

# print("\n-- Invalid update --")
# s2.set_marks(150)
# print(f"{s2.name}: Marks = {s2.get_marks()}, Grade = {s2.get_grade()}")

# print("\n-- Extension: direct access to __grade --")
# try:
#     print(s1.__grade)
# except AttributeError as e:
#     print("AttributeError:", e)

# print("Via mangled name:", s1._Student__grade)


# Q2. Secure Bank Account

# class BankAccount:
#     def __init__(self, holder_name, initial_balance, pin):
#         self.holder_name = holder_name    
#         self.__balance = initial_balance  
#         self.__pin = pin                  

#     def __verify_pin(self, pin):
#         return pin == self.__pin

#     def deposit(self, amount):
#         if amount <= 0:
#             print("[REJECTED] Deposit must be greater than zero.")
#             return False
#         self.__balance += amount
#         print(f"[OK] Deposited Rs. {amount}. ")
#         return True

#     def withdraw(self, amount, pin):
#         if not self.__verify_pin(pin):
#             print("[REJECTED] Incorrect PIN.")
#             return False
#         if amount <= 0:
#             print("[REJECTED] Withdrawal must be greater than zero.")
#             return False
#         if amount > self.__balance:
#             print("[REJECTED] Insufficient balance.")
#             return False
#         self.__balance -= amount
#         print(f"[OK] Withdrew Rs. {amount}.")
#         return True

#     def get_balance(self, pin):
#         if not self.__verify_pin(pin):
#             print("[REJECTED] Incorrect PIN. Cannot show balance.")
#             return None
#         return self.__balance


# print("Q2: Secure Bank Account ")
# acc1 = BankAccount("Ahmed", 5000, 1234)
# acc2 = BankAccount("Fatima", 10000, 9999)

# print("\n-- Account 1 (Ahmed) --")
# acc1.deposit(2000)                                 
# acc1.withdraw(1500, 1234)                           
# acc1.withdraw(500, 1111)                         
# acc1.withdraw(50000, 1234)                          
# print("Balance:", acc1.get_balance(1234))

# print("\n-- Account 2 (Fatima) --")
# acc2.deposit(-100)                                 
# acc2.withdraw(2000, 9999)
# print("Balance:", acc2.get_balance(9999))

# print("\n-- Extension --")
# print("Private balance read via mangled name:", acc1._BankAccount__balance)
# print("Private PIN read via mangled name:", acc1._BankAccount__pin)



# PILLAR 2: INHERITANCE

# Q3. Employee Roles

# class Employee:
#     def __init__(self, name, emp_id):
#         self.name = name
#         self.emp_id = emp_id

#     def display_details(self):
#         print(f"Name: {self.name} | Employee ID: {self.emp_id}")


# class Developer(Employee):
#     def __init__(self, name, emp_id, programming_language):
#         super().__init__(name, emp_id)
#         self.programming_language = programming_language

#     def display_details(self):
#         print(f"[Developer] Name: {self.name} | ID: {self.emp_id} | "
#               f"Language: {self.programming_language}")


# class Manager(Employee):
#     def __init__(self, name, emp_id, team_size):
#         super().__init__(name, emp_id)
#         self.team_size = team_size

#     def display_details(self):
#         print(f"[Manager] Name: {self.name} | ID: {self.emp_id} | "
#               f"Team Size: {self.team_size}")


# print("Q3: Employee Roles ")
# emp = Employee("Usman", 101)
# dev = Developer("Ayesha", 102, "Python")
# mgr = Manager("Bilal", 103, 8)

# emp.display_details()
# dev.display_details()
# mgr.display_details()


# Q4. Vehicle Rental System

# class Vehicle:
#     def __init__(self, brand, model, daily_rate):
#         self.brand = brand
#         self.model = model
#         self.daily_rate = daily_rate

#     def calculate_rent(self, days):
#         if days <= 0:
#             raise ValueError("Rental duration must be at least 1 day.")
#         return self.daily_rate * days


# class Car(Vehicle):
#     INSURANCE_FEE = 1000

#     def calculate_rent(self, days):
#         base = super().calculate_rent(days)
#         return base + Car.INSURANCE_FEE


# class Bike(Vehicle):
#     DISCOUNT = 0.10

#     def calculate_rent(self, days):
#         base = super().calculate_rent(days)
#         return base - (base * Bike.DISCOUNT)


# print("Q4: Vehicle Rental System ")
# car = Car("Toyota", "Corolla", 5000)
# bike = Bike("Honda", "CD70", 1000)

# print(f"Car  ({car.brand} {car.model}) rent for 3 days: Rs. {car.calculate_rent(3):,.2f}")
# print(f"Bike ({bike.brand} {bike.model}) rent for 3 days: Rs. {bike.calculate_rent(3):,.2f}")

# print("\n-- Invalid duration --")
# for v in (car, bike):
#     try:
#         v.calculate_rent(0)
#     except ValueError as e:
#         print(f"{v.model}: Error - {e}")


# PILLAR 3: POLYMORPHISM

# Q5. Notification Dispatcher

# class EmailNotification:
#     def send(self, message):
#         print(f"[EMAIL] Sending email: {message}")


# class SMSNotification:
#     def send(self, message):
#         print(f"[SMS] Sending text message: {message}")


# class PushNotification:
#     def send(self, message):
#         print(f"[PUSH] Sending push alert: {message}")


# def notify_all(notifications, message):
#     for notification in notifications:
#         notification.send(message)    # polymorphism happens here


# # New class added later - notify_all() is NOT modified
# class WhatsAppNotification:
#     def send(self, message):
#         print(f"[WHATSAPP] Sending WhatsApp message: {message}")


# print("Q5: Notification Dispatcher ")
# channels = [EmailNotification(), SMSNotification(), PushNotification()]
# notify_all(channels, "Your order has been shipped!")

# print("\n-- After adding WhatsAppNotification --")
# channels.append(WhatsAppNotification())
# notify_all(channels, "Your order is out for delivery!")



# Q6. Checkout Discount Calculator

# class RegularCustomer:
#     discount_rate = 0.05

#     def final_price(self, amount):
#         if amount < 0:
#             raise ValueError("Bill amount cannot be negative.")
#         return amount - (amount * self.discount_rate)


# class PremiumCustomer:
#     discount_rate = 0.10

#     def final_price(self, amount):
#         if amount < 0:
#             raise ValueError("Bill amount cannot be negative.")
#         return amount - (amount * self.discount_rate)


# class VIPCustomer:
#     discount_rate = 0.20

#     def final_price(self, amount):
#         if amount < 0:
#             raise ValueError("Bill amount cannot be negative.")
#         return amount - (amount * self.discount_rate)


# def print_receipt(customer, amount):
#     final = customer.final_price(amount)    
#     print(f"{type(customer).__name__:<17} | Bill: Rs. {amount:,.2f} | "
#           f"Final: Rs. {final:,.2f}")


# class GoldCustomer:
#     discount_rate = 0.15

#     def final_price(self, amount):
#         if amount < 0:
#             raise ValueError("Bill amount cannot be negative.")
#         return amount - (amount * self.discount_rate)


# print("Q6: Checkout Discount Calculator ")
# bill = 10000
# for c in (RegularCustomer(), PremiumCustomer(), VIPCustomer()):
#     print_receipt(c, bill)

# print("\n-- Extension: GoldCustomer --")
# print_receipt(GoldCustomer(), bill)

# print("\n-- Negative bill --")
# try:
#     print_receipt(RegularCustomer(), -500)
# except ValueError as e:
#     print("Error:", e)


# PILLAR 4: ABSTRACTION

# Q7. Shape Calculator

# from abc import ABC, abstractmethod

# PI = 3.14159


# class Shape(ABC):
#     @abstractmethod
#     def area(self):
#         pass

#     @abstractmethod
#     def perimeter(self):
#         pass


# class Circle(Shape):
#     def __init__(self, radius):
#         self.radius = radius

#     def area(self):
#         return PI * self.radius ** 2

#     def perimeter(self):
#         return 2 * PI * self.radius


# class Rectangle(Shape):
#     def __init__(self, width, height):
#         self.width = width
#         self.height = height

#     def area(self):
#         return self.width * self.height

#     def perimeter(self):
#         return 2 * (self.width + self.height)


# print("Q7: Shape Calculator ")
# circle = Circle(5)
# rect = Rectangle(4, 6)

# print(f"Circle (radius 5):        Area = {circle.area():.2f}, Perimeter = {circle.perimeter():.2f}")
# print(f"Rectangle (4 x 6):        Area = {rect.area():.2f}, Perimeter = {rect.perimeter():.2f}")

# print("\n-- Instantiating abstract Shape directly --")
# try:
#     s = Shape()
# except TypeError as e:
#     print("TypeError:", e)



# Q8. Payment Gateway   (ACTIVE - this is the only uncommented question)

from abc import ABC, abstractmethod


class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount):
        pass

    @abstractmethod
    def refund(self, amount):
        pass

    @staticmethod
    def _validate(amount):
        if amount <= 0:
            raise ValueError("Transaction amount must be positive.")


class CardPayment(PaymentMethod):
    def pay(self, amount):
        self._validate(amount)
        print(f"Method: Card | Type: Payment | Amount: Rs. {amount:,.2f}")

    def refund(self, amount):
        self._validate(amount)
        print(f"Method: Card | Type: Refund  | Amount: Rs. {amount:,.2f}")


class WalletPayment(PaymentMethod):
    def pay(self, amount):
        self._validate(amount)
        print(f"Method: Wallet | Type: Payment | Amount: Rs. {amount:,.2f}")

    def refund(self, amount):
        self._validate(amount)
        print(f"Method: Wallet | Type: Refund  | Amount: Rs. {amount:,.2f}")


class BankTransferPayment(PaymentMethod):
    def pay(self, amount):
        self._validate(amount)
        print(f"Method: Bank Transfer | Type: Payment | Amount: Rs. {amount:,.2f}")

    def refund(self, amount):
        self._validate(amount)
        print(f"Method: Bank Transfer | Type: Refund  | Amount: Rs. {amount:,.2f}")


def process_transaction(method, amount):
    method.pay(amount)    # works with any PaymentMethod


class CryptoPayment(PaymentMethod):
    def pay(self, amount):
        self._validate(amount)
        print(f"Method: Crypto | Type: Payment | Amount: Rs. {amount:,.2f}")

    def refund(self, amount):
        self._validate(amount)
        print(f"Method: Crypto | Type: Refund  | Amount: Rs. {amount:,.2f}")


print("Q8: Payment Gateway ")
methods = [CardPayment(), WalletPayment(), BankTransferPayment()]

print("\n-- Payments --")
for m in methods:
    process_transaction(m, 2500)

print("\n-- Refunds --")
for m in methods:
    m.refund(500)

print("\n-- Invalid amounts --")
for amt in (0, -300):
    try:
        process_transaction(CardPayment(), amt)
    except ValueError as e:
        print(f"Amount {amt}: Error - {e}")

print("\n-- Extension: CryptoPayment (process_transaction unchanged) --")
process_transaction(CryptoPayment(), 4000)

print("\n-- Abstract class cannot be instantiated --")
try:
    PaymentMethod()
except TypeError as e:
    print("TypeError:", e)
