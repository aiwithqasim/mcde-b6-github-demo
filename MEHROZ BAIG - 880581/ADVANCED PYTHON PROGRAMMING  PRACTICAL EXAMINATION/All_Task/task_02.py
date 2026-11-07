def longest_unique_window(text):
    if not text:
        return ("", 0, 0)
    
    char_map = {}
    max_len = 0
    start_idx = 0
    best_start = 0
    
    for i, char in enumerate(text):
        if char in char_map and char_map[char] >= start_idx:
            start_idx = char_map[char] + 1
        char_map[char] = i
        current_len = i - start_idx + 1
        if current_len > max_len:
            max_len = current_len
            best_start = start_idx
            
    return (text[best_start:best_start + max_len], best_start, max_len)