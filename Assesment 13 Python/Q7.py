# Q7: Shape Calculator - Abstraction

from abc import ABC, abstractmethod
import math


class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

    @abstractmethod
    def perimeter(self):
        pass


class Circle(Shape):
    PI = 3.14159

    def __init__(self, radius):
        if radius <= 0:
            raise ValueError("Radius must be positive.")
        self.radius = radius

    def area(self):
        return self.PI * self.radius ** 2

    def perimeter(self):
        return 2 * self.PI * self.radius


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
    rectangle = Rectangle(4, 6)

    print(f"Circle area: {circle.area():.5f}")
    print(f"Circle perimeter: {circle.perimeter():.5f}")
    print(f"Rectangle area: {rectangle.area():.2f}")
    print(f"Rectangle perimeter: {rectangle.perimeter():.2f}")

    try:
        shape = Shape()
    except TypeError as error:
        print("Cannot create Shape directly:", error)

    # Shape is abstract. Its abstract methods must be implemented by subclasses.
