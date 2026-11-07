class Vehicle:

  def __init__(self, brand, model, daily_rental_rate):
    self.brand = brand
    self.model = model
    self.daily_rental_rate = daily_rental_rate

  def calculate_rent(self, days):
    if days <= 0:
      raise ValueError("Rental duration must be greater than zero days.")
    return self.daily_rental_rate * days


class Car(Vehicle):
  INSURANCE_FEE = 1000.0  # Fixed insurance fee per rental

  def calculate_rent(self, days):
    base_rent = super().calculate_rent(days)
    total_cost = base_rent + self.INSURANCE_FEE
    return total_cost


class Bike(Vehicle):
  DISCOUNT_RATE = 0.10  # 10% discount

  def calculate_rent(self, days):
    base_rent = super().calculate_rent(days)
    discounted_amount = base_rent * (1 - self.DISCOUNT_RATE)
    return discounted_amount


# --- Demonstration ---
if __name__ == "__main__":
  print("--- Q4: Vehicle Rental System Demonstration (3-Day Rental) ---")
  rental_days = 3

  car = Car("Toyota", "Corolla", 5000)
  bike = Bike("Yamaha", "R15", 2500)

  print(
      f"Car ({car.brand} {car.model}) Total Rent for {rental_days} days: Rs."
      f" {car.calculate_rent(rental_days):.2f}"
  )
  print(
      f"Bike ({bike.brand} {bike.model}) Total Rent for {rental_days} days: Rs."
      f" {bike.calculate_rent(rental_days):.2f}"
  )

  print("\nTesting validation (Zero days):")
  try:
    car.calculate_rent(0)
  except ValueError as e:
    print(f"Caught expected error: {e}")