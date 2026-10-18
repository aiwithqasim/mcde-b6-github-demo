#Q41. Student Performance System

students = [
    {"id": 1, "name": "Ali", "marks": (85, 90, 88)},
    {"id": 2, "name": "Sara", "marks": (92, 95, 91)},
    {"id": 3, "name": "Ahmed", "marks": (78, 84, 80)}
]

# Calculate averages for each student
avg_ali = sum(students[0]["marks"]) / len(students[0]["marks"])
avg_sara = sum(students[1]["marks"]) / len(students[1]["marks"])
avg_ahmed = sum(students[2]["marks"]) / len(students[2]["marks"])

# Find top student based on averages
averages = {students[0]["name"]: avg_ali, students[1]["name"]: avg_sara, students[2]["name"]: avg_ahmed}
top_student = max(averages, key=averages.get)

# Tuple of names
names_tuple = (students[0]["name"], students[1]["name"], students[2]["name"])

# Set of unique marks across all students
unique_marks = set(students[0]["marks"]) | set(students[1]["marks"]) | set(students[2]["marks"])

print("Averages:", averages)
print("Top Student:", top_student)
print("Names Tuple:", names_tuple)
print("Unique Marks:", unique_marks)

#Q42. Employee Skills

employees = {
    "Ali": {"Python", "SQL", "AWS"},
    "Sara": {"Python", "Databricks", "SQL"},
    "Ahmed": {"AWS", "Snowflake", "SQL"}
}

# Find common skills across all employees
common_skills = employees["Ali"] & employees["Sara"] & employees["Ahmed"]

# Find Ali-only skills (compared to others)
ali_only = employees["Ali"] - (employees["Sara"] | employees["Ahmed"])

# Find all team skills (Union)
all_skills = employees["Ali"] | employees["Sara"] | employees["Ahmed"]

# Find employees meeting Python + SQL requirements
python_sql_req = {"Python", "SQL"}
meeting_req = {name for name, skills in employees.items() if python_sql_req.issubset(skills)} # Note: using set literal comparison logic manually if set method used:
# Using purely set methods/membership without loops:
# Checking via issubset manually:
req_ali = python_sql_req.issubset(employees["Ali"])
req_sara = python_sql_req.issubset(employees["Sara"])
req_ahmed = python_sql_req.issubset(employees["Ahmed"])

qualified_employees = {name for name, check in [("Ali", req_ali), ("Sara", req_sara), ("Ahmed", req_ahmed)] if check}

print("Common Skills:", common_skills)
print("Ali-only Skills:", ali_only)
print("All Team Skills:", all_skills)
print("Meeting Python + SQL Requirements:", qualified_employees)

#Q43. Sales Data

sales = [
    ("Laptop", 120000, 2),
    ("Mouse", 1500, 5),
    ("Keyboard", 3500, 3)
]

# Calculate revenues per product
rev_laptop = sales[0][1] * sales[0][2]
rev_mouse = sales[1][1] * sales[1][2]
rev_keyboard = sales[2][1] * sales[2][2]

total_revenue = rev_laptop + rev_mouse + rev_keyboard

# Name-to-revenue dictionary
name_to_revenue = {
    sales[0][0]: rev_laptop,
    sales[1][0]: rev_mouse,
    sales[2][0]: rev_keyboard
}

# Top-revenue product
top_product = max(name_to_revenue, key=name_to_revenue.get)

# Set of prices
prices_set = {sales[0][1], sales[1][1], sales[2][1]}

print("Total Revenue:", total_revenue)
print("Top-Revenue Product:", top_product)
print("Name-to-Revenue Dict:", name_to_revenue)
print("Set of Prices:", prices_set)

#Q44. Customer Order

customers = {
    "C101": {"name": "Ali", "orders": [1200, 2500, 1800]},
    "C102": {"name": "Sara", "orders": [3000, 4500]},
    "C103": {"name": "Ahmed", "orders": [1500, 2000, 1000]}
}

# Calculate spending per customer
spend_c101 = sum(customers["C101"]["orders"])
spend_c102 = sum(customers["C102"]["orders"])
spend_c103 = sum(customers["C103"]["orders"])

spending_dict = {
    customers["C101"]["name"]: spend_c101,
    customers["C102"]["name"]: spend_c102,
    customers["C103"]["name"]: spend_c103
}

# Find top customer
top_customer = max(spending_dict, key=spending_dict.get)

# Tuple of totals in customer ID order
totals_tuple = (spend_c101, spend_c102, spend_c103)

print("Spending Per Customer:", spending_dict)
print("Top Customer:", top_customer)
print("Totals Tuple (C101, C102, C103):", totals_tuple)

#Q45. Course Enrollment

courses = {
    "Python": {"Ali", "Sara", "Ahmed"},
    "SQL": {"Sara", "Ahmed", "Zain"},
    "AWS": {"Ali", "Ahmed", "Zain"}
}

