transactions = [
    {"id": 1, "customer": "Ali", "category": "Food", "amount": 500, "status": "success"},
    {"id": 2, "customer": "Ali", "category": "Travel", "amount": 200, "status": "failed"},
    {"id": 3, "customer": "Sara", "category": "Food", "amount": 700, "status": "success"}
]


seen_ids = set()
valid_txs = []
all_customers = set()

for tx in transactions:
    all_customers.add(tx["customer"])
    
    
    if tx["id"] in seen_ids:
        continue
    seen_ids.add(tx["id"])
    
    
    if tx["status"] == "success":
        valid_txs.append(tx)


spending = {cust: 0 for cust in all_customers}
category_spending = {cust: {} for cust in all_customers}

for tx in valid_txs:
    cust = tx["customer"]
    cat = tx["category"]
    amt = tx["amount"]
    
    spending[cust] += amt
    
    if cat not in category_spending[cust]:
        category_spending[cust][cat] = 0
    category_spending[cust][cat] += amt


report = []
for cust in all_customers:
    total = spending[cust]
    cats = category_spending[cust]
    
    

    if cats:
        top_cat = max(cats, key=cats.get)
    else:
        top_cat = "None"
        
    report.append({
        "customer": cust,
        "spending": total,
        "top_category": top_cat
    })
 

report.sort(key=lambda x: (-x["spending"], x["customer"]))

 
for rank, item in enumerate(report, start=1):
    item["rank"] = rank

 
print("--- Final Report ---")
for r in report:
    print(f"Rank {r['rank']} | Customer: {r['customer']} | Spending: {r['spending']} | Top Category: {r['top_category']}")  