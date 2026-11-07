from abc import ABC, abstractmethod

class Employee(ABC):
    def __init__(self, name):
        self.name = name

    @abstractmethod
    def calculate_pay(self):
        pass

class SalariedEmployee(Employee):
    def __init__(self, name, weekly_salary):
        super().__init__(name)
        self.weekly_salary = float(weekly_salary)

    def calculate_pay(self):
        return self.weekly_salary

class HourlyEmployee(Employee):
    def __init__(self, name, hourly_rate, hours_worked):
        super().__init__(name)
        self.hourly_rate = float(hourly_rate)
        self.hours_worked = float(hours_worked)

    def calculate_pay(self):
        if self.hours_worked > 40:
            regular_pay = 40 * self.hourly_rate
            overtime_pay = (self.hours_worked - 40) * (self.hourly_rate * 1.5)
            return regular_pay + overtime_pay
        return self.hours_worked * self.hourly_rate

class CommissionEmployee(Employee):
    def __init__(self, name, base_salary, sales, commission_rate):
        super().__init__(name)
        self.base_salary = float(base_salary)
        self.sales = float(sales)
        self.commission_rate = float(commission_rate)

    def calculate_pay(self):
        return self.base_salary + (self.sales * self.commission_rate)

def generate_payroll_summary(employees):
    summary = []
    for emp in employees:
        summary.append({
            "name": emp.name,
            "type": type(emp).__name__,
            "pay": emp.calculate_pay()
        })
    return summary

employees = [
    HourlyEmployee("Ali", 20, 45),
    CommissionEmployee("Sara", 500, 4000, 0.10),
    SalariedEmployee("Ahmed", 1200)
]

for record in generate_payroll_summary(employees):
    print(f"Name: {record['name']} | Type: {record['type']} | Pay: {record['pay']}")