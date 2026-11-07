import csv

def reconcile_inventory(inventory_path, movements_path, updated_inventory_path, rejected_movements_path):
    inventory = {}
    with open(inventory_path, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            sku = row['sku'].strip()
            inventory[sku] = {
                'name': row['name'].strip(),
                'quantity': int(row['quantity'])
            }

    rejected = []
    with open(movements_path, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            sku = row.get('sku', '').strip()
            m_type = row.get('type', '').strip().upper()
            
            try:
                units = int(row.get('units', 0))
            except (ValueError, TypeError):
                rejected.append({**row, 'reason': 'Invalid units'})
                continue

            if sku not in inventory:
                rejected.append({**row, 'reason': 'Unknown SKU'})
                continue

            if m_type not in ('IN', 'OUT'):
                rejected.append({**row, 'reason': 'Invalid type'})
                continue

            if units <= 0:
                rejected.append({**row, 'reason': 'Non-positive units'})
                continue

            if m_type == 'OUT':
                if inventory[sku]['quantity'] < units:
                    rejected.append({**row, 'reason': 'Insufficient stock'})
                    continue
                inventory[sku]['quantity'] -= units
            elif m_type == 'IN':
                inventory[sku]['quantity'] += units

    with open(updated_inventory_path, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['sku', 'name', 'quantity'])
        writer.writeheader()
        for sku, data in inventory.items():
            writer.writerow({'sku': sku, 'name': data['name'], 'quantity': data['quantity']})

    with open(rejected_movements_path, mode='w', newline='', encoding='utf-8') as f:
        fieldnames = ['sku', 'type', 'units', 'reason']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for rej in rejected:
            writer.writerow(rej)    