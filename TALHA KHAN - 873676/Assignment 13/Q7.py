"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assignment   : Assignment 13 - Python Classes and OOP
Pillar 4     : Abstraction
Question 7   : Shape Calculator | Beginner
=============================================================================
"""
from abc import ABC, abstractmethod

# Abstract Base Class Shape: Structure aur rules enforce karne ke liye
class Shape(ABC):
    # Abstract Method 1: Jo shape bhi banegi, area ka formula lazmi likhegi
    @abstractmethod
    def area(self) -> float:
        pass

    # Abstract Method 2: Perimeter ka formula bhi lazmi implement karna hoga
    @abstractmethod
    def perimeter(self) -> float:
        pass


# Concrete Class 1: Circle (Shape se inherit kar ke formulas implement kiye)
class Circle(Shape):
    PI: float = 3.14159

    def __init__(self, radius: float):
        if radius <= 0:
            raise ValueError("Circle ka radius 0 se barha hona chahiye.")
        self.radius: float = float(radius)

    # Circle ka area: pi * r^2
    def area(self) -> float:
        return self.PI * (self.radius ** 2)

    # Circle ka perimeter: 2 * pi * r
    def perimeter(self) -> float:
        return 2 * self.PI * self.radius


# Concrete Class 2: Rectangle (Shape ke abstract methods implement kiye)
class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        if width <= 0 or height <= 0:
            raise ValueError("Width aur Height positive honi chahiye.")
        self.width: float = float(width)
        self.height: float = float(height)

    # Rectangle ka area: width * height
    def area(self) -> float:
        return self.width * self.height

    # Rectangle ka perimeter: 2 * (width + height)
    def perimeter(self) -> float:
        return 2 * (self.width + self.height)


# =============================================================================
# Testing & Demonstration
# =============================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("PILLAR 4 - Q7: SHAPE CALCULATOR (ABSTRACTION)")
    print("Student: TALHA KHAN | Roll No: 873676")
    print("=" * 70)

    # 1. Circle with radius 5
    circle = Circle(radius=5)
    print(f"Circle (Radius: {circle.radius}):")
    print(f"  Area      : {circle.area():.4f}")
    print(f"  Perimeter : {circle.perimeter():.4f}\n")

    # 2. Rectangle with width 4 and height 6
    rect = Rectangle(width=4, height=6)
    print(f"Rectangle (Width: {rect.width}, Height: {rect.height}):")
    print(f"  Area      : {rect.area():.4f}")
    print(f"  Perimeter : {rect.perimeter():.4f}\n")

    # 3. Extension: Shape class ka direct object banane ki koshish
    print("--- [Extension] Abstract Class 'Shape' Ka Direct Object Banane Ki Koshish ---")
    try:
        # Ye line error degi kyunke abstract class ka direct object nahi ban sakta
        shape_instance = Shape()
    except TypeError as err:
        print(f"Pakra gaya Expected TypeError: {err}")
        print("\nWAZAHAT (EXPLANATION):")
        print("Python me jab kisi class me '@abstractmethod' hota hai, to uska direct object nahi ban sakta.")
        print("Isko Abstraction kehte hain: Base class sirf naqsha (rules) deti hai, asal implementation")
        print("child classes (Circle, Rectangle) karti hain.")
