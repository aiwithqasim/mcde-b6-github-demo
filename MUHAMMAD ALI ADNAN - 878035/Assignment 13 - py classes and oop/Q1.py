# Q1. Student Result Manager (Encapsulation - Beginner)


class Student:
    def __init__(self, name, marks):
        self.name = name        # public attribute
        self._marks = 0         # protected attribute
        self.__grade = "F"      # private attribute
        self.set_marks(marks)

    def set_marks(self, marks):
        if not (0 <= marks <= 100):
            print(f"  [REJECTED] Invalid marks {marks} for {self.name}: must be between 0 and 100.")
            return
        self._marks = marks
        if marks >= 80:
            self.__grade = "A"
        elif marks >= 60:
            self.__grade = "B"
        elif marks >= 40:
            self.__grade = "C"
        else:
            self.__grade = "F"
        print(f"  [OK] {self.name}'s marks set to {self._marks} -> Grade {self.__grade}")

    def get_marks(self):
        return self._marks

    def get_grade(self):
        return self.__grade


if __name__ == "__main__":
    print("=== Test 1: valid marks update ===")
    ali = Student("Ali", 85)
    print(f"  get_marks() = {ali.get_marks()}, get_grade() = {ali.get_grade()}")

    print("\n=== Test 2: invalid marks update (out of range) ===")
    ali.set_marks(150)
    print(f"  Marks unchanged: {ali.get_marks()}, Grade still: {ali.get_grade()}")

    print("\n=== Test 3: another student, valid update ===")
    sara = Student("Sara", 55)
    sara.set_marks(65)
    print(f"  get_marks() = {sara.get_marks()}, get_grade() = {sara.get_grade()}")

    print("\n=== Extension: direct access to __grade ===")
    print(f"  ali._marks          -> {ali._marks}  (works: protected, convention-only)")
    try:
        print(f"  ali.__grade         -> {ali.__grade}")
    except AttributeError as e:
        print(f"  ali.__grade         -> AttributeError: {e}")
    print(f"  ali._Student__grade -> {ali._Student__grade}  (name mangling workaround)")
    print("  Explanation: Python renames __grade to _Student__grade behind the scenes,")
    print("  so external code cannot access it directly. This prevents accidental access")
    print("  but is NOT true security (it can still be read via the mangled name).")