# Find students in all three courses
all_three = courses["Python"] & courses["SQL"] & courses["AWS"]

# Find students in at least two courses
at_least_two = (courses["Python"] & courses["SQL"]) | (courses["SQL"] & courses["AWS"]) | (courses["Python"] & courses["AWS"])

# Students in exactly two courses
exactly_two = at_least_two - all_three

# Students in union of all (to find exactly one)
union_all = courses["Python"] | courses["SQL"] | courses["AWS"]
exactly_one = union_all - at_least_two

# Count unique students
unique_count = len(union_all)

print("In All Three:", all_three)
print("In Exactly Two Courses:", exactly_two)
print("In Exactly One Course:", exactly_one)
print("Count of Unique Students:", unique_count)
LEVEL: EXPERT

#Q46. E-Commerce Transactions

transactions = [
    {"id": 101, "customer": "Ali", "items": [("Laptop", 120000, 1), ("Mouse", 1500, 2)]},
    {"id": 102, "customer": "Sara", "items": [("Keyboard", 3500, 2), ("Mouse", 1500, 1)]},
    {"id": 103, "customer": "Ali", "items": [("Monitor", 45000, 1)]}
]

# Calculate transaction totals
t101_total = (transactions[0]["items"][0][1] * transactions[0]["items"][0][2]) + (transactions[0]["items"][1][1] * transactions[0]["items"][1][2])
t102_total = (transactions[1]["items"][0][1] * transactions[1]["items"][0][2]) + (transactions[1]["items"][1][1] * transactions[1]["items"][1][2])
t103_total = transactions[2]["items"][0][1] * transactions[2]["items"][0][2]

total_revenue = t101_total + t102_total + t103_total

# Ali spending (transactions 101 and 103)
ali_spending = t101_total + t103_total

# Largest transaction ID/value
tx_totals = {transactions[0]["id"]: t101_total, transactions[1]["id"]: t102_total, transactions[2]["id"]: t103_total}
largest_transaction = max(tx_totals, key=tx_totals.get)

# Unique product names using sets
unique_products = {
    transactions[0]["items"][0][0], transactions[0]["items"][1][0],
    transactions[1]["items"][0][0], transactions[1]["items"][1][0],
    transactions[2]["items"][0][0]
}

print("Total Revenue:", total_revenue)
print("Ali Spending:", ali_spending)
print("Largest Transaction ID:", largest_transaction)
print("Unique Product Names:", unique_products)

#Q47. Pipeline Monitoring

pipelines = {
    "pipeline_1": {"status": "success", "records": (1000, 1200, 1100)},
    "pipeline_2": {"status": "failed", "records": (800, 0, 0)},
    "pipeline_3": {"status": "success", "records": (1500, 1600, 1700)}
}

# Total processed records
p1_sum = sum(pipelines["pipeline_1"]["records"])
p2_sum = sum(pipelines["pipeline_2"]["records"])
p3_sum = sum(pipelines["pipeline_3"]["records"])
total_processed = p1_sum + p2_sum + p3_sum

# Failed pipelines check
failed_pipelines = {name for name, info in pipelines.items() if info["status"] == "failed"}

# Largest pipeline total
pipeline_totals = {"pipeline_1": p1_sum, "pipeline_2": p2_sum, "pipeline_3": p3_sum}
largest_pipeline = max(pipeline_totals, key=pipeline_totals.get)

# Average records per run for each
avg_p1 = p1_sum / len(pipelines["pipeline_1"]["records"])
avg_p2 = p2_sum / len(pipelines["pipeline_2"]["records"])
avg_p3 = p3_sum / len(pipelines["pipeline_3"]["records"])

print("Total Processed Records:", total_processed)
print("Failed Pipelines:", failed_pipelines)
print("Largest Pipeline:", largest_pipeline)
print("Averages - P1:", avg_p1, "P2:", avg_p2, "P3:", avg_p3)

#Q48. Banking Transactions

accounts = {
    "A101": {"holder": "Ali", "transactions": [5000, -2000, 3000, -1000]},
    "A102": {"holder": "Sara", "transactions": [10000, -3000, -2000]},
    "A103": {"holder": "Ahmed", "transactions": [7000, -1500, 2500]}
}

# Final balances
bal_a101 = sum(accounts["A101"]["transactions"])
bal_a102 = sum(accounts["A102"]["transactions"])
bal_a103 = sum(accounts["A103"]["transactions"])

balances = {"A101": bal_a101, "A102": bal_a102, "A103": bal_a103}

# Highest balance
highest_balance = max(balances.values())

# Total withdrawals (filtering negative values and summing them)
all_txs = accounts["A101"]["transactions"] + accounts["A102"]["transactions"] + accounts["A103"]["transactions"]
withdrawals = {tx for tx in all_txs if tx < 0}
total_withdrawals = abs(sum(withdrawals))

# Largest single deposit
largest_deposit = max(all_txs)

