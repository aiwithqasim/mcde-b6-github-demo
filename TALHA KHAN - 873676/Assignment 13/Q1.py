"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assignment   : Assignment 13 - Python Classes and OOP
Pillar 1     : Encapsulation
Question 1   : Student Result Manager | Beginner
=============================================================================
"""

# Student Class: Encapsulation (Data Hiding) dikhane ke liye
class Student:
    def __init__(self, name: str, marks: float):
        # Public attribute: Isko koi bhi bahar se direct access aur change kar sakta hai
        self.name: str = name
        
        # Protected attribute: Single underscore convention (sirf class aur subclasses ke liye)
        self._marks: float = 0.0
        
        # Private attribute: Double underscore (bahar se direct access block / hidden)
        self.__grade: str = "F"
        
        # Setter method ke zariye marks set karna taake validation check ho
        self.set_marks(marks)

    # Marks update karne ka method (validation ke sath)
    def set_marks(self, marks: float) -> bool:
        # Check karna ke marks 0 se 100 ke darmiyan hain ya nahi
        if not (isinstance(marks, (int, float)) and 0 <= marks <= 100):
            print(f"[Error] Invalid marks: {marks}. Marks lazmi 0 se 100 ke beech hone chahiye.")
            return False

        # Agar marks valid hain to set karo
        self._marks = float(marks)

        # Marks ke mutabiq private grade calculate karna
        # 80 se 100: Grade A | 60 se 79: Grade B | 40 se 59: Grade C | 40 se kam: Grade F
        if self._marks >= 80:
            self.__grade = "A"
        elif self._marks >= 60:
            self.__grade = "B"
        elif self._marks >= 40:
            self.__grade = "C"
        else:
            self.__grade = "F"

        print(f"[Success] '{self.name}' ke marks {self._marks} set ho gaye. Grade: {self.__grade}")
        return True

    # Getter method: Protected marks dekhne ke liye
    def get_marks(self) -> float:
        return self._marks

    # Getter method: Private grade safe tareeqay se dekhne ke liye
    def get_grade(self) -> str:
        return self.__grade


# =============================================================================
# Testing & Demonstration
# =============================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("PILLAR 1 - Q1: STUDENT RESULT MANAGER (ENCAPSULATION)")
    print("Student: TALHA KHAN | Roll No: 873676")
    print("=" * 70)

    # 1. Constructor ke zariye student ka object banaya
    s1 = Student(name="Talha Khan", marks=85)
    print(f"Student Name : {s1.name}")
    print(f"Marks (getter se) : {s1.get_marks()}")
    print(f"Grade (getter se) : {s1.get_grade()}")

    # 2. Sahi marks update karke test karna (Valid marks update)
    print("\n--- [Test 1] Sahi Marks Update Karna (72 marks) ---")
    s1.set_marks(72)
    print(f"Updated Marks: {s1.get_marks()} | Grade: {s1.get_grade()}")

    # 3. Galat marks de kar rejection test karna (Invalid marks update)
    print("\n--- [Test 2] Galat Marks Update Karna (110 aur -15) ---")
    s1.set_marks(110)  # 100 se barha number reject hoga
    s1.set_marks(-15)  # Negative number reject hoga
    print(f"Marks change nahi huay (Protected): {s1.get_marks()} | Grade: {s1.get_grade()}")

    # 4. Extension: Private variable ko bahar se direct access karne ki koshish
    print("\n--- [Extension] Direct Private Attribute '__grade' Access Karne Ka Test ---")
    try:
        # Ye line error degi kyunke __grade private hai
        print(s1.__grade)
    except AttributeError as err:
        print(f"Pakra gaya Expected Error: {err}")
        print("\nWAZAHAT (EXPLANATION):")
        print("Python me double underscore ('__grade') lagane se 'Name Mangling' ho jati hai.")
        print("Python internally iska naam badal kar '_Student__grade' rakh deta hai.")
        print("Isi wajah se direct 's1.__grade' likhne par AttributeError aata hai aur data hide rehta hai.")
