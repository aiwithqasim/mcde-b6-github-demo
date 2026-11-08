# Q3: Employee Roles - Inheritance

class Employee:
    def __init__(self, name, employee_id):
        self.name = name
        self.employee_id = employee_id

    def display_details(self):
        print(f"Name: {self.name}")
        print(f"Employee ID: {self.employee_id}")


class Developer(Employee):
    def __init__(self, name, employee_id, programming_language):
        super().__init__(name, employee_id)
        self.programming_language = programming_language

    def display_details(self):
        print("Developer Details")
        super().display_details()
        print(f"Programming Language: {self.programming_language}")


class Manager(Employee):
    def __init__(self, name, employee_id, team_size):
        super().__init__(name, employee_id)
        self.team_size = team_size

    def display_details(self):
        print("Manager Details")
        super().display_details()
        print(f"Team Size: {self.team_size}")


if __name__ == "__main__":
    developer = Developer("Hamza", "E101", "Python")
    manager = Manager("Fatima", "E102", 8)

    developer.display_details()
    print()
    manager.display_details()
