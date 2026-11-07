def analyze_transactions(transactions):
    seen_ids = set()
    valid_transactions = []
    
    for tx in transactions:
        tx_id = tx.get("id")
        if tx_id in seen_ids:
            raise ValueError(f"Duplicate transaction ID: {tx_id}")
        seen_ids.add(tx_id)
        if tx.get("status") == "success":
            valid_transactions.append(tx)
            
    all_customers = {tx["customer"] for tx in transactions}
    customer_spending = {c: 0.0 for c in all_customers}
    customer_categories = {c: {} for c in all_customers}
    
    for tx in valid_transactions:
        cust = tx["customer"]
        cat = tx["category"]
        amt = tx["amount"]
        customer_spending[cust] += amt
        customer_categories[cust][cat] = customer_categories[cust].get(cat, 0.0) + amt
        
    report = []
    for cust in all_customers:
        total = customer_spending[cust]
        cats = customer_categories[cust]
        top_cat = max(sorted(cats.keys()), key=lambda c: cats[c]) if cats else "None"
        report.append({
            "customer": cust,
            "total_spending": total,
            "top_category": top_cat
        })
        
    report.sort(key=lambda x: (-x["total_spending"], x["customer"]))
    
    return [{"rank": i, **item} for i, item in enumerate(report, start=1)]