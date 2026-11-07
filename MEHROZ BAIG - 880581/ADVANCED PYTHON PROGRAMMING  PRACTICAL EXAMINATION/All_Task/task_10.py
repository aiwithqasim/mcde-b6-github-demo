import csv

def reconcile_inventory(inventory_path, movements_path, updated_path, rejected_path):
    inventory = {}
    with open(inventory_path, mode='r', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            inventory[row['sku']] = {'name': row['name'], 'quantity': int(row['quantity'])}
            
    rejected_rows = []
    with open(movements_path, mode='r', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            sku, mov_type = row['sku'], row['type']
            try:
                units = int(row['units'])
            except ValueError:
                rejected_rows.append({**row, 'reason': 'Invalid unit format'})
                continue
                
            if sku not in inventory:
                rejected_rows.append({**row, 'reason': 'Unknown SKU'})
                continue
            if units <= 0:
                rejected_rows.append({**row, 'reason': 'Units must be positive'})
                continue
                
            if mov_type == 'IN':
                inventory[sku]['quantity'] += units
            elif mov_type == 'OUT':
                if inventory[sku]['quantity'] < units:
                    rejected_rows.append({**row, 'reason': 'Insufficient stock for OUT'})
                    continue
                inventory[sku]['quantity'] -= units
            else:
                rejected_rows.append({**row, 'reason': 'Invalid movement type'})
                
    with open(updated_path, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['sku', 'name', 'quantity'])
        writer.writeheader()
        for sku, data in inventory.items():
            writer.writerow({'sku': sku, **data})
            
    with open(rejected_path, mode='w', newline='', encoding='utf-8') as f:
        fieldnames = list(rejected_rows[0].keys()) if rejected_rows else ['sku', 'type', 'units', 'reason']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rejected_rows:
            writer.writerow(row)