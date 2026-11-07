# Q4. Vehicle Rental System (Inheritance - Intermediate)


class Vehicle:
    def __init__(self, brand, model, daily_rate):
        self.brand = brand
        self.model = model
        self.daily_rate = daily_rate

    def calculate_rent(self, days):
        if days <= 0:
            raise ValueError(f"Rental duration must be positive (got {days} days).")
        return self.daily_rate * days


class Car(Vehicle):
    INSURANCE_FEE = 1000  # fixed fee per rental

    def calculate_rent(self, days):
        base = super().calculate_rent(days)   # reuse parent implementation
        return base + self.INSURANCE_FEE


class Bike(Vehicle):
    DISCOUNT = 0.10  # 10% discount on base rental

    def calculate_rent(self, days):
        base = super().calculate_rent(days)   # reuse parent implementation
        return base * (1 - self.DISCOUNT)


if __name__ == "__main__":
    car = Car("Toyota", "Corolla", 5000)
    bike = Bike("Honda", "CG 125", 2000)
    days = 3

    print(f"=== {days}-day rental ===")
    print(f"  {car.brand} {car.model}: base Rs. {car.daily_rate}/day "
          f"+ insurance Rs. {Car.INSURANCE_FEE} = Rs. {car.calculate_rent(days)}")
    print(f"  {bike.brand} {bike.model}: base Rs. {bike.daily_rate}/day "
          f"- {int(Bike.DISCOUNT * 100)}% discount = Rs. {bike.calculate_rent(days)}")

    print("\n=== Rejected: zero or fewer days ===")
    for vehicle in (car, bike):
        for bad_days in (0, -2):
            try:
                vehicle.calculate_rent(bad_days)
            except ValueError as e:
                print(f"  {vehicle.brand} ({bad_days} days) -> ValueError: {e}")

    print("\n=== Inheritance check ===")
    print(f"  isinstance(car, Vehicle) -> {isinstance(car, Vehicle)}")
    print(f"  isinstance(bike, Vehicle) -> {isinstance(bike, Vehicle)}")
