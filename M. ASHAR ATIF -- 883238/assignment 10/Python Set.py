#Q21. Unique Values

numbers = [10, 20, 10, 30, 40, 20, 50]

# Convert list to set to get unique elements and count them
unique_numbers = set(numbers)
unique_count = len(unique_numbers)

print("Unique Set:", unique_numbers)
print("Count of Unique Elements:", unique_count)

#Q22. Set Operations

a = {1, 2, 3, 4, 5}
b = {4, 5, 6, 7, 8}

# Find union, intersection, difference (a - b), and symmetric difference
union_res = a | b
intersection_res = a & b
diff_res = a - b
sym_diff = a ^ b

print("Union:", union_res)
print("Intersection:", intersection_res)
print("Difference (a - b):", diff_res)
print("Symmetric Difference:", sym_diff)

#Q23. Add and Remove

skills = {"Python", "SQL", "AWS"}

# Add Snowflake and Databricks
skills.update({"Snowflake", "Databricks"})

# Safely remove AWS using discard()
skills.discard("AWS")

print("Updated Skills:", skills)

#Q24. Common Students

python_students = {"Ali", "Sara", "Ahmed", "Zain"}
sql_students = {"Sara", "Ahmed", "Hamza", "Usman"}

# Find students taking both courses (Intersection)
both_courses = python_students & sql_students

# Find students taking exactly one course (Symmetric Difference)
one_course = python_students ^ sql_students

print("Both Courses:", both_courses)
print("Exactly One Course:", one_course)

#Q25. Subset and Superset

required_skills = {"Python", "SQL"}
candidate_skills = {"Python", "SQL", "AWS", "Snowflake"}

# Check if required skills are a subset and candidate skills are a superset
is_subset = required_skills.issubset(candidate_skills)
is_superset = candidate_skills.issuperset(required_skills)

print("Are required skills a subset?", is_subset)
print("Are candidate skills a superset?", is_superset)

#Q26. Missing Numbers

numbers = {1, 2, 4, 6, 8, 10}

# Create full range from 1 to 10 and find missing integers using set difference
full_range = set(range(1, 11))
missing_numbers = full_range - numbers

print("Missing Numbers:", missing_numbers)

#Q27. Three-Set Analysis

python = {"Ali", "Sara", "Ahmed", "Zain"}
sql = {"Sara", "Ahmed", "Hamza"}
aws = {"Ahmed", "Zain", "Hamza"}

# Find students in all three courses
all_three = python & sql & aws

# Find students taking exactly Python and SQL (not AWS)
python_sql_not_aws = (python & sql) - aws

# Find students taking at least two courses
at_least_two = (python & sql) | (python & aws) | (sql & aws)

print("In All Three:", all_three)
print("Python and SQL (not AWS):", python_sql_not_aws)
print("At Least Two Courses:", at_least_two)

#Q28. Transaction Analysis

day1 = {101, 102, 103, 104}
day2 = {103, 104, 105, 106}
day3 = {104, 106, 107, 108}

# Find IDs appearing on all days
all_days = day1 & day2 & day3

# Find IDs appearing on at least two days
at_least_two_days = (day1 & day2) | (day2 & day3) | (day1 & day3)

# Find IDs appearing on exactly one day
union_all = day1 | day2 | day3
exactly_one_day = union_all - at_least_two_days

print("Appearing on All Days:", all_days)
print("Appearing on Exactly One Day:", exactly_one_day)
print("Appearing on At Least Two Days:", at_least_two_days)

#Q29. Access Control

required_permissions = {"read", "write", "execute"}
user_permissions = {"read", "write", "delete"}

# Find missing permissions
missing_perms = required_permissions - user_permissions

# Find extra permissions
extra_perms = user_permissions - required_permissions

# Test full authorization
full_authorization = required_permissions.issubset(user_permissions)

print("Missing Permissions:", missing_perms)
print("Extra Permissions:", extra_perms)
print("Full Authorization:", full_authorization)

#Q30. Customer Segmentation

website = {"C1", "C2", "C3", "C4", "C5"}
mobile = {"C3", "C4", "C6", "C7"}
store = {"C2", "C4", "C7", "C8"}

union_all = website | mobile | store

# Find customers on all three platforms
all_three = website & mobile & store

# Find customers on at least two platforms
at_least_two = (website & mobile) | (mobile & store) | (website & store)

# Find customers on exactly two platforms
exactly_two = at_least_two - all_three

# Find customers on exactly one platform
exactly_one = union_all - at_least_two

print("Exactly One Platform:", exactly_one)
print("Exactly Two Platforms:", exactly_two)
print("All Three Platforms:", all_three)