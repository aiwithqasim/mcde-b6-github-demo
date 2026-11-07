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
        self.pi = 3.14159

    def area(self):
        return self.pi * (self.radius ** 2)

    def perimeter(self):
        return 2 * self.pi * self.radius


class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)


# --- Test Cases ---
print("--- Testing Circle (Radius = 5) ---")
my_circle = Circle(5)
print(f"Circle Area: {my_circle.area():.5f}")
print(f"Circle Perimeter: {my_circle.perimeter():.5f}")

print("\n--- Testing Rectangle (Width = 4, Height = 6) ---")
my_rect = Rectangle(4, 6)
print(f"Rectangle Area: {my_rect.area()}")
print(f"Rectangle Perimeter: {my_rect.perimeter()}")

print("\n--- Extension: Attempting to Instantiate Shape Directly ---")
try:
    abstract_shape = Shape()
except TypeError as e:
    print(f"Error caught successfully: {e}")
