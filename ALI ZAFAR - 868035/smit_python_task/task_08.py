import functools
import time

def ttl_cache(seconds=60):
    def decorator(func):
        cache = {}
        hits = 0
        misses = 0

        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            nonlocal hits, misses
            
            try:
                kwargs_key = frozenset(kwargs.items())
                key = (args, kwargs_key)
            except TypeError:
                return func(*args, **kwargs)

            now = time.monotonic()
            
            if key in cache:
                result, expiry = cache[key]
                if now < expiry:
                    hits += 1
                    return result
                else:
                    del cache[key]
            
            misses += 1
            result = func(*args, **kwargs)
            cache[key] = (result, now + seconds)
            return result

        wrapper.cache_hits = lambda: hits
        wrapper.cache_misses = lambda: misses
        wrapper.cache_clear = cache.clear
        return wrapper
    return decorator

@ttl_cache(seconds=5)
def compute(x, y):
    return x * y

print(compute(x=2, y=3))
print(compute(y=3, x=2))
print("Hits:", compute.cache_hits())
print("Misses:", compute.cache_misses())