class Student:

  def __init__(self, name, marks):
    self.name = name  # Public attribute
    self._marks = 0  # Protected attribute initialized via setter
    self.__grade = "F"  # Private attribute
    self.set_marks(marks)  # Validate and set marks & grade

  def set_marks(self, marks):
    if 0 <= marks <= 100:
      self._marks = marks
      self.__calculate_grade()
    else:
      print(
          f"❌ Error: Invalid marks ({marks}). Marks must be between 0 and 100."
      )

  def __calculate_grade(self):
    """Private helper method to determine grade based on marks."""
    if self._marks >= 80:
      self.__grade = "A"
    elif self._marks >= 60:
      self.__grade = "B"
    elif self._marks >= 40:
      self.__grade = "C"
    else:
      self.__grade = "F"

  def get_marks(self):
    return self._marks

  def get_grade(self):
    return self.__grade


# --- Demonstration ---
if __name__ == "__main__":
  print("--- Q1: Student Result Manager Demonstration ---")
  student1 = Student("Alice", 85)
  print(
      f"Student: {student1.name}, Marks: {student1.get_marks()}, Grade:"
      f" {student1.get_grade()}"
  )

  # Test valid update
  print("\nUpdating marks to 72...")
  student1.set_marks(72)
  print(
      f"Updated Marks: {student1.get_marks()}, New Grade:"
      f" {student1.get_grade()}"
  )

  # Test invalid update
  print("\nAttempting invalid marks update (105)...")
  student1.set_marks(105)

  # Extension: Direct access to __grade
  print("\n--- Extension: Direct Access to Private Attribute ---")
  try:
    print(student1.__grade)
  except AttributeError as e:
    print(f"Caught expected AttributeError: {e}")

  # Accessing via name mangling
  print(
      "Accessing via name mangling (_Student__grade):"
      f" {student1._Student__grade}"
  )