"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assessment   : PAPER-3 PYTHON FINAL ASSESSMENT
Part 3 of 5  : Python Practice: Sets (Questions 21 to 30)
RULES        : No for/while loops, no comprehensions, no recursion,
               no map/filter/reduce, and no hardcoded answers.
=============================================================================
"""

print("=" * 70)
print("PAPER-3: PART 3 - SETS PRACTICE (Q21 - Q30)")
print("STUDENT: TALHA KHAN | ROLL NO: 873676")
print("=" * 70)

# ---------------------------------------------------------------------------
# Q21. Unique Values
# numbers = [10, 20, 10, 30, 40, 20, 50]
# Convert to a set and count unique elements.
# ---------------------------------------------------------------------------
print("\n--- Q21. Unique Values ---")
numbers_q21 = [10, 20, 10, 30, 40, 20, 50]

unique_set_q21 = set(numbers_q21)
count_unique = len(unique_set_q21)

print(f"Original List       : {numbers_q21}")
print(f"Converted Set       : {unique_set_q21}")
print(f"Unique Element Count: {count_unique}")


# ---------------------------------------------------------------------------
# Q22. Set Operations
# a = {1, 2, 3, 4, 5}
# b = {4, 5, 6, 7, 8}
# Find union, intersection, a - b, and symmetric difference.
# ---------------------------------------------------------------------------
print("\n--- Q22. Set Operations ---")
a = {1, 2, 3, 4, 5}
b = {4, 5, 6, 7, 8}

union_set = a | b
intersection_set = a & b
difference_set = a - b
sym_diff_set = a ^ b

print(f"Set a                : {a}")
print(f"Set b                : {b}")
print(f"Union (a | b)        : {union_set}")
print(f"Intersection (a & b) : {intersection_set}")
print(f"Difference (a - b)   : {difference_set}")
print(f"Symmetric Diff (a ^ b): {sym_diff_set}")


# ---------------------------------------------------------------------------
# Q23. Add and Remove
# skills = {"Python", "SQL", "AWS"}
# Add Snowflake and Databricks; safely remove AWS.
# ---------------------------------------------------------------------------
print("\n--- Q23. Add and Remove ---")
skills = {"Python", "SQL", "AWS"}
print(f"Initial Skills: {skills}")

# .update() se multiple items add karna
skills.update({"Snowflake", "Databricks"})

# .discard() se safe removal (agar item na ho tab bhi error nahi aata)
skills.discard("AWS")

print(f"Updated Skills: {skills}")


# ---------------------------------------------------------------------------
# Q24. Common Students
# python_students = {"Ali", "Sara", "Ahmed", "Zain"}
# sql_students = {"Sara", "Ahmed", "Hamza", "Usman"}
# Find students taking both and exactly one course.
# ---------------------------------------------------------------------------
print("\n--- Q24. Common Students ---")
python_students = {"Ali", "Sara", "Ahmed", "Zain"}
sql_students = {"Sara", "Ahmed", "Hamza", "Usman"}

# Dono lene wale: Intersection (&)
both_courses = python_students & sql_students

# Sirf ek course lene wale: Symmetric Difference (^)
exactly_one_course = python_students ^ sql_students

print(f"Students in Both Courses        : {both_courses}")
print(f"Students in Exactly One Course  : {exactly_one_course}")


# ---------------------------------------------------------------------------
# Q25. Subset and Superset
# required_skills = {"Python", "SQL"}
# candidate_skills = {"Python", "SQL", "AWS", "Snowflake"}
# Check required skills are a subset and candidate skills a superset.
# ---------------------------------------------------------------------------
print("\n--- Q25. Subset and Superset ---")
required_skills = {"Python", "SQL"}
candidate_skills = {"Python", "SQL", "AWS", "Snowflake"}

is_subset = required_skills.issubset(candidate_skills)
is_superset = candidate_skills.issuperset(required_skills)

print(f"Required Skills is Subset of Candidate Skills  : {is_subset}")
print(f"Candidate Skills is Superset of Required Skills: {is_superset}")


# ---------------------------------------------------------------------------
# Q26. Missing Numbers
# numbers = {1, 2, 4, 6, 8, 10}
# Find missing integers from 1 through 10 using set operations.
# ---------------------------------------------------------------------------
print("\n--- Q26. Missing Numbers ---")
numbers_q26 = {1, 2, 4, 6, 8, 10}

# 1 se 10 ka complete set range se banaya
full_range_set = set(range(1, 11))
# Set difference se missing numbers nikale
missing_numbers = full_range_set - numbers_q26

print(f"Given Numbers   : {numbers_q26}")
print(f"Missing Numbers : {sorted(missing_numbers)}")


# ---------------------------------------------------------------------------
# Q27. Three-Set Analysis
# python = {"Ali", "Sara", "Ahmed", "Zain"}
# sql = {"Sara", "Ahmed", "Hamza"}
# aws = {"Ahmed", "Zain", "Hamza"}
# Find students in all three, exactly Python and SQL (not AWS), and at least two.
# ---------------------------------------------------------------------------
print("\n--- Q27. Three-Set Analysis ---")
python = {"Ali", "Sara", "Ahmed", "Zain"}
sql = {"Sara", "Ahmed", "Hamza"}
aws = {"Ahmed", "Zain", "Hamza"}

# 1. Teeno courses lene wale (all three)
all_three_students = python & sql & aws

# 2. Exactly Python aur SQL (AWS nahi)
exact_py_sql = (python & sql) - aws

# 3. Kam az kam 2 courses lene wale (at least two)
at_least_two_students = (python & sql) | (sql & aws) | (python & aws)

print(f"In All Three Courses         : {all_three_students}")
print(f"Exactly Python & SQL (No AWS): {exact_py_sql}")
print(f"In At Least Two Courses      : {at_least_two_students}")


# ---------------------------------------------------------------------------
# Q28. Transaction Analysis
# day1 = {101, 102, 103, 104}
# day2 = {103, 104, 105, 106}
# day3 = {104, 106, 107, 108}
# Find IDs appearing on all days, exactly one day, and at least two days.
# ---------------------------------------------------------------------------
print("\n--- Q28. Transaction Analysis ---")
day1 = {101, 102, 103, 104}
day2 = {103, 104, 105, 106}
day3 = {104, 106, 107, 108}

# All days
all_days_txns = day1 & day2 & day3

# Exactly one day (sirf ek din aane wale)
only_day1 = day1 - day2 - day3
only_day2 = day2 - day1 - day3
only_day3 = day3 - day1 - day2
exactly_one_day_txns = only_day1 | only_day2 | only_day3

# At least two days
at_least_two_days_txns = (day1 & day2) | (day2 & day3) | (day1 & day3)

print(f"Transactions on All Days       : {all_days_txns}")
print(f"Transactions on Exactly One Day: {exactly_one_day_txns}")
print(f"Transactions on At Least 2 Days: {at_least_two_days_txns}")


# ---------------------------------------------------------------------------
# Q29. Access Control
# required_permissions = {"read", "write", "execute"}
# user_permissions = {"read", "write", "delete"}
# Find missing and extra permissions and test full authorization.
# ---------------------------------------------------------------------------
print("\n--- Q29. Access Control ---")
required_permissions = {"read", "write", "execute"}
user_permissions = {"read", "write", "delete"}

missing_perms = required_permissions - user_permissions
extra_perms = user_permissions - required_permissions
is_fully_authorized = required_permissions.issubset(user_permissions)

print(f"Missing Permissions : {missing_perms}")
print(f"Extra Permissions   : {extra_perms}")
print(f"Is Fully Authorized : {is_fully_authorized}")


# ---------------------------------------------------------------------------
# Q30. Customer Segmentation
# website = {"C1", "C2", "C3", "C4", "C5"}
# mobile = {"C3", "C4", "C6", "C7"}
# store = {"C2", "C4", "C7", "C8"}
# Find customers on exactly one, exactly two, and all three platforms.
# ---------------------------------------------------------------------------
print("\n--- Q30. Customer Segmentation ---")
website = {"C1", "C2", "C3", "C4", "C5"}
mobile = {"C3", "C4", "C6", "C7"}
store = {"C2", "C4", "C7", "C8"}

# 1. All three platforms
all_three_platforms = website & mobile & store

# 2. Exactly two platforms
pair_overlaps = (website & mobile) | (mobile & store) | (website & store)
exactly_two_platforms = pair_overlaps - all_three_platforms

# 3. Exactly one platform
only_web = website - mobile - store
only_mob = mobile - website - store
only_store = store - website - mobile
exactly_one_platform = only_web | only_mob | only_store

print(f"Customers on All Three Platforms  : {all_three_platforms}")
print(f"Customers on Exactly Two Platforms: {exactly_two_platforms}")
print(f"Customers on Exactly One Platform : {exactly_one_platform}")
