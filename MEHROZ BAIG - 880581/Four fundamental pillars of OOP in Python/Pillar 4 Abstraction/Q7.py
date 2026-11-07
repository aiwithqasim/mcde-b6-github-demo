from abc import ABC, abstractmethod
import math


class Shape(ABC):

  @abstractmethod
  def area(self):
    pass

  @abstractmethod
  def perimeter(self):
    pass


class Rectangle(Shape):

  def __init__(self, width, height):
    self.width = width
    self.height = height

  def area(self):
    return self.width * self.height

  def perimeter(self):
    return 2 * (self.width + self.height)


class Circle(Shape):

  def __init__(self, radius):
    self.radius = radius

  def area(self):
    return math.pi * (self.radius**2)

  def perimeter(self):
    return 2 * math.pi * self.radius


# --- Demonstration ---
if __name__ == "__main__":
  print("--- Q7: Shape Hierarchy Demonstration ---")
  shapes = [Rectangle(10, 5), Circle(7)]

  for shape in shapes:
    name = type(shape).__name__
    print(
        f"{name} -> Area: {shape.area():.2f}, Perimeter:"
        f" {shape.perimeter():.2f}"
    )

  print("\nTrying to instantiate abstract Shape class directly:")
  try:
    invalid_shape = Shape()
  except TypeError as e:
    print(f"Caught expected TypeError: {e}")