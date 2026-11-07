"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assignment   : Assignment 13 - Python Classes and OOP
Pillar 2     : Inheritance
Question 3   : Employee Roles | Beginner
=============================================================================
"""

# Parent Class Employee: Common attributes (name aur id) store karne ke liye
class Employee:
    def __init__(self, name: str, employee_id: int):
        self.name: str = name
        self.employee_id: int = employee_id

    # Base details print karne ka method
    def display_details(self):
        print(f"ID: {self.employee_id} | Name: {self.name}", end="")


# Child Class 1: Developer (Employee class se inherit kiya)
class Developer(Employee):
    def __init__(self, name: str, employee_id: int, programming_language: str):
        # super() ka use: Parent class Employee ka constructor call karke name aur id set karna
        super().__init__(name, employee_id)
        # Role specific naya attribute
        self.programming_language: str = programming_language

    # Method Overriding: Parent ke display_details ko extend karke language bhi show karna
    def display_details(self):
        super().display_details()
        print(f" | Role: Developer | Language: {self.programming_language}")


# Child Class 2: Manager (Employee class se inherit kiya)
class Manager(Employee):
    def __init__(self, name: str, employee_id: int, team_size: int):
        # super() ka use: Parent constructor ko call karna
        super().__init__(name, employee_id)
        # Role specific naya attribute
        self.team_size: int = team_size

    # Method Overriding: Parent details ke sath team size show karna
    def display_details(self):
        super().display_details()
        print(f" | Role: Manager | Team Size: {self.team_size} members")


# =============================================================================
# Testing & Demonstration
# =============================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("PILLAR 2 - Q3: EMPLOYEE ROLES (INHERITANCE)")
    print("Student: TALHA KHAN | Roll No: 873676")
    print("=" * 70)

    # 1. Developer ka object banaya
    dev = Developer(name="Talha Khan", employee_id=873676, programming_language="Python")

    # 2. Manager ka object banaya
    mgr = Manager(name="Zubair Ahmed", employee_id=402110, team_size=8)

    # Dono objects ki details print karke test kiya
    print("\nDeveloper Object Details:")
    dev.display_details()

    print("\nManager Object Details:")
    mgr.display_details()
