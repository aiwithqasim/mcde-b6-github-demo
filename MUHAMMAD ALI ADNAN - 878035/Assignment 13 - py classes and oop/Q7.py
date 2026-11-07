# Q7. Shape Calculator (Abstraction - Beginner)

from abc import ABC, abstractmethod

PI = 3.14159


class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

    @abstractmethod
    def perimeter(self):
        pass


class Circle(Shape):
    def __init__(self, radius):
        if radius <= 0:
            raise ValueError("Radius must be positive.")
        self.radius = radius

    def area(self):
        return PI * self.radius ** 2

    def perimeter(self):
        return 2 * PI * self.radius


class Rectangle(Shape):
    def __init__(self, width, height):
        if width <= 0 or height <= 0:
            raise ValueError("Width and height must be positive.")
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)


if __name__ == "__main__":
    circle = Circle(5)
    rect = Rectangle(4, 6)

    print("=== Circle (radius 5) ===")
    print(f"  area      = {circle.area():.4f}")
    print(f"  perimeter = {circle.perimeter():.4f}")

    print("\n=== Rectangle (width 4, height 6) ===")
    print(f"  area      = {rect.area():.4f}")
    print(f"  perimeter = {rect.perimeter():.4f}")

    print("\n=== Attempt to instantiate Shape directly ===")
    try:
        Shape()
    except TypeError as e:
        print(f"  TypeError: {e}")
    print("  Explanation: Shape is abstract (inherits ABC and declares @abstractmethod),")
    print("  so Python refuses to create instances of it. Subclasses must implement")
    print("  area() and perimeter() before they can be instantiated.")
