class Employee:

  def __init__(self, name, employee_id):
    self.name = name
    self.employee_id = employee_id

  def display_details(self):
    print(f"Employee ID: {self.employee_id} | Name: {self.name}")


class Developer(Employee):

  def __init__(self, name, employee_id, programming_language):
    super().__init__(name, employee_id)
    self.programming_language = programming_language

  def display_details(self):
    print(
        f"[Developer] ID: {self.employee_id} | Name: {self.name} | Language:"
        f" {self.programming_language}"
    )


class Manager(Employee):

  def __init__(self, name, employee_id, team_size):
    super().__init__(name, employee_id)
    self.team_size = team_size

  def display_details(self):
    print(
        f"[Manager] ID: {self.employee_id} | Name: {self.name} | Team Size:"
        f" {self.team_size}"
    )


# --- Demonstration ---
if __name__ == "__main__":
  print("--- Q3: Employee Roles Demonstration ---")
  dev = Developer("Charlie", "DEV-101", "Python")
  mgr = Manager("Diana", "MGR-202", 8)

  dev.display_details()
  mgr.display_details()