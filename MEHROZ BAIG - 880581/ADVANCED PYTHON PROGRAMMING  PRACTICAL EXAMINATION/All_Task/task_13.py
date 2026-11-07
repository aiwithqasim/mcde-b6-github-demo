from datetime import datetime

class BookingScheduler:
    def __init__(self):
        self.bookings = {}

    def add_booking(self, booking_id, room, start: datetime, end: datetime):
        if end <= start:
            raise ValueError("End datetime must be after start datetime")
            
        for r, b_list in self.bookings.items():
            for b in b_list:
                if b['id'] == booking_id:
                    raise ValueError(f"Duplicate booking ID: {booking_id}")
                    
        if room not in self.bookings:
            self.bookings[room] = []
            
        conflicts = [b for b in self.bookings[room] if max(start, b['start']) < min(end, b['end'])]
        if conflicts:
            return {"status": "rejected", "conflicts": conflicts}
            
        new_booking = {"id": booking_id, "room": room, "start": start, "end": end}
        self.bookings[room].append(new_booking)
        self.bookings[room].sort(key=lambda x: x['start'])
        return {"status": "accepted", "booking": new_booking}