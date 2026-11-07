class ReversibleRange:
    def __init__(self, start, stop=None, step=1):
        if stop is None:
            start, stop = 0, start
        if step == 0:
            raise ValueError("step cannot be zero")
            
        self.start = start
        self.stop = stop
        self.step = step
        
        if step > 0:
            if start >= stop:
                self._len = 0
            else:
                self._len = (stop - start + step - 1) // step
        else:
            if start <= stop:
                self._len = 0
            else:
                self._len = (start - stop - step - 1) // (-step)

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
            return iter(())
        last = self.start + (self._len - 1) * self.step
        new_stop = self.start - self.step
        return ReversibleRange(last, new_stop, -self.step)

    def __contains__(self, value):
        if self._len == 0:
            return False
        if self.step > 0:
            if not (self.start <= value < self.stop):
                return False
        else:
            if not (self.stop < value <= self.start):
                return False
        return (value - self.start) % self.step == 0


r = ReversibleRange(2, 11, 3)
print(list(r))
print(list(reversed(r)))
print(5 in r)
print(4 in r)