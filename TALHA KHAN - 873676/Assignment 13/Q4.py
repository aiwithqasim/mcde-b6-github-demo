"""
=============================================================================
Student Name : TALHA KHAN
Roll Number  : 873676
Assignment   : Assignment 13 - Python Classes and OOP
Pillar 2     : Inheritance
Question 4   : Vehicle Rental System | Intermediate
=============================================================================
"""

# Base Class Vehicle: Tamam vehicles ki bunyadi information
class Vehicle:
    def __init__(self, brand: str, model: str, daily_rental_rate: float):
        self.brand: str = brand
        self.model: str = model
        self.daily_rental_rate: float = float(daily_rental_rate)

    # Base rent calculate karne ka method
    def calculate_rent(self, days: int) -> float:
        # Check karna ke din 0 ya negative na hon
        if days <= 0:
            raise ValueError(f"Rental din kam az kam 1 hona chahiye. Aapne diye: {days}")
        return self.daily_rental_rate * days


# Child Class 1: Car (Vehicle se inherit karti hai)
class Car(Vehicle):
    INSURANCE_FEE: float = 1000.0  # Har car rental par Rs. 1,000 fixed insurance

    def calculate_rent(self, days: int) -> float:
        # super() se base calculation reuse ki (daily_rate * days)
        base_rent = super().calculate_rent(days)
        # Car ke liye insurance fee add kar di
        total_rent = base_rent + self.INSURANCE_FEE
        return total_rent


# Child Class 2: Bike (Vehicle se inherit karti hai)
class Bike(Vehicle):
    DISCOUNT_RATE: float = 0.10  # Bike par 10% discount

    def calculate_rent(self, days: int) -> float:
        # super() se base calculation reuse ki
        base_rent = super().calculate_rent(days)
        # 10% discount minus kiya
        discount = base_rent * self.DISCOUNT_RATE
        total_rent = base_rent - discount
        return total_rent


# =============================================================================
# Testing & Demonstration
# =============================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("PILLAR 2 - Q4: VEHICLE RENTAL SYSTEM (INHERITANCE)")
    print("Student: TALHA KHAN | Roll No: 873676")
    print("=" * 70)

    # Car aur Bike ke objects banaye
    car = Car(brand="Honda", model="Civic", daily_rental_rate=4500.0)
    bike = Bike(brand="Suzuki", model="GS 150", daily_rental_rate=1200.0)

    rental_days = 3
    print(f"Testing Calculation for {rental_days} Days:\n")

    # Car ka rent check karna
    car_total = car.calculate_rent(rental_days)
    print(f"Vehicle: {car.brand} {car.model} (Car)")
    print(f"  Daily Rate     : Rs. {car.daily_rental_rate:,.2f}")
    print(f"  Base Rent (x3) : Rs. {car.daily_rental_rate * rental_days:,.2f}")
    print(f"  Insurance Fee  : Rs. {Car.INSURANCE_FEE:,.2f}")
    print(f"  Total Car Rent : Rs. {car_total:,.2f}\n")

    # Bike ka rent check karna (10% discount ke sath)
    bike_total = bike.calculate_rent(rental_days)
    print(f"Vehicle: {bike.brand} {bike.model} (Bike)")
    print(f"  Daily Rate     : Rs. {bike.daily_rental_rate:,.2f}")
    print(f"  Base Rent (x3) : Rs. {bike.daily_rental_rate * rental_days:,.2f}")
    print(f"  10% Discount   : -Rs. {(bike.daily_rental_rate * rental_days * 0.10):,.2f}")
    print(f"  Total Bike Rent: Rs. {bike_total:,.2f}\n")

    # Validation: 0 ya negative din dene par error check karna
    print("--- [Validation Test] Rejection of Zero or Negative Days ---")
    for invalid_d in [0, -2]:
        try:
            car.calculate_rent(invalid_d)
        except ValueError as err:
            print(f"Din {invalid_d} reject ho gaye -> {err}")
