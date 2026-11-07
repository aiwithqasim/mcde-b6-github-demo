class Employee:
    def __init__(self, name, employee_id):
        self.name = name
        self.employee_id = employee_id

    def display_details(self):
        # Shared information for all employees
        return f"ID: {self.employee_id} | Name: {self.name}"


class Developer(Employee):
    def __init__(self, name, employee_id, programming_language):
        # Parent constructor ko call karne k liye super()
        super().__init__(name, employee_id)
        self.programming_language = programming_language

    def display_details(self):
        # Parent class ke method ko reuse aur override kiya
        base_details = super().display_details()
        return f"{base_details} | Role: Developer | Language: {self.programming_language}"


class Manager(Employee):
    def __init__(self, name, employee_id, team_size):
        # Parent constructor ko call karne k liye super()
        super().__init__(name, employee_id)
        self.team_size = team_size

    def display_details(self):
        # Parent class ke method ko reuse aur override kiya
        base_details = super().display_details()
        return f"{base_details} | Role: Manager | Team Size: {self.team_size} members"


# --- Test Cases ---
print("--- Creating and Testing Developer Object ---")
dev = Developer("Asad", "DEV-404", "Python")
print(dev.display_details())

print("\n--- Creating and Testing Manager Object ---")
mgr = Manager("Ayesha", "MGR-101", 12)
print(mgr.display_details())
