"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assessment   : PAPER-3 PYTHON FINAL ASSESSMENT
Part 1 of 5  : Python Practice: Lists (Questions 1 to 10)
RULES        : No for/while loops, no comprehensions, no recursion,
               no map/filter/reduce, and no hardcoded answers.
=============================================================================
"""

print("=" * 70)
print("PAPER-3: PART 1 - LISTS PRACTICE (Q1 - Q10)")
print("STUDENT: TALHA KHAN | ROLL NO: 873676")
print("=" * 70)

# ---------------------------------------------------------------------------
# Q1. Accessing List Elements
# numbers = [10, 20, 30, 40, 50, 60, 70]
# Extract first, middle, and last elements without modifying the original list.
# ---------------------------------------------------------------------------
print("\n--- Q1. Accessing List Elements ---")
numbers_q1 = [10, 20, 30, 40, 50, 60, 70]

# Indexing se pehla (0), darmiyani (len // 2), aur aakhri (-1) element nikalna
first_elem = numbers_q1[0]
middle_elem = numbers_q1[len(numbers_q1) // 2]
last_elem = numbers_q1[-1]

print(f"Original List : {numbers_q1}")
print(f"First Element : {first_elem}")
print(f"Middle Element: {middle_elem}")
print(f"Last Element  : {last_elem}")


# ---------------------------------------------------------------------------
# Q2. List Slicing
# numbers = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
# Create three new lists: first five, last four, and every second element in reverse order.
# ---------------------------------------------------------------------------
print("\n--- Q2. List Slicing ---")
numbers_q2 = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]

# Slicing syntax: [start:stop:step]
first_five = numbers_q2[:5]
last_four = numbers_q2[-4:]
every_second_reverse = numbers_q2[::-2]

print(f"First five elements             : {first_five}")
print(f"Last four elements              : {last_four}")
print(f"Every second element (reversed) : {every_second_reverse}")


# ---------------------------------------------------------------------------
# Q3. List Modification
# fruits = ["apple", "banana", "cherry", "mango"]
# Replace banana with orange, add grapes at index 2, and remove cherry.
# ---------------------------------------------------------------------------
print("\n--- Q3. List Modification ---")
fruits = ["apple", "banana", "cherry", "mango"]
print(f"Initial Fruits List: {fruits}")

# 1. Banana ki jagah orange replace karna
fruits[fruits.index("banana")] = "orange"

# 2. Index 2 par grapes insert karna
fruits.insert(2, "grapes")

# 3. Cherry ko list se remove karna
fruits.remove("cherry")

print(f"Modified Fruits List: {fruits}")


# ---------------------------------------------------------------------------
# Q4. Reverse Without reverse()
# numbers = [12, 45, 23, 67, 89, 34]
# Reverse using slicing only; preserve the original list.
# ---------------------------------------------------------------------------
print("\n--- Q4. Reverse Without reverse() ---")
numbers_q4 = [12, 45, 23, 67, 89, 34]

# Step -1 se poori list reverse slice ho jati hai bina original ko badle
reversed_q4 = numbers_q4[::-1]

print(f"Original List (Preserved): {numbers_q4}")
print(f"Reversed List (Slicing)  : {reversed_q4}")


# ---------------------------------------------------------------------------
# Q5. Second Largest Unique Number
# numbers = [45, 12, 89, 34, 89, 67, 45, 23]
# Find the second-largest unique number. Expected: 67.
# ---------------------------------------------------------------------------
print("\n--- Q5. Second Largest Unique Number ---")
numbers_q5 = [45, 12, 89, 34, 89, 67, 45, 23]

# set() se duplicates hataye aur sorted() se tarteeb di
unique_sorted_q5 = sorted(set(numbers_q5))
# Aakhri se pehla index [-2] second largest hota hai
second_largest = unique_sorted_q5[-2]

print(f"Original Numbers        : {numbers_q5}")
print(f"Unique Sorted List      : {unique_sorted_q5}")
print(f"Second-Largest Unique   : {second_largest} (Expected: 67)")


# ---------------------------------------------------------------------------
# Q6. Rotate a List
# numbers = [10, 20, 30, 40, 50, 60]
# k = 2
# Rotate the list right by k using slicing. Expected: [50, 60, 10, 20, 30, 40].
# ---------------------------------------------------------------------------
print("\n--- Q6. Rotate a List ---")
numbers_q6 = [10, 20, 30, 40, 50, 60]
k = 2

# Right rotation: Aakhri k elements shuru me + baqi pehle walay elements
rotated_q6 = numbers_q6[-k:] + numbers_q6[:-k]

print(f"Original Numbers: {numbers_q6}")
print(f"Rotated by k={k}  : {rotated_q6} (Expected: [50, 60, 10, 20, 30, 40])")


# ---------------------------------------------------------------------------
# Q7. Remove Duplicates, Preserve Order
# numbers = [10, 20, 10, 30, 20, 40, 30, 50]
# Remove duplicates while preserving first-occurrence order.
# ---------------------------------------------------------------------------
print("\n--- Q7. Remove Duplicates, Preserve Order ---")
numbers_q7 = [10, 20, 10, 30, 20, 40, 30, 50]

# dict.fromkeys() insertion order preserve rakhta hai aur duplicates khatam karta hai
no_duplicates_ordered = list(dict.fromkeys(numbers_q7))

print(f"Original with Duplicates: {numbers_q7}")
print(f"Order Preserved Unique  : {no_duplicates_ordered}")


# ---------------------------------------------------------------------------
# Q8. Flatten a Nested List
# data = [[10, 20], [30, 40], [50, 60]]
# Flatten into [10, 20, 30, 40, 50, 60] using list operations.
# ---------------------------------------------------------------------------
print("\n--- Q8. Flatten a Nested List ---")
data_q8 = [[10, 20], [30, 40], [50, 60]]

# List concatenation operator (+) se bina loop flatten karna
flattened_q8 = data_q8[0] + data_q8[1] + data_q8[2]

print(f"Nested List   : {data_q8}")
print(f"Flattened List: {flattened_q8}")


# ---------------------------------------------------------------------------
# Q9. Extract Data from a Matrix
# matrix = [
#  [10, 20, 30],
#  [40, 50, 60],
#  [70, 80, 90]
# ]
# Extract main diagonal, secondary diagonal, and middle column; calculate sum of each.
# ---------------------------------------------------------------------------
print("\n--- Q9. Extract Data from a Matrix ---")
matrix = [
    [10, 20, 30],
    [40, 50, 60],
    [70, 80, 90]
]

# 1. Main Diagonal (top-left se bottom-right)
main_diagonal = [matrix[0][0], matrix[1][1], matrix[2][2]]

# 2. Secondary Diagonal (top-right se bottom-left)
secondary_diagonal = [matrix[0][2], matrix[1][1], matrix[2][0]]

# 3. Middle Column (index 1 of every row)
middle_column = [matrix[0][1], matrix[1][1], matrix[2][1]]

print(f"Main Diagonal      : {main_diagonal} | Sum: {sum(main_diagonal)}")
print(f"Secondary Diagonal : {secondary_diagonal} | Sum: {sum(secondary_diagonal)}")
print(f"Middle Column      : {middle_column} | Sum: {sum(middle_column)}")


# ---------------------------------------------------------------------------
# Q10. List Transformation Challenge
# data = [15, 5, 25, 10, 35, 20, 30]
# Build a list of the three largest unique values ascending,
# then two smallest unique values descending. Expected: [25, 30, 35, 10, 5].
# ---------------------------------------------------------------------------
print("\n--- Q10. List Transformation Challenge ---")
data_q10 = [15, 5, 25, 10, 35, 20, 30]

# Pehle sorted unique list banayi
sorted_unique = sorted(set(data_q10))

# 3 largest ascending: aakhri 3 elements [-3:]
three_largest_asc = sorted_unique[-3:]

# 2 smallest descending: shuru ke 2 elements le kar reverse slice [::-1]
two_smallest_desc = sorted_unique[:2][::-1]

# Dono ko list concatenation (+) se jorh diya
final_transformed = three_largest_asc + two_smallest_desc

print(f"Original Data         : {data_q10}")
print(f"Transformed List      : {final_transformed} (Expected: [25, 30, 35, 10, 5])")
