# Q3. Employee Roles (Inheritance - Beginner)


class Employee:
    def __init__(self, name, employee_id):
        self.name = name
        self.employee_id = employee_id

    def display_details(self):
        return f"Employee: {self.name}, ID: {self.employee_id}"


class Developer(Employee):
    def __init__(self, name, employee_id, programming_language):
        super().__init__(name, employee_id)
        self.programming_language = programming_language

    def display_details(self):
        return (f"Developer: {self.name}, ID: {self.employee_id}, "
                f"Language: {self.programming_language}")


class Manager(Employee):
    def __init__(self, name, employee_id, team_size):
        super().__init__(name, employee_id)
        self.team_size = team_size

    def display_details(self):
        return (f"Manager: {self.name}, ID: {self.employee_id}, "
                f"Team size: {self.team_size}")


if __name__ == "__main__":
    dev = Developer("Ali", "E-101", "Python")
    mgr = Manager("Sara", "E-102", 8)

    print("=== Employee objects ===")
    print(" ", dev.display_details())
    print(" ", mgr.display_details())

    print("\n=== Shared attributes inherited from Employee ===")
    print(f"  dev.name = {dev.name}, dev.employee_id = {dev.employee_id}")
    print(f"  mgr.name = {mgr.name}, mgr.employee_id = {mgr.employee_id}")

    print("\n=== Role-specific attributes ===")
    print(f"  dev.programming_language = {dev.programming_language}")
    print(f"  mgr.team_size = {mgr.team_size}")

    print("\n=== Inheritance check ===")
    print(f"  isinstance(dev, Employee)  -> {isinstance(dev, Employee)}")
    print(f"  isinstance(mgr, Employee)  -> {isinstance(mgr, Employee)}")
