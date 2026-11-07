"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assessment   : PAPER-3 PYTHON FINAL ASSESSMENT
Part 2 of 5  : Python Practice: Tuples (Questions 11 to 20)
RULES        : No for/while loops, no comprehensions, no recursion,
               no map/filter/reduce, and no hardcoded answers.
=============================================================================
"""
import math
from operator import itemgetter

print("=" * 70)
print("PAPER-3: PART 2 - TUPLES PRACTICE (Q11 - Q20)")
print("STUDENT: TALHA KHAN | ROLL NO: 873676")
print("=" * 70)

# ---------------------------------------------------------------------------
# Q11. Tuple Indexing
# colors = ("red", "green", "blue", "yellow", "purple")
# Extract second, last, and middle three elements.
# ---------------------------------------------------------------------------
print("\n--- Q11. Tuple Indexing ---")
colors = ("red", "green", "blue", "yellow", "purple")

# Indexing aur Slicing
second_color = colors[1]
last_color = colors[-1]
middle_three = colors[1:4]  # index 1 se 3 tak

print(f"Colors Tuple        : {colors}")
print(f"Second Element      : '{second_color}'")
print(f"Last Element        : '{last_color}'")
print(f"Middle Three        : {middle_three}")


# ---------------------------------------------------------------------------
# Q12. Tuple Unpacking
# employee = ("Ali", 28, "Data Engineer", 150000)
# Unpack into four variables and display name and salary.
# ---------------------------------------------------------------------------
print("\n--- Q12. Tuple Unpacking ---")
employee = ("Ali", 28, "Data Engineer", 150000)

# Direct unpacking char variables mein
name, age, designation, salary = employee

print(f"Employee Unpacked -> Name: {name} | Salary: Rs. {salary:,.2f}")


# ---------------------------------------------------------------------------
# Q13. Tuple Concatenation
# tuple1 = (10, 20, 30)
# tuple2 = (40, 50, 60)
# Combine tuples, then create another tuple in reverse order.
# ---------------------------------------------------------------------------
print("\n--- Q13. Tuple Concatenation ---")
tuple1 = (10, 20, 30)
tuple2 = (40, 50, 60)

# Concatenation operator (+) se combine kiya
combined_tuple = tuple1 + tuple2
# Slicing [::-1] se reverse order tuple banaya
reversed_combined = combined_tuple[::-1]

print(f"Combined Tuple : {combined_tuple}")
print(f"Reversed Tuple : {reversed_combined}")


# ---------------------------------------------------------------------------
# Q14. Count and Locate
# numbers = (10, 20, 30, 20, 40, 20, 50)
# Count occurrences of 20 and find the first index.
# ---------------------------------------------------------------------------
print("\n--- Q14. Count and Locate ---")
numbers_q14 = (10, 20, 30, 20, 40, 20, 50)

# Built-in tuple methods .count() aur .index()
count_20 = numbers_q14.count(20)
first_index_20 = numbers_q14.index(20)

print(f"Numbers Tuple           : {numbers_q14}")
print(f"Occurrences of 20       : {count_20}")
print(f"First Index of 20       : {first_index_20}")


# ---------------------------------------------------------------------------
# Q15. Extended Tuple Unpacking
# data = (100, 200, 300, 400, 500, 600)
# Unpack first two and last into variables; put all remaining elements into a list.
# ---------------------------------------------------------------------------
print("\n--- Q15. Extended Tuple Unpacking ---")
data_q15 = (100, 200, 300, 400, 500, 600)

# Extended unpacking syntax (*remaining beech ke saray elements ko list bana deta hai)
first, second, *remaining, last = data_q15

print(f"First Element     : {first}")
print(f"Second Element    : {second}")
print(f"Remaining (List)  : {remaining}")
print(f"Last Element      : {last}")


# ---------------------------------------------------------------------------
# Q16. Modify an Immutable Tuple
# numbers = (10, 20, 30, 40, 50)
# Create a new tuple replacing 30 with 300.
# ---------------------------------------------------------------------------
print("\n--- Q16. Modify an Immutable Tuple ---")
numbers_q16 = (10, 20, 30, 40, 50)

# Slicing se 30 se pehle ke elements + (300,) + 30 ke baad ke elements
idx_30 = numbers_q16.index(30)
modified_tuple = numbers_q16[:idx_30] + (300,) + numbers_q16[idx_30 + 1:]

print(f"Original Tuple : {numbers_q16}")
print(f"New Tuple      : {modified_tuple}")


# ---------------------------------------------------------------------------
# Q17. Nested Tuple Access
# students = (
#  ("Ali", (85, 90, 88)),
#  ("Sara", (92, 87, 95)),
#  ("Ahmed", (78, 84, 80))
# )
# Extract Sara second score, Ali average, and Ahmed highest score.
# ---------------------------------------------------------------------------
print("\n--- Q17. Nested Tuple Access ---")
students = (
    ("Ali", (85, 90, 88)),
    ("Sara", (92, 87, 95)),
    ("Ahmed", (78, 84, 80))
)

# 1. Sara ka second score (Row 1, Scores tuple index 1, Score 1)
sara_second_score = students[1][1][1]

# 2. Ali ka average (Row 0, Scores sum / length)
ali_scores = students[0][1]
ali_average = sum(ali_scores) / len(ali_scores)

# 3. Ahmed ka highest score (Row 2, max score)
ahmed_scores = students[2][1]
ahmed_highest = max(ahmed_scores)

print(f"Sara's Second Score : {sara_second_score}")
print(f"Ali's Average Score : {ali_average:.2f}")
print(f"Ahmed's Highest Score: {ahmed_highest}")


# ---------------------------------------------------------------------------
# Q18. Tuple Sorting
# employees = (
#  ("Ali", 80000),
#  ("Sara", 120000),
#  ("Ahmed", 95000)
# )
# Sort by salary descending without loops, comprehensions, or lambda.
# ---------------------------------------------------------------------------
print("\n--- Q18. Tuple Sorting ---")
employees = (
    ("Ali", 80000),
    ("Sara", 120000),
    ("Ahmed", 95000)
)

# itemgetter(1) se salary (index 1) par sort kiya bina kisi loop ya lambda ke
sorted_by_salary = tuple(sorted(employees, key=itemgetter(1), reverse=True))

print(f"Original Tuple: {employees}")
print(f"Sorted Descending by Salary: {sorted_by_salary}")


# ---------------------------------------------------------------------------
# Q19. Tuple Matrix
# matrix = ((2, 4, 6), (8, 10, 12), (14, 16, 18))
# Extract diagonal, calculate its product, and build a tuple of row sums.
# ---------------------------------------------------------------------------
print("\n--- Q19. Tuple Matrix ---")
matrix_tuple = ((2, 4, 6), (8, 10, 12), (14, 16, 18))

# 1. Diagonal elements extract karna
diagonal = (matrix_tuple[0][0], matrix_tuple[1][1], matrix_tuple[2][2])

# 2. Product calculate karna (math.prod se)
diag_product = math.prod(diagonal)

# 3. Row sums ka tuple banana
row_sums = (sum(matrix_tuple[0]), sum(matrix_tuple[1]), sum(matrix_tuple[2]))

print(f"Diagonal Elements : {diagonal}")
print(f"Diagonal Product  : {diag_product}")
print(f"Tuple of Row Sums : {row_sums}")


# ---------------------------------------------------------------------------
# Q20. Inventory Tuple Challenge
# records = (
#  ("Laptop", 120000, 5),
#  ("Mouse", 1500, 20),
#  ("Keyboard", 3500, 10)
# )
# Calculate inventory value, find most expensive product,
# and build reversed tuple of names.
# ---------------------------------------------------------------------------
print("\n--- Q20. Inventory Tuple Challenge ---")
records = (
    ("Laptop", 120000, 5),
    ("Mouse", 1500, 20),
    ("Keyboard", 3500, 10)
)

# 1. Total inventory value: (price * quantity) ka sum
val1 = records[0][1] * records[0][2]
val2 = records[1][1] * records[1][2]
val3 = records[2][1] * records[2][2]
total_inventory_val = val1 + val2 + val3

# 2. Most expensive product (price index 1)
most_expensive_item = max(records, key=itemgetter(1))

# 3. Reversed tuple of names using zip(*records) unpacking and slice [::-1]
names_tuple = tuple(zip(*records))[0][::-1]

print(f"Total Inventory Value : Rs. {total_inventory_val:,.2f}")
print(f"Most Expensive Item   : {most_expensive_item[0]} (Rs. {most_expensive_item[1]:,.2f})")
print(f"Reversed Tuple Names  : {names_tuple}")
