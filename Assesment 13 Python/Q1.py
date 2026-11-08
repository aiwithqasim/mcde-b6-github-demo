# Q1: Student Result Manager - Encapsulation

class Student:
    def __init__(self, name, marks):
        self.name = name                 # Public attribute
        self._marks = 0                  # Protected attribute
        self.__grade = "F"               # Private attribute
        self.set_marks(marks)

    def set_marks(self, marks):
        """Update marks only when they are between 0 and 100."""
        if not isinstance(marks, (int, float)) or isinstance(marks, bool):
            print("Invalid marks: enter a number from 0 to 100.")
            return False

        if not 0 <= marks <= 100:
            print("Invalid marks: marks must be between 0 and 100.")
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


if __name__ == "__main__":
    student1 = Student("Ali", 85)
    student2 = Student("Sara", 55)

    print(f"{student1.name}: Marks = {student1.get_marks()}, Grade = {student1.get_grade()}")
    print(f"{student2.name}: Marks = {student2.get_marks()}, Grade = {student2.get_grade()}")

    print("\\nUpdating Ali's marks to 92:")
    student1.set_marks(92)
    print(f"Updated marks = {student1.get_marks()}, Grade = {student1.get_grade()}")

    print("\\nTrying invalid marks (120):")
    student1.set_marks(120)
    print(f"Marks remain = {student1.get_marks()}, Grade = {student1.get_grade()}")

    print("\\nTrying direct access to private __grade:")
    try:
        print(student1.__grade)
    except AttributeError as error:
        print("AttributeError:", error)

    # Python name-mangles __grade; this is possible but should not be used:
    print("Name-mangled value (for demonstration only):", student1._Student__grade)
