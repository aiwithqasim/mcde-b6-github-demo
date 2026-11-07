import json
import uuid
import unittest

class Product:
    def __init__(self, product_id, name, price, stock):
        self.product_id = product_id
        self.name = name
        self.price = float(price)
        self.stock = int(stock)

class Inventory:
    def __init__(self, catalog_path):
        self.products = {}
        self.load_catalog(catalog_path)

    def load_catalog(self, path):
        with open(path, 'r', encoding='utf-8') as f:
            for item in json.load(f):
                self.products[item['product_id']] = Product(
                    item['product_id'], item['name'], item['price'], item['stock']
                )

    def get_product(self, product_id):
        return self.products.get(product_id)

    def update_stock(self, product_id, qty_change):
        if product_id not in self.products:
            raise ValueError("Product not found")
        new_stock = self.products[product_id].stock + qty_change
        if new_stock < 0:
            raise ValueError("Insufficient stock")
        self.products[product_id].stock = new_stock

class Cart:
    def __init__(self):
        self.items = {}

    def add_item(self, product_id, quantity):
        if quantity <= 0:
            raise ValueError("Quantity must be positive")
        self.items[product_id] = self.items.get(product_id, 0) + quantity

    def compute_total(self, inventory, discount_percent=0.0):
        subtotal = 0.0
        for p_id, qty in self.items.items():
            product = inventory.get_product(p_id)
            if not product:
                raise ValueError(f"Product {p_id} not in catalog")
            subtotal += product.price * qty
        return subtotal * (1.0 - discount_percent / 100.0)

class Order:
    def __init__(self, cart, inventory, discount_percent=0.0, orders_file="orders.json"):
        self.order_id = str(uuid.uuid4())[:8]
        self.cart_items = cart.items.copy()
        self.total_amount = cart.compute_total(inventory, discount_percent)
        self.orders_file = orders_file
        
        for p_id, qty in self.cart_items.items():
            prod = inventory.get_product(p_id)
            if not prod or prod.stock < qty:
                raise ValueError(f"Out of stock for product {p_id}")

        try:
            for p_id, qty in self.cart_items.items():
                inventory.update_stock(p_id, -qty)
            self._persist_order()
        except Exception as e:
            for p_id, qty in self.cart_items.items():
                inventory.update_stock(p_id, qty)
            raise RuntimeError(f"Order failed and rolled back: {e}")

    def _persist_order(self):
        orders = []
        try:
            with open(self.orders_file, 'r', encoding='utf-8') as f:
                content = f.read().strip()
                if content:
                    orders = json.loads(content)
        except (FileNotFoundError, json.JSONDecodeError):
            pass

        orders.append({"order_id": self.order_id, "items": self.cart_items, "total_amount": self.total_amount})
        with open(self.orders_file, 'w', encoding='utf-8') as f:
            json.dump(orders, f, indent=4)