class Student:
    def __init__(self, name, marks):
        self.name = name          # Public attribute
        self._marks = None        # Protected attribute
        self.__grade = None       # Private attribute
        self.set_marks(marks)     # Marks aur grade set karne k liye helper

    def __calculate_grade(self):
        # Grade calculate karne ka private method
        if self._marks >= 80:
            self.__grade = 'A'
        elif self._marks >= 60:
            self.__grade = 'B'
        elif self._marks >= 40:
            self.__grade = 'C'
        else:
            self.__grade = 'F'
    
    def set_marks(self, marks):
        # Validation: Marks 0 se 100 k beech hone chahiye
        if 0 <= marks <= 100:
            self._marks = marks
            self.__calculate_grade()
        
        else:
            # Print ki bajaye ValueError raise karna behtar practice hai
            raise ValueError(f"❌ Invalid Marks: {marks}. Marks must be between 0 and 100.")

    def get_marks(self):
        return self._marks

    def get_grade(self):
        return self.__grade

# --- Test Cases ---

print("--- Test Case 1: Valid Student Creation ---")
student1 = Student("Ali", 85)
print(f"Name: {student1.name}")
print(f"Marks: {student1.get_marks()}")
print(f"Grade: {student1.get_grade()}")

print("\n--- Test Case 2: Valid Marks Update ---")
student1.set_marks(65)
print(f"Updated Marks: {student1.get_marks()}")
print(f"Updated Grade: {student1.get_grade()}")

print("\n--- Test Case 3: Invalid Marks Update ---")
try:
    student1.set_marks(120)  # Yeh error throw karega
except ValueError as e:
    print(e)
    # Tasalli ke liye check karte hain ke object ka data change to nahi hua:
    print(f"Current Marks (unchanged): {student1.get_marks()}") 

print("\n--- Extension: Attempting Direct Access to Private Attribute __grade ---")
try:
    print(student1.__grade)
except AttributeError as e:
    print(f"Error caught successfully: {e}")
