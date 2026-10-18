#Q1. Accessing List Elements

numbers = [10, 20, 30, 40, 50, 60, 70]

# Extracting first, middle (dynamically calculated), and last elements
first = numbers[0]
middle = numbers[len(numbers) // 2]
last = numbers[-1]

print("First:", first)
print("Middle:", middle)
print("Last:", last)

#Q2. List Slicing

numbers = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]

# 1. First five elements
first_five = numbers[:5]

# 2. Last four elements
last_four = numbers[-4:]

# 3. Every second element in reverse order
every_second_reverse = numbers[::-2]

print("First five:", first_five)
print("Last four:", last_four)
print("Every second element in reverse:", every_second_reverse)

#Q3. List Modification

fruits = ["apple", "banana", "cherry", "mango"]

# Replace banana with orange
fruits[fruits.index("banana")] = "orange"

# Add grapes at index 2
fruits.insert(2, "grapes")

# Remove cherry
fruits.remove("cherry")

print("Modified fruits list:", fruits)

#Q4. Reverse Without reverse()

numbers = [12, 45, 23, 67, 89, 34]

# Reverse using slicing only; preserves the original list
reversed_numbers = numbers[::-1]

print("Original list:", numbers)
print("Reversed list:", reversed_numbers)

#Q5. Second Largest Unique Number

numbers = [45, 12, 89, 34, 89, 67, 45, 23]

# Remove duplicates using set, sort in descending order, and pick the second element
unique_sorted = sorted(set(numbers), reverse=True)
second_largest = unique_sorted[1]

print("Second largest unique number:", second_largest)

#Q6. Rotate a List

numbers = [10, 20, 30, 40, 50, 60]
k = 2

# Rotate right by k using slicing
rotated_numbers = numbers[-k:] + numbers[:-k]

print("Rotated list:", rotated_numbers)

##Q7. Remove Duplicates, Preserve Order

numbers = [10, 20, 10, 30, 20, 40, 30, 50]

# dict.fromkeys() removes duplicates while preserving insertion order in Python 3.7+
unique_numbers = list(dict.fromkeys(numbers))

print("Unique preserved order:", unique_numbers)


#Q8. Flatten a Nested List

data = [[10, 20], [30, 40], [50, 60]]

# Flattening using sum() with an empty list start accumulator
flattened_data = sum(data, [])

print("Flattened list:", flattened_data)

#Q9. Extract Data from a Matrix

matrix = [
    [10, 20, 30],
    [40, 50, 60],
    [70, 80, 90]
]

# Main diagonal and its sum
main_diag = [matrix[0][0], matrix[1][1], matrix[2][2]]
main_sum = sum(main_diag)

# Secondary diagonal and its sum
sec_diag = [matrix[0][2], matrix[1][1], matrix[2][0]]
sec_sum = sum(sec_diag)

# Middle column (extracted using zip unpacking) and its sum
middle_col = list(zip(*matrix))[1]
middle_sum = sum(middle_col)

print("Main diagonal:", main_diag, "Sum:", main_sum)
print("Secondary diagonal:", sec_diag, "Sum:", sec_sum)
print("Middle column:", list(middle_col), "Sum:", middle_sum)

#Q10. List Transformation Challenge

data = [15, 5, 25, 10, 35, 20, 30]

# Sort all unique elements
sorted_unique = sorted(set(data))

# Three largest unique values in ascending order
three_largest_asc = sorted(sorted_unique[-3:])

# Two smallest unique values in descending order
two_smallest_desc = sorted(sorted_unique[:2], reverse=True)

# Combine both parts
result = three_largest_asc + two_smallest_desc

print("Transformed list:", result)