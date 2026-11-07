"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assessment   : PAPER-3 PYTHON FINAL ASSESSMENT
Part 5 of 5  : Python Practice: Mixed Data Structures (Questions 41 to 50)
RULES        : No for/while loops, no comprehensions, no recursion,
               no map/filter/reduce, and no hardcoded answers.
=============================================================================
"""

print("=" * 70)
print("PAPER-3: PART 5 - MIXED DATA STRUCTURES PRACTICE (Q41 - Q50)")
print("STUDENT: TALHA KHAN | ROLL NO: 873676")
print("=" * 70)

# ---------------------------------------------------------------------------
# Q41. Student Performance System
# Calculate each average, top student, tuple of names, and set of unique marks.
# ---------------------------------------------------------------------------
print("\n--- Q41. Student Performance System ---")
students = [
    {"id": 1, "name": "Ali", "marks": (85, 90, 88)},
    {"id": 2, "name": "Sara", "marks": (92, 95, 91)},
    {"id": 3, "name": "Ahmed", "marks": (78, 84, 80)}
]

avg_ali = sum(students[0]["marks"]) / len(students[0]["marks"])
avg_sara = sum(students[1]["marks"]) / len(students[1]["marks"])
avg_ahmed = sum(students[2]["marks"]) / len(students[2]["marks"])

student_averages = {
    students[0]["name"]: avg_ali,
    students[1]["name"]: avg_sara,
    students[2]["name"]: avg_ahmed
}

top_student = max(student_averages, key=student_averages.get)
names_tuple = (students[0]["name"], students[1]["name"], students[2]["name"])
unique_marks_set = set(students[0]["marks"] + students[1]["marks"] + students[2]["marks"])

print(f"Student Averages    : {student_averages}")
print(f"Top Student         : {top_student}")
print(f"Tuple of Names      : {names_tuple}")
print(f"Set of Unique Marks : {unique_marks_set}")


# ---------------------------------------------------------------------------
# Q42. Employee Skills
# Find common skills, Ali-only skills, all team skills,
# and employees meeting Python + SQL requirements.
# ---------------------------------------------------------------------------
print("\n--- Q42. Employee Skills ---")
employees = {
    "Ali": {"Python", "SQL", "AWS"},
    "Sara": {"Python", "Databricks", "SQL"},
    "Ahmed": {"AWS", "Snowflake", "SQL"}
}

common_skills = employees["Ali"] & employees["Sara"] & employees["Ahmed"]
ali_only_skills = employees["Ali"] - employees["Sara"] - employees["Ahmed"]
all_team_skills = employees["Ali"] | employees["Sara"] | employees["Ahmed"]

required_skills = {"Python", "SQL"}
eligible_employees = (
    (["Ali"] if required_skills.issubset(employees["Ali"]) else []) +
    (["Sara"] if required_skills.issubset(employees["Sara"]) else []) +
    (["Ahmed"] if required_skills.issubset(employees["Ahmed"]) else [])
)

print(f"Common Skills (All)     : {common_skills}")
print(f"Ali-Only Skills         : {ali_only_skills}")
print(f"All Team Skills         : {all_team_skills}")
print(f"Python + SQL Employees  : {eligible_employees}")


# ---------------------------------------------------------------------------
# Q43. Sales Data
# Calculate revenue, top-revenue product, name-to-revenue dict, and set of prices.
# ---------------------------------------------------------------------------
print("\n--- Q43. Sales Data ---")
sales = [
    ("Laptop", 120000, 2),
    ("Mouse", 1500, 5),
    ("Keyboard", 3500, 3)
]

rev_laptop = sales[0][1] * sales[0][2]
rev_mouse = sales[1][1] * sales[1][2]
rev_keyboard = sales[2][1] * sales[2][2]
total_sales_revenue = rev_laptop + rev_mouse + rev_keyboard

name_to_revenue = {
    sales[0][0]: rev_laptop,
    sales[1][0]: rev_mouse,
    sales[2][0]: rev_keyboard
}

top_revenue_product = max(name_to_revenue, key=name_to_revenue.get)
prices_set = {sales[0][1], sales[1][1], sales[2][1]}

print(f"Total Revenue       : Rs. {total_sales_revenue:,.2f}")
print(f"Name-to-Revenue Dict: {name_to_revenue}")
print(f"Top-Revenue Product : {top_revenue_product}")
print(f"Set of Prices       : {prices_set}")


# ---------------------------------------------------------------------------
# Q44. Customer Orders
# Calculate spending per customer, top customer, and tuple of totals in ID order.
# ---------------------------------------------------------------------------
print("\n--- Q44. Customer Orders ---")
customers = {
    "C101": {"name": "Ali", "orders": [1200, 2500, 1800]},
    "C102": {"name": "Sara", "orders": [3000, 4500]},
    "C103": {"name": "Ahmed", "orders": [1500, 2000, 1000]}
}

spend_c101 = sum(customers["C101"]["orders"])
spend_c102 = sum(customers["C102"]["orders"])
spend_c103 = sum(customers["C103"]["orders"])

spending_per_customer = {
    customers["C101"]["name"]: spend_c101,
    customers["C102"]["name"]: spend_c102,
    customers["C103"]["name"]: spend_c103
}

top_customer = max(spending_per_customer, key=spending_per_customer.get)
totals_in_id_order = (spend_c101, spend_c102, spend_c103)

print(f"Spending per Customer : {spending_per_customer}")
print(f"Top Customer          : {top_customer}")
print(f"Totals in ID Order    : {totals_in_id_order}")


# ---------------------------------------------------------------------------
# Q45. Course Enrollment
# Find students in exactly two, all three, and exactly one; count unique.
# ---------------------------------------------------------------------------
print("\n--- Q45. Course Enrollment ---")
courses = {
    "Python": {"Ali", "Sara", "Ahmed"},
    "SQL": {"Sara", "Ahmed", "Zain"},
    "AWS": {"Ali", "Ahmed", "Zain"}
}

c_py = courses["Python"]
c_sql = courses["SQL"]
c_aws = courses["AWS"]

all_three_courses = c_py & c_sql & c_aws
at_least_two_courses = (c_py & c_sql) | (c_sql & c_aws) | (c_py & c_aws)
exactly_two_courses = at_least_two_courses - all_three_courses

all_unique_students = c_py | c_sql | c_aws
exactly_one_course = all_unique_students - at_least_two_courses
unique_student_count = len(all_unique_students)

print(f"In All Three Courses    : {all_three_courses}")
print(f"In Exactly Two Courses  : {exactly_two_courses}")
print(f"In Exactly One Course   : {exactly_one_course}")
print(f"Unique Student Count    : {unique_student_count}")


# ---------------------------------------------------------------------------
# Q46. E-Commerce Transactions
# Calculate total revenue, Ali spending, largest transaction, unique products.
# ---------------------------------------------------------------------------
print("\n--- Q46. E-Commerce Transactions ---")
transactions = [
    {"id": 101, "customer": "Ali", "items": [("Laptop", 120000, 1), ("Mouse", 1500, 2)]},
    {"id": 102, "customer": "Sara", "items": [("Keyboard", 3500, 2), ("Mouse", 1500, 1)]},
    {"id": 103, "customer": "Ali", "items": [("Monitor", 45000, 1)]}
]

txn101_val = (transactions[0]["items"][0][1] * transactions[0]["items"][0][2]) + (transactions[0]["items"][1][1] * transactions[0]["items"][1][2])
txn102_val = (transactions[1]["items"][0][1] * transactions[1]["items"][0][2]) + (transactions[1]["items"][1][1] * transactions[1]["items"][1][2])
txn103_val = transactions[2]["items"][0][1] * transactions[2]["items"][0][2]

total_ecommerce_revenue = txn101_val + txn102_val + txn103_val
ali_total_spending = txn101_val + txn103_val

txn_amounts = {101: txn101_val, 102: txn102_val, 103: txn103_val}
largest_txn_id = max(txn_amounts, key=txn_amounts.get)

unique_product_names = {
    transactions[0]["items"][0][0],
    transactions[0]["items"][1][0],
    transactions[1]["items"][0][0],
    transactions[1]["items"][1][0],
    transactions[2]["items"][0][0]
}

print(f"Total Revenue       : Rs. {total_ecommerce_revenue:,.2f}")
print(f"Ali Total Spending  : Rs. {ali_total_spending:,.2f}")
print(f"Largest Transaction : ID {largest_txn_id} (Rs. {txn_amounts[largest_txn_id]:,.2f})")
print(f"Unique Product Names: {unique_product_names}")


# ---------------------------------------------------------------------------
# Q47. Pipeline Monitoring
# Find total processed records, failed pipelines, largest pipeline total,
# and average records per run for each.
# ---------------------------------------------------------------------------
print("\n--- Q47. Pipeline Monitoring ---")
pipelines = {
    "pipeline_1": {"status": "success", "records": (1000, 1200, 1100)},
    "pipeline_2": {"status": "failed", "records": (800, 0, 0)},
    "pipeline_3": {"status": "success", "records": (1500, 1600, 1700)}
}

p1_total = sum(pipelines["pipeline_1"]["records"])
p2_total = sum(pipelines["pipeline_2"]["records"])
p3_total = sum(pipelines["pipeline_3"]["records"])
total_processed_records = p1_total + p2_total + p3_total

failed_pipeline_names = (
    (["pipeline_1"] if pipelines["pipeline_1"]["status"] == "failed" else []) +
    (["pipeline_2"] if pipelines["pipeline_2"]["status"] == "failed" else []) +
    (["pipeline_3"] if pipelines["pipeline_3"]["status"] == "failed" else [])
)

pipeline_totals = {"pipeline_1": p1_total, "pipeline_2": p2_total, "pipeline_3": p3_total}
largest_pipeline = max(pipeline_totals, key=pipeline_totals.get)

avg_records_per_pipeline = {
    "pipeline_1": p1_total / len(pipelines["pipeline_1"]["records"]),
    "pipeline_2": p2_total / len(pipelines["pipeline_2"]["records"]),
    "pipeline_3": p3_total / len(pipelines["pipeline_3"]["records"])
}

print(f"Total Processed Records  : {total_processed_records}")
print(f"Failed Pipelines         : {failed_pipeline_names}")
print(f"Largest Pipeline Total   : {largest_pipeline} ({pipeline_totals[largest_pipeline]} records)")
print(f"Average Records per Run  : {avg_records_per_pipeline}")


# ---------------------------------------------------------------------------
# Q48. Banking Transactions
# Calculate final balances, highest balance, total withdrawals, largest single deposit.
# ---------------------------------------------------------------------------
print("\n--- Q48. Banking Transactions ---")
accounts = {
    "A101": {"holder": "Ali", "transactions": [5000, -2000, 3000, -1000]},
    "A102": {"holder": "Sara", "transactions": [10000, -3000, -2000]},
    "A103": {"holder": "Ahmed", "transactions": [7000, -1500, 2500]}
}

bal_a101 = sum(accounts["A101"]["transactions"])
bal_a102 = sum(accounts["A102"]["transactions"])
bal_a103 = sum(accounts["A103"]["transactions"])

final_balances = {"Ali": bal_a101, "Sara": bal_a102, "Ahmed": bal_a103}
highest_balance_holder = max(final_balances, key=final_balances.get)

# Extract withdrawals (negative transactions) using direct indexing
withdrawals_ali = abs(accounts["A101"]["transactions"][1]) + abs(accounts["A101"]["transactions"][3])
withdrawals_sara = abs(accounts["A102"]["transactions"][1]) + abs(accounts["A102"]["transactions"][2])
withdrawals_ahmed = abs(accounts["A103"]["transactions"][1])
total_all_withdrawals = withdrawals_ali + withdrawals_sara + withdrawals_ahmed

# Largest single deposit from all transactions
all_transactions = (
    accounts["A101"]["transactions"] +
    accounts["A102"]["transactions"] +
    accounts["A103"]["transactions"]
)
largest_single_deposit = max(all_transactions)

print(f"Final Balances         : {final_balances}")
print(f"Highest Balance        : {highest_balance_holder} (Rs. {final_balances[highest_balance_holder]:,.2f})")
print(f"Total Withdrawals      : Rs. {total_all_withdrawals:,.2f}")
print(f"Largest Single Deposit : Rs. {largest_single_deposit:,.2f}")


# ---------------------------------------------------------------------------
# Q49. Product Recommendations
# Find products bought by >= 2 users, Ali wishlist - purchases,
# shared wishlist products, and all products.
# ---------------------------------------------------------------------------
print("\n--- Q49. Product Recommendations ---")
users = {
    "Ali": {"purchased": {"Laptop", "Mouse"}, "wishlist": {"Keyboard", "Monitor", "Mouse"}},
    "Sara": {"purchased": {"Keyboard", "Monitor"}, "wishlist": {"Laptop", "Mouse"}},
    "Ahmed": {"purchased": {"Laptop", "Keyboard"}, "wishlist": {"Monitor", "Headphones"}}
}

p_ali = users["Ali"]["purchased"]
p_sara = users["Sara"]["purchased"]
p_ahmed = users["Ahmed"]["purchased"]

# Products bought by at least two users
bought_by_at_least_two = (p_ali & p_sara) | (p_sara & p_ahmed) | (p_ali & p_ahmed)

# Ali wishlist minus purchases
ali_wish_minus_purchases = users["Ali"]["wishlist"] - users["Ali"]["purchased"]

w_ali = users["Ali"]["wishlist"]
w_sara = users["Sara"]["wishlist"]
w_ahmed = users["Ahmed"]["wishlist"]

# Shared wishlist products (by at least two users)
shared_wishlist_items = (w_ali & w_sara) | (w_sara & w_ahmed) | (w_ali & w_ahmed)

# All products across purchases and wishlists
all_distinct_products = p_ali | p_sara | p_ahmed | w_ali | w_sara | w_ahmed

print(f"Bought by >= 2 Users     : {bought_by_at_least_two}")
print(f"Ali Wishlist - Purchases : {ali_wish_minus_purchases}")
print(f"Shared Wishlist Products : {shared_wishlist_items}")
print(f"All Unique Products      : {all_distinct_products}")


# ---------------------------------------------------------------------------
# Q50. Final Company Analysis (10 Tasks)
# ---------------------------------------------------------------------------
print("\n--- Q50. Final Company Analysis ---")
company = {
    "departments": {
        "Engineering": {
            "employees": [
                ("Ali", 120000, {"Python", "AWS", "SQL"}),
                ("Sara", 150000, {"Python", "Databricks", "SQL"})
            ],
            "budget": 500000
        },
        "Analytics": {
            "employees": [
                ("Ahmed", 100000, {"SQL", "Power BI"}),
                ("Zain", 130000, {"Python", "SQL", "Tableau"})
            ],
            "budget": 400000
        }
    }
}

eng_emp = company["departments"]["Engineering"]["employees"]
ana_emp = company["departments"]["Analytics"]["employees"]

# 1. Payroll per department
eng_payroll = eng_emp[0][1] + eng_emp[1][1]
analytics_payroll = ana_emp[0][1] + ana_emp[1][1]
payroll_per_dept = {"Engineering": eng_payroll, "Analytics": analytics_payroll}

# 2. Company payroll
company_total_payroll = eng_payroll + analytics_payroll

# 3. Highest-paid employee
name_to_salary = {
    eng_emp[0][0]: eng_emp[0][1],
    eng_emp[1][0]: eng_emp[1][1],
    ana_emp[0][0]: ana_emp[0][1],
    ana_emp[1][0]: ana_emp[1][1]
}
highest_paid_employee = max(name_to_salary, key=name_to_salary.get)

# 4. Skills shared by all
skills_shared_by_all = eng_emp[0][2] & eng_emp[1][2] & ana_emp[0][2] & ana_emp[1][2]

# 5. Engineering-only skills
all_eng_skills = eng_emp[0][2] | eng_emp[1][2]
all_ana_skills = ana_emp[0][2] | ana_emp[1][2]
engineering_only_skills = all_eng_skills - all_ana_skills

# 6. Remaining budget per department
rem_budget_eng = company["departments"]["Engineering"]["budget"] - eng_payroll
rem_budget_ana = company["departments"]["Analytics"]["budget"] - analytics_payroll
remaining_budget_per_dept = {"Engineering": rem_budget_eng, "Analytics": rem_budget_ana}

# 7. Department with higher average salary
avg_salary_eng = eng_payroll / len(eng_emp)
avg_salary_ana = analytics_payroll / len(ana_emp)
dept_higher_avg = "Engineering" if avg_salary_eng > avg_salary_ana else "Analytics"

# 8. Name-to-salary dictionary (Already created as name_to_salary)

# 9. All unique skills
all_unique_company_skills = all_eng_skills | all_ana_skills

# 10. Is combined budget sufficient?
combined_budget = company["departments"]["Engineering"]["budget"] + company["departments"]["Analytics"]["budget"]
is_combined_budget_sufficient = combined_budget >= company_total_payroll

print(f"1. Payroll per Department             : {payroll_per_dept}")
print(f"2. Total Company Payroll              : Rs. {company_total_payroll:,.2f}")
print(f"3. Highest-Paid Employee              : {highest_paid_employee} (Rs. {name_to_salary[highest_paid_employee]:,.2f})")
print(f"4. Skills Shared by All               : {skills_shared_by_all}")
print(f"5. Engineering-Only Skills            : {engineering_only_skills}")
print(f"6. Remaining Budget per Department    : {remaining_budget_per_dept}")
print(f"7. Dept with Higher Average Salary    : {dept_higher_avg} (Eng: Rs. {avg_salary_eng:,.2f} vs Ana: Rs. {avg_salary_ana:,.2f})")
print(f"8. Name-to-Salary Dictionary          : {name_to_salary}")
print(f"9. All Unique Skills Across Company   : {all_unique_company_skills}")
print(f"10. Is Combined Budget Sufficient?    : {is_combined_budget_sufficient} (Budget: Rs. {combined_budget:,.2f} >= Payroll: Rs. {company_total_payroll:,.2f})")
