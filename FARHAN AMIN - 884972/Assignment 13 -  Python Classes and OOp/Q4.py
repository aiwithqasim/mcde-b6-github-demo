class Vehicle:
    def __init__(self, brand, model, daily_rental_rate):
        self.brand = brand
        self.model = model
        self.daily_rental_rate = daily_rental_rate

    def calculate_rent(self, days):
        # Validation: Days zero ya negative nahi hone chahiye
        if days <= 0:
            print("❌ Error: Rental duration must be greater than zero days.")
            return None
        return self.daily_rental_rate * days


class Car(Vehicle):
    def __init__(self, brand, model, daily_rental_rate):
        super().__init__(brand, model, daily_rental_rate)
        self.insurance_fee = 1000  # Fixed insurance fee Rs. 1000

    def calculate_rent(self, days):
        base_rent = super().calculate_rent(days)
        if base_rent is None:
            return None
        # Base rent mein insurance plus kar di
        total_rent = base_rent + self.insurance_fee
        return total_rent


class Bike(Vehicle):
    def calculate_rent(self, days):
        base_rent = super().calculate_rent(days)
        if base_rent is None:
            return None
        # 10% discount apply kiya (yaani sirf 90% amount pay karni hy)
        total_rent = base_rent * 0.90
        return total_rent


# --- Test Cases ---
print("--- Testing Rental System for 3 Days ---")

# 1. Car Test (Rate: Rs. 3000 per day)
my_car = Car("Honda", "Civic", 3000)
car_bill = my_car.calculate_rent(3)
if car_bill:
    print(f"🚗 {my_car.brand} {my_car.model} Total Rent (with Insurance): Rs. {car_bill:.2f}")

# 2. Bike Test (Rate: Rs. 1000 per day)
my_bike = Bike("Yamaha", "YBR", 1000)
bike_bill = my_bike.calculate_rent(3)
if bike_bill:
    print(f"🏍️ {my_bike.brand} {my_bike.model} Total Rent (with 10% Discount): Rs. {bike_bill:.2f}")

print("\n--- Testing Invalid Input Validation ---")
my_car.calculate_rent(0)  # Yeh error status print kare ga
