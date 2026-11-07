import time
from functools import wraps

def ttl_cache(seconds=60):
    def decorator(func):
        cache = {}
        hits = 0
        misses = 0

        @wraps(func)
        def wrapper(*args, **kwargs):
            nonlocal hits, misses
            sorted_kwargs = tuple(sorted(kwargs.items()))
            key = (args, sorted_kwargs)
            
            now = time.monotonic()
            if key in cache:
                result, timestamp = cache[key]
                if now - timestamp < seconds:
                    hits += 1
                    return result
                else:
                    del cache[key]
            
            misses += 1
            result = func(*args, **kwargs)
            cache[key] = (result, now)
            return result
            
        wrapper.hits = lambda: hits
        wrapper.misses = lambda: misses
        wrapper.clear = lambda: cache.clear()
        return wrapper
    return decorator