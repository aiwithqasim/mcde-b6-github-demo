#Q31. Dictionary Access

student = {"name": "Ali", "age": 22, "course": "Python", "marks": 85}

# Extract name and marks using standard key access
name = student["name"]
marks = student["marks"]

# Retrieve missing city with default value "Karachi" using get()
city = student.get("city", "Karachi")

print("Name:", name)
print("Marks:", marks)
print("City:", city)

#Q32. Update Dictionary

employee = {"name": "Sara", "salary": 100000, "department": "IT"}

# Raise salary by 20%
employee["salary"] = employee["salary"] * 1.2

# Add bonus using assignment
employee["bonus"] = 15000

# Change department to Data Engineering
employee["department"] = "Data Engineering"

print("Updated Employee:", employee)

#Q33. Dictionary Methods

product = {"id": 101, "name": "Laptop", "price": 120000, "stock": 5}

# Extract keys, values, and items using built-in methods
keys = product.keys()
values = product.values()
items = product.items()

# Remove stock and retain its value using pop()
stock_value = product.pop("stock")

print("Keys:", keys)
print("Values:", values)
print("Items:", items)
print("Stock Value Retained:", stock_value)
print("Product after removal:", product)
LEVEL: INTERMEDIATE
#Q34. Merge Dictionaries

dict1 = {"a": 10, "b": 20, "c": 30}
dict2 = {"b": 50, "d": 40}

# Merge dictionaries using the union operator (|) so dict2 overrides overlapping keys
merged_dict = dict1 | dict2

print("Merged Dictionary:", merged_dict)

#Q35. Student Marks

marks = {"Ali": 85, "Sara": 92, "Ahmed": 78, "Zain": 88}

# Find highest and lowest scores using max() and min()
highest_score = max(marks.values())
lowest_score = min(marks.values())

# Calculate average score
average_score = sum(marks.values()) / len(marks.values())

# Find top-scoring student without loops or lambda (using key=marks.get method)
top_student = max(marks, key=marks.get)

print("Highest Score:", highest_score)
print("Lowest Score:", lowest_score)
print("Average Score:", average_score)
print("Top-Scoring Student:", top_student)

#Q36. Nested Employee Records

employees = {
    "E101": {"name": "Ali", "salary": 80000},
    "E102": {"name": "Sara", "salary": 120000},
    "E103": {"name": "Ahmed", "salary": 95000}
}

# Extract Sara's salary
sara_salary = employees["E102"]["salary"]

# Increase Ali's salary by 15%
employees["E101"]["salary"] *= 1.15

# Calculate total payroll
total_payroll = employees["E101"]["salary"] + employees["E102"]["salary"] + employees["E103"]["salary"]

print("Sara's Salary:", sara_salary)
print("Ali's Updated Salary:", employees["E101"]["salary"])
print("Total Payroll:", total_payroll)

#Q37. Dictionary Inversion

data = {"Python": "Ali", "SQL": "Sara", "AWS": "Ahmed"}

# Create inverse dictionary without loops or comprehensions by swapping keys and values using zip
inverse_data = dict(zip(data.values(), data.keys()))

print("Inverse Dictionary:", inverse_data)
LEVEL: ADVANCED

#Q38. Order Calculation

order = {
    "laptop": {"price": 120000, "quantity": 2},
    "mouse": {"price": 1500, "quantity": 5},
    "keyboard": {"price": 3500, "quantity": 3}
}

# Calculate subtotals for each item
subtotal_laptop = order["laptop"]["price"] * order["laptop"]["quantity"]
subtotal_mouse = order["mouse"]["price"] * order["mouse"]["quantity"]
subtotal_keyboard = order["keyboard"]["price"] * order["keyboard"]["quantity"]

# Calculate grand total
grand_total = subtotal_laptop + subtotal_mouse + subtotal_keyboard

# Calculate amount after 10% discount
discounted_amount = grand_total * 0.9

print("Subtotal Laptop:", subtotal_laptop)
print("Subtotal Mouse:", subtotal_mouse)
print("Subtotal Keyboard:", subtotal_keyboard)
print("Grand Total:", grand_total)
print("Amount After 10% Discount:", discounted_amount)

#Q39. Employee Performance

employees = {
    "Ali": {"python": 90, "sql": 85, "aws": 88},
    "Sara": {"python": 95, "sql": 92, "aws": 90},
    "Ahmed": {"python": 80, "sql": 87, "aws": 84}
}

# Calculate each employee's average score
ali_avg = sum(employees["Ali"].values()) / len(employees["Ali"])
sara_avg = sum(employees["Sara"].values()) / len(employees["Sara"])
ahmed_avg = sum(employees["Ahmed"].values()) / len(employees["Ahmed"])

# Find highest SQL score among employees
highest_sql = max(employees["Ali"]["sql"], employees["Sara"]["sql"], employees["Ahmed"]["sql"])

# Find top performer based on average
averages = {"Ali": ali_avg, "Sara": sara_avg, "Ahmed": ahmed_avg}
top_performer = max(averages, key=averages.get)

print("Ali's Average:", ali_avg)
print("Sara's Average:", sara_avg)
print("Ahmed's Average:", ahmed_avg)
print("Highest SQL Score:", highest_sql)
print("Top Performer:", top_performer)

#Q40. Inventory Management

inventory = {
    "P101": {"name": "Laptop", "price": 120000, "stock": 5},
    "P102": {"name": "Mouse", "price": 1500, "stock": 20},
    "P103": {"name": "Keyboard", "price": 3500, "stock": 10}
}

# Calculate item values (price * stock)
val_p101 = inventory["P101"]["price"] * inventory["P101"]["stock"]
val_p102 = inventory["P102"]["price"] * inventory["P102"]["stock"]
val_p103 = inventory["P103"]["price"] * inventory["P103"]["stock"]

# Calculate total inventory value
total_value = val_p101 + val_p102 + val_p103

# Find most valuable item by price x stock using a dictionary of values and max()
item_values = {"Laptop": val_p101, "Mouse": val_p102, "Keyboard": val_p103}
most_valuable = max(item_values, key=item_values.get)

# Update stock after selling two laptops and five mice
inventory["P101"]["stock"] -= 2
inventory["P102"]["stock"] -= 5

print("Total Inventory Value:", total_value)
print("Most Valuable Item:", most_valuable)
print("Updated Laptop Stock:", inventory["P101"]["stock"])
print("Updated Mouse Stock:", inventory["P102"]["stock"])