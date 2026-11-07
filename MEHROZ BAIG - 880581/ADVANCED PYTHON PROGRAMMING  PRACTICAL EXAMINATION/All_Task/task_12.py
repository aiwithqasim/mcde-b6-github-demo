import math

class ReversibleRange:
    def __init__(self, start, stop=None, step=1):
        if stop is None:
            self.start, self.stop, self.step = 0, start, 1
        else:
            self.start, self.stop, self.step = start, stop, step
            
        if self.step == 0:
            raise ValueError("step cannot be zero")
            
        if (self.step > 0 and self.start >= self.stop) or (self.step < 0 and self.start <= self.stop):
            self._len = 0
        else:
            self._len = math.ceil((self.stop - self.start) / self.step)

    def __len__(self):
        return self._len

    def __iter__(self):
        current = self.start
        if self.step > 0:
            while current < self.stop:
                yield current
                current += self.step
        else:
            while current > self.stop:
                yield current
                current += self.step

    def __reversed__(self):
        if self._len == 0:
            return iter([])
        last_val = self.start + (self._len - 1) * self.step
        return ReversibleRange(last_val, self.start - self.step, -self.step)

    def __contains__(self, item):
        if self._len == 0 or not isinstance(item, (int, float)):
            return False
        if (item - self.start) % self.step != 0:
            return False
        return (self.start <= item < self.stop) if self.step > 0 else (self.stop < item <= self.start)