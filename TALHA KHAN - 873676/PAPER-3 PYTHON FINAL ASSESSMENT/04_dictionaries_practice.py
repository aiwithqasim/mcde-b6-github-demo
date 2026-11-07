"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assessment   : PAPER-3 PYTHON FINAL ASSESSMENT
Part 4 of 5  : Python Practice: Dictionaries (Questions 31 to 40)
RULES        : No for/while loops, no comprehensions, no recursion,
               no map/filter/reduce, and no hardcoded answers.
=============================================================================
"""

print("=" * 70)
print("PAPER-3: PART 4 - DICTIONARIES PRACTICE (Q31 - Q40)")
print("STUDENT: TALHA KHAN | ROLL NO: 873676")
print("=" * 70)

# ---------------------------------------------------------------------------
# Q31. Dictionary Access
# student = {"name": "Ali", "age": 22, "course": "Python", "marks": 85}
# Extract name and marks; retrieve missing city with default Karachi.
# ---------------------------------------------------------------------------
print("\n--- Q31. Dictionary Access ---")
student = {"name": "Ali", "age": 22, "course": "Python", "marks": 85}

student_name = student["name"]
student_marks = student["marks"]
# .get() missing key par default value deta hai
student_city = student.get("city", "Karachi")

print(f"Student Name  : {student_name}")
print(f"Student Marks : {student_marks}")
print(f"Student City  : {student_city} (Default)")


# ---------------------------------------------------------------------------
# Q32. Update Dictionary
# employee = {"name": "Sara", "salary": 100000, "department": "IT"}
# Raise salary by 20%, add bonus 15000, change department to Data Engineering.
# ---------------------------------------------------------------------------
print("\n--- Q32. Update Dictionary ---")
employee = {"name": "Sara", "salary": 100000, "department": "IT"}
print(f"Initial Employee: {employee}")

employee["salary"] = int(employee["salary"] * 1.20)
employee["bonus"] = 15000
employee["department"] = "Data Engineering"

print(f"Updated Employee: {employee}")


# ---------------------------------------------------------------------------
# Q33. Dictionary Methods
# product = {"id": 101, "name": "Laptop", "price": 120000, "stock": 5}
# Extract keys, values, items; remove stock and retain its value.
# ---------------------------------------------------------------------------
print("\n--- Q33. Dictionary Methods ---")
product = {"id": 101, "name": "Laptop", "price": 120000, "stock": 5}

keys_list = list(product.keys())
values_list = list(product.values())
items_list = list(product.items())

# .pop() stock ko delete karta hai aur uski value return karta hai
retained_stock = product.pop("stock")

print(f"Keys           : {keys_list}")
print(f"Values         : {values_list}")
print(f"Items          : {items_list}")
print(f"Retained Stock : {retained_stock}")
print(f"Remaining Dict : {product}")


# ---------------------------------------------------------------------------
# Q34. Merge Dictionaries
# dict1 = {"a": 10, "b": 20, "c": 30}
# dict2 = {"b": 50, "d": 40}
# Merge so dict2 overrides overlapping keys.
# ---------------------------------------------------------------------------
print("\n--- Q34. Merge Dictionaries ---")
dict1 = {"a": 10, "b": 20, "c": 30}
dict2 = {"b": 50, "d": 40}

# Dictionary merge operator (|) overrides with dict2
merged_dict = dict1 | dict2

print(f"Dict 1      : {dict1}")
print(f"Dict 2      : {dict2}")
print(f"Merged Dict : {merged_dict}")


# ---------------------------------------------------------------------------
# Q35. Student Marks
# marks = {"Ali": 85, "Sara": 92, "Ahmed": 78, "Zain": 88}
# Find highest, lowest, average, and top-scoring student without loops or lambda.
# ---------------------------------------------------------------------------
print("\n--- Q35. Student Marks ---")
marks = {"Ali": 85, "Sara": 92, "Ahmed": 78, "Zain": 88}

highest_marks = max(marks.values())
lowest_marks = min(marks.values())
average_marks = sum(marks.values()) / len(marks)

# key=marks.get se max score karne wale student ka naam aayega (No loop, No lambda)
top_student = max(marks, key=marks.get)

print(f"Highest Marks : {highest_marks}")
print(f"Lowest Marks  : {lowest_marks}")
print(f"Average Marks : {average_marks:.2f}")
print(f"Top Student   : {top_student}")


# ---------------------------------------------------------------------------
# Q36. Nested Employee Records
# employees = {
#  "E101": {"name": "Ali", "salary": 80000},
#  "E102": {"name": "Sara", "salary": 120000},
#  "E103": {"name": "Ahmed", "salary": 95000}
# }
# Extract Sara salary, increase Ali salary 15%, and calculate total payroll.
# ---------------------------------------------------------------------------
print("\n--- Q36. Nested Employee Records ---")
employees_q36 = {
    "E101": {"name": "Ali", "salary": 80000},
    "E102": {"name": "Sara", "salary": 120000},
    "E103": {"name": "Ahmed", "salary": 95000}
}

# 1. Sara's salary
sara_salary = employees_q36["E102"]["salary"]

# 2. Increase Ali's salary by 15%
employees_q36["E101"]["salary"] = int(employees_q36["E101"]["salary"] * 1.15)

# 3. Calculate total payroll
total_payroll = (
    employees_q36["E101"]["salary"] +
    employees_q36["E102"]["salary"] +
    employees_q36["E103"]["salary"]
)

print(f"Sara's Salary         : Rs. {sara_salary:,.2f}")
print(f"Ali's Updated Salary  : Rs. {employees_q36['E101']['salary']:,.2f}")
print(f"Total Company Payroll : Rs. {total_payroll:,.2f}")


# ---------------------------------------------------------------------------
# Q37. Dictionary Inversion
# data = {"Python": "Ali", "SQL": "Sara", "AWS": "Ahmed"}
# Create inverse dictionary without loops or comprehensions.
# ---------------------------------------------------------------------------
print("\n--- Q37. Dictionary Inversion ---")
data_q37 = {"Python": "Ali", "SQL": "Sara", "AWS": "Ahmed"}

# zip(values, keys) se bina loop ya comprehension ke dictionary invert ho gayi
inverse_data = dict(zip(data_q37.values(), data_q37.keys()))

print(f"Original Dict : {data_q37}")
print(f"Inverted Dict : {inverse_data}")


# ---------------------------------------------------------------------------
# Q38. Order Calculation
# order = {
#  "laptop": {"price": 120000, "quantity": 2},
#  "mouse": {"price": 1500, "quantity": 5},
#  "keyboard": {"price": 3500, "quantity": 3}
# }
# Calculate subtotals, grand total, and amount after 10% discount.
# ---------------------------------------------------------------------------
print("\n--- Q38. Order Calculation ---")
order = {
    "laptop": {"price": 120000, "quantity": 2},
    "mouse": {"price": 1500, "quantity": 5},
    "keyboard": {"price": 3500, "quantity": 3}
}

subtotal_laptop = order["laptop"]["price"] * order["laptop"]["quantity"]
subtotal_mouse = order["mouse"]["price"] * order["mouse"]["quantity"]
subtotal_keyboard = order["keyboard"]["price"] * order["keyboard"]["quantity"]

grand_total = subtotal_laptop + subtotal_mouse + subtotal_keyboard
discounted_total = grand_total * (1 - 0.10)

print(f"Laptop Subtotal   : Rs. {subtotal_laptop:,.2f}")
print(f"Mouse Subtotal    : Rs. {subtotal_mouse:,.2f}")
print(f"Keyboard Subtotal : Rs. {subtotal_keyboard:,.2f}")
print(f"Grand Total       : Rs. {grand_total:,.2f}")
print(f"After 10% Discount: Rs. {discounted_total:,.2f}")


# ---------------------------------------------------------------------------
# Q39. Employee Performance
# employees = {
#  "Ali": {"python": 90, "sql": 85, "aws": 88},
#  "Sara": {"python": 95, "sql": 92, "aws": 90},
#  "Ahmed": {"python": 80, "sql": 87, "aws": 84}
# }
# Calculate each average, top performer, and highest SQL score.
# ---------------------------------------------------------------------------
print("\n--- Q39. Employee Performance ---")
perf = {
    "Ali": {"python": 90, "sql": 85, "aws": 88},
    "Sara": {"python": 95, "sql": 92, "aws": 90},
    "Ahmed": {"python": 80, "sql": 87, "aws": 84}
}

avg_ali = sum(perf["Ali"].values()) / len(perf["Ali"])
avg_sara = sum(perf["Sara"].values()) / len(perf["Sara"])
avg_ahmed = sum(perf["Ahmed"].values()) / len(perf["Ahmed"])

averages_dict = {"Ali": avg_ali, "Sara": avg_sara, "Ahmed": avg_ahmed}
top_performer = max(averages_dict, key=averages_dict.get)
highest_sql = max(perf["Ali"]["sql"], perf["Sara"]["sql"], perf["Ahmed"]["sql"])

print(f"Averages      : Ali: {avg_ali:.2f}, Sara: {avg_sara:.2f}, Ahmed: {avg_ahmed:.2f}")
print(f"Top Performer : {top_performer} (Avg: {averages_dict[top_performer]:.2f})")
print(f"Highest SQL   : {highest_sql}")


# ---------------------------------------------------------------------------
# Q40. Inventory Management
# inventory = {
#  "P101": {"name": "Laptop", "price": 120000, "stock": 5},
#  "P102": {"name": "Mouse", "price": 1500, "stock": 20},
#  "P103": {"name": "Keyboard", "price": 3500, "stock": 10}
# }
# Calculate total value, most valuable item by price x stock,
# and update stock after selling two laptops and five mice.
# ---------------------------------------------------------------------------
print("\n--- Q40. Inventory Management ---")
inventory = {
    "P101": {"name": "Laptop", "price": 120000, "stock": 5},
    "P102": {"name": "Mouse", "price": 1500, "stock": 20},
    "P103": {"name": "Keyboard", "price": 3500, "stock": 10}
}

# 1. Total inventory value
val_p101 = inventory["P101"]["price"] * inventory["P101"]["stock"]
val_p102 = inventory["P102"]["price"] * inventory["P102"]["stock"]
val_p103 = inventory["P103"]["price"] * inventory["P103"]["stock"]
total_inv_value = val_p101 + val_p102 + val_p103

# 2. Most valuable item by price x stock
item_values = {"P101": val_p101, "P102": val_p102, "P103": val_p103}
most_valuable_pid = max(item_values, key=item_values.get)
most_valuable_name = inventory[most_valuable_pid]["name"]

# 3. Update stock after selling two laptops and five mice
inventory["P101"]["stock"] -= 2
inventory["P102"]["stock"] -= 5

print(f"Total Inventory Value : Rs. {total_inv_value:,.2f}")
print(f"Most Valuable Product : {most_valuable_name} (Rs. {item_values[most_valuable_pid]:,.2f})")
print(f"Updated Stock         : Laptop: {inventory['P101']['stock']}, Mouse: {inventory['P102']['stock']}")
