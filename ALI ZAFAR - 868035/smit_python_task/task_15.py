import json
import os
import uuid
import unittest

class Product:
    def __init__(self, product_id, name, price, stock):
        self.product_id = product_id
        self.name = name
        self.price = float(price)
        self.stock = int(stock)

class Inventory:
    def __init__(self, catalog_path="catalog.json"):
        self.catalog_path = catalog_path
        self.products = {}
        self.load_catalog()

    def load_catalog(self):
        if not os.path.exists(self.catalog_path):
            self.products = {}
            return
        with open(self.catalog_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            for item in data:
                self.products[item['product_id']] = Product(
                    item['product_id'], item['name'], item['price'], item['stock']
                )

    def save_catalog(self):
        data = [{
            'product_id': p.product_id,
            'name': p.name,
            'price': p.price,
            'stock': p.stock
        } for p in self.products.values()]
        with open(self.catalog_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4)

    def get_product(self, product_id):
        if product_id not in self.products:
            raise ValueError(f"Product ID {product_id} not found.")
        return self.products[product_id]


class Cart:
    def __init__(self):
        self.items = {}  # {product_id: quantity}
        self.discount_percentage = 0.0

    def add_item(self, product_id, quantity):
        if quantity <= 0:
            raise ValueError("Quantity must be positive.")
        if product_id in self.items:
            self.items[product_id] += quantity
        else:
            self.items[product_id] = quantity

    def apply_discount(self, percentage):
        if not (0 <= percentage <= 100):
            raise ValueError("Discount percentage must be between 0 and 100.")
        self.discount_percentage = float(percentage)

    def calculate_total(self, inventory):
        subtotal = 0.0
        for pid, qty in self.items.items():
            product = inventory.get_product(pid)
            subtotal += product.price * qty
        
        discount_amount = subtotal * (self.discount_percentage / 100.0)
        total = subtotal - discount_amount
        return round(total, 2)


class OrderSystem:
    def __init__(self, inventory, orders_path="orders.json"):
        self.inventory = inventory
        self.orders_path = orders_path

    def place_order(self, cart):
        if not cart.items:
            raise ValueError("Cart is empty.")

        # Step 1: Validate stock for ALL items before modifying anything
        for pid, qty in cart.items.items():
            product = self.inventory.get_product(pid)
            if product.stock < qty:
                raise ValueError(f"Insufficient stock for product {pid}. Available: {product.stock}, Requested: {qty}")

        # Step 2: Deduct inventory stock
        deducted_items = []
        for pid, qty in cart.items.items():
            product = self.inventory.get_product(pid)
            product.stock -= qty
            deducted_items.append((product, qty))

        total_amount = cart.calculate_total(self.inventory)
        order_id = str(uuid.uuid4())
        
        order_record = {
            "order_id": order_id,
            "items": cart.items,
            "total_amount": total_amount,
            "discount_percentage": cart.discount_percentage
        }

        # Step 3: Persist order to JSON (with rollback on failure)
        try:
            orders = []
            if os.path.exists(self.orders_path):
                with open(self.orders_path, 'r', encoding='utf-8') as f:
                    orders = json.load(f)
            orders.append(order_record)
            with open(self.orders_path, 'w', encoding='utf-8') as f:
                json.dump(orders, f, indent=4)
        except Exception as e:
            # Rollback inventory stock changes
            for product, qty in deducted_items:
                product.stock += qty
            raise RuntimeError(f"Order persistence failed, inventory rolled back: {e}")

        self.inventory.save_catalog()
        return order_id


# --- Unit Tests ---
class TestOrderFulfillmentSystem(unittest.TestCase):
    def setUp(self):
        self.catalog_file = "test_catalog.json"
        self.orders_file = "test_orders.json"
        
        initial_catalog = [
            {"product_id": "P1", "name": "Laptop", "price": 100.0, "stock": 5},
            {"product_id": "P2", "name": "Mouse", "price": 20.0, "stock": 10}
        ]
        with open(self.catalog_file, 'w', encoding='utf-8') as f:
            json.dump(initial_catalog, f)
            
        if os.path.exists(self.orders_file):
            os.remove(self.orders_file)

        self.inventory = Inventory(self.catalog_file)
        self.system = OrderSystem(self.inventory, self.orders_file)

    def tearDown(self):
        if os.path.exists(self.catalog_file):
            os.remove(self.catalog_file)
        if os.path.exists(self.orders_file):
            os.remove(self.orders_file)

    def test_successful_order_with_discount(self):
        cart = Cart()
        cart.add_item("P1", 2)
        cart.apply_discount(10)  # 10% discount on 200 -> 180
        
        total = cart.calculate_total(self.inventory)
        self.assertEqual(total, 180.0)

        order_id = self.system.place_order(cart)
        self.assertIsNotNone(order_id)
        self.assertEqual(self.inventory.get_product("P1").stock, 3)

    def test_out_of_stock_rejection(self):
        cart = Cart()
        cart.add_item("P1", 10)  # Only 5 in stock
        
        with self.assertRaises(ValueError):
            self.system.place_order(cart)
        
        # Stock should remain unchanged
        self.assertEqual(self.inventory.get_product("P1").stock, 5)

    def test_inventory_rollback_on_persistence_failure(self):
        cart = Cart()
        cart.add_item("P2", 3)
        
        # Force invalid orders path to simulate persistence failure
        self.system.orders_path = "/invalid_directory_path/orders.json"
        
        with self.assertRaises(RuntimeError):
            self.system.place_order(cart)
            
        # Verify stock was rolled back successfully
        self.assertEqual(self.inventory.get_product("P2").stock, 10)


if __name__ == "__main__":
    unittest.main(argv=['first-arg-is-ignored'], exit=False)