from datetime import datetime

class BookingScheduler:
    def __init__(self):
        self.rooms = {}
        self.booking_ids = set()

    def book(self, booking_id, room, start, end):
        if not isinstance(start, datetime) or not isinstance(end, datetime):
            raise TypeError("Start and end must be datetime objects")
        
        if end <= start:
            raise ValueError("End time must be greater than start time")
        
        if booking_id in self.booking_ids:
            raise ValueError(f"Duplicate booking ID: {booking_id}")
        
        if room not in self.rooms:
            self.rooms[room] = []

        conflicts = []
        for existing in self.rooms[room]:
            # Overlap condition: max(start1, start2) < min(end1, end2)
            # This correctly allows adjacent bookings where end == start
            if max(start, existing['start']) < min(end, existing['end']):
                conflicts.append(existing)

        if conflicts:
            return {"status": "rejected", "conflicts": conflicts}

        booking = {
            "id": booking_id,
            "room": room,
            "start": start,
            "end": end
        }
        self.rooms[room].append(booking)
        self.booking_ids.add(booking_id)
        
        # Keep bookings sorted by start time
        self.rooms[room].sort(key=lambda x: x['start'])
        
        return {"status": "accepted", "booking": booking}

# Example usage:
scheduler = BookingScheduler()

t1 = datetime(2026, 11, 7, 9, 0)
t2 = datetime(2026, 11, 7, 10, 0)
t3 = datetime(2026, 11, 7, 11, 0)
t4 = datetime(2026, 11, 7, 9, 30)
t5 = datetime(2026, 11, 7, 10, 30)

print(scheduler.book("b1", "Room A", t1, t2))  # Accepted
print(scheduler.book("b2", "Room A", t2, t3))  # Accepted (Adjacent)
print(scheduler.book("b3", "Room A", t4, t5))  # Rejected (Overlaps)