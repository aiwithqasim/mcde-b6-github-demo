from abc import ABC, abstractmethod


class Employee(ABC):

  def __init__(self, name, emp_id):
    self.name = name
    self.emp_id = emp_id

  @abstractmethod
  def calculate_salary(self):
    """Abstract method to compute monthly compensation."""
    pass

  def get_employee_info(self):
    """Concrete method shared across all employee types."""
    return f"ID: {self.emp_id} | Name: {self.name}"


class FullTimeEmployee(Employee):

  def __init__(self, name, emp_id, monthly_salary):
    super().__init__(name, emp_id)
    self.monthly_salary = monthly_salary

  def calculate_salary(self):
    return self.monthly_salary


class PartTimeEmployee(Employee):

  def __init__(self, name, emp_id, hourly_rate, hours_worked):
    super().__init__(name, emp_id)
    self.hourly_rate = hourly_rate
    self.hours_worked = hours_worked

  def calculate_salary(self):
    return self.hourly_rate * self.hours_worked


# --- Demonstration ---
if __name__ == "__main__":
  print("--- Q8: Employee Payroll System Demonstration ---")
  payroll = [
      FullTimeEmployee("Grace Hopper", "FT-01", 120000.0),
      PartTimeEmployee("Alan Turing", "PT-02", 1500.0, 40),
  ]

  for emp in payroll:
    print(
        f"{emp.get_employee_info()} | Total Salary: Rs."
        f" {emp.calculate_salary():.2f}"
    )