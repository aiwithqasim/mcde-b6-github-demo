#Q11. Tuple Indexing

colors = ("red", "green", "blue", "yellow", "purple")

# Extract second, last, and middle three elements
second_elem = colors[1]
last_elem = colors[-1]
middle_three = colors[1:4]

print("Second:", second_elem)
print("Last:", last_elem)
print("Middle Three:", middle_three)

#Q12. Tuple Unpacking

employee = ("Ali", 28, "Data Engineer", 150000)

# Unpack into four variables
name, age, role, salary = employee

print("Name:", name)
print("Salary:", salary)

#Q13. Tuple Concatenation

tuple1 = (10, 20, 30)
tuple2 = (40, 50, 60)

# Combine tuples
combined = tuple1 + tuple2

# Create another tuple in reverse order
reversed_tuple = combined[::-1]

print("Combined:", combined)
print("Reversed:", reversed_tuple)

#Q14. Count and Locate

numbers = (10, 20, 30, 20, 40, 20, 50)

# Count occurrences of 20
count_20 = numbers.count(20)

# Find the first index of 20
first_index_20 = numbers.index(20)

print("Count of 20:", count_20)
print("First Index of 20:", first_index_20)

#Q15. Extended Tuple Unpacking\

data = (100, 200, 300, 400, 500, 600)

# Unpack first two and last into variables; put remaining elements into a list
first, second, *remaining, last = data
remaining_list = list(remaining)

print("First:", first)
print("Second:", second)
print("Remaining List:", remaining_list)
print("Last:", last)

#Q16. Modify an Immutable Tuple

numbers = (10, 20, 30, 40, 50)

# Since tuples are immutable, create a new tuple using slicing to replace 30 with 300
new_numbers = numbers[:2] + (300,) + numbers[3:]

print("New Tuple:", new_numbers)

#Q17. Nested Tuple Access
students = (
    ("Ali", (85, 90, 88)),
    ("Sara", (92, 87, 95)),
    ("Ahmed", (78, 84, 80))
)

# Extract Sara's second score
sara_second = students[1][1][1]

# Calculate Ali's average score
ali_avg = sum(students[0][1]) / len(students[0][1])

# Find Ahmed's highest score
ahmed_highest = max(students[2][1])

print("Sara's Second Score:", sara_second)
print("Ali's Average:", ali_avg)
print("Ahmed's Highest Score:", ahmed_highest)

#Q18. Tuple Sorting

from operator import itemgetter

employees = (
    ("Ali", 80000),
    ("Sara", 120000),
    ("Ahmed", 95000)
)

# Sort by salary descending without loops, comprehensions, or lambda
sorted_employees = tuple(sorted(employees, key=itemgetter(1), reverse=True))

print("Sorted Employees:", sorted_employees)

#Q19. Tuple Matrix

matrix = ((2, 4, 6), (8, 10, 12), (14, 16, 18))

# Extract diagonal elements
diagonal = (matrix[0][0], matrix[1][1], matrix[2][2])

# Calculate diagonal product
diagonal_product = diagonal[0] * diagonal[1] * diagonal[2]

# Build a tuple of row sums
row_sums = (sum(matrix[0]), sum(matrix[1]), sum(matrix[2]))

print("Diagonal:", diagonal)
print("Product:", diagonal_product)
print("Row Sums:", row_sums)

#Q20. Inventory Tuple Challenge

records = (
    ("Laptop", 120000, 5),
    ("Mouse", 1500, 20),
    ("Keyboard", 3500, 10)
)

# Calculate total inventory value (Price * Quantity)
val1 = records[0][1] * records[0][2]
val2 = records[1][1] * records[1][2]
val3 = records[2][1] * records[2][2]
total_inventory_value = val1 + val2 + val3

# Find most expensive product
expensive = max(records, key=lambda x: x[1])

# Build reversed tuple of names
names = (records[0][0], records[1][0], records[2][0])
reversed_names = names[::-1]

print("Total Inventory Value:", total_inventory_value)
print("Most Expensive Product:", expensive[0])
print("Reversed Names:", reversed_names)