print("Final Balances:", balances)
print("Highest Balance:", highest_balance)
print("Total Withdrawals:", total_withdrawals)
print("Largest Single Deposit:", largest_deposit)

#Q49. Product Recommendations

users = {
    "Ali": {"purchased": {"Laptop", "Mouse"}, "wishlist": {"Keyboard", "Monitor", "Mouse"}},
    "Sara": {"purchased": {"Keyboard", "Monitor"}, "wishlist": {"Laptop", "Mouse"}},
    "Ahmed": {"purchased": {"Laptop", "Keyboard"}, "wishlist": {"Monitor", "Headphones"}}
}

# Products bought by at least two users
p_ali = users["Ali"]["purchased"]
p_sara = users["Sara"]["purchased"]
p_ahmed = users["Ahmed"]["purchased"]

bought_at_least_two = (p_ali & p_sara) | (p_sara & p_ahmed) | (p_ali & p_ahmed)

# Ali wishlist minus purchases
ali_wishlist_minus_purchases = users["Ali"]["wishlist"] - users["Ali"]["purchased"]

# Shared wishlist products
shared_wishlist = users["Ali"]["wishlist"] & users["Sara"]["wishlist"] & users["Ahmed"]["wishlist"]

# All products across all categories (purchased + wishlist for everyone)
all_products = p_ali | p_sara | p_ahmed | users["Ali"]["wishlist"] | users["Sara"]["wishlist"] | users["Ahmed"]["wishlist"]

print("Bought at Least Two:", bought_at_least_two)
print("Ali Wishlist minus Purchases:", ali_wishlist_minus_purchases)
print("Shared Wishlist Products:", shared_wishlist)
print("All Products:", all_products)

#Q50. Final Company Analysis

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

# 1. Payroll per department
eng_payroll = company["departments"]["Engineering"]["employees"][0][1] + company["departments"]["Engineering"]["employees"][1][1]
analytics_payroll = company["departments"]["Analytics"]["employees"][0][1] + company["departments"]["Analytics"]["employees"][1][1]

# 2. Company payroll
company_payroll = eng_payroll + analytics_payroll

# 3. Highest-paid employee
salaries = {
    company["departments"]["Engineering"]["employees"][0][0]: company["departments"]["Engineering"]["employees"][0][1],
    company["departments"]["Engineering"]["employees"][1][0]: company["departments"]["Engineering"]["employees"][1][1],
    company["departments"]["Analytics"]["employees"][0][0]: company["departments"]["Analytics"]["employees"][0][1],
    company["departments"]["Analytics"]["employees"][1][0]: company["departments"]["Analytics"]["employees"][1][1]
}
highest_paid = max(salaries, key=salaries.get)

# 4. Skills shared by all employees in the company
eng_skills_1 = company["departments"]["Engineering"]["employees"][0][2]
eng_skills_2 = company["departments"]["Engineering"]["employees"][1][2]
an_skills_1 = company["departments"]["Analytics"]["employees"][0][2]
an_skills_2 = company["departments"]["Analytics"]["employees"][1][2]

shared_all = eng_skills_1 & eng_skills_2 & an_skills_1 & an_skills_2

# 5. Engineering-only skills (skills in Engineering not in Analytics)
eng_all_skills = eng_skills_1 | eng_skills_2
an_all_skills = an_skills_1 | an_skills_2
engineering_only = eng_all_skills - an_all_skills

# 6. Remaining budget per department
eng_remaining_budget = company["departments"]["Engineering"]["budget"] - eng_payroll
analytics_remaining_budget = company["departments"]["Analytics"]["budget"] - analytics_payroll

# 7. Department with higher average salary
eng_avg_sal = eng_payroll / 2
analytics_avg_sal = analytics_payroll / 2
higher_avg_dept = "Engineering" if eng_avg_sal > analytics_avg_sal else "Analytics"

# 8. Name-to-salary dictionary
name_to_salary = salaries

# 9. All unique skills
unique_skills_all = eng_all_skills | an_all_skills

# 10. Is combined budget sufficient?
total_budget = company["departments"]["Engineering"]["budget"] + company["departments"]["Analytics"]["budget"]
budget_sufficient = total_budget >= company_payroll

print("1. Engineering Payroll:", eng_payroll, "| Analytics Payroll:", analytics_payroll)
print("2. Company Payroll:", company_payroll)
print("3. Highest-Paid Employee:", highest_paid)
print("4. Shared by All:", shared_all)
print("5. Engineering-Only Skills:", engineering_only)
print("6. Remaining Budgets - Engineering:", eng_remaining_budget, "| Analytics:", analytics_remaining_budget)
print("7. Higher Average Salary Dept:", higher_avg_dept)
print("8. Name-to-Salary Dict:", name_to_salary)
print("9. All Unique Skills:", unique_skills_all)
print("10. Combined Budget Sufficient?:", budget_sufficient)