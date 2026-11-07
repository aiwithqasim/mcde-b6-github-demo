def longest_unique_window(text):
    # Edge case: agar string khali ho
    if not text:
        return ("", 0, 0)
    
    char_index_map = {}  # Characters ke last seen index store karne ke liye
    start = 0            # Window ka starting index
    max_len = 0          # Maximum length tracker
    best_start = 0       # Best window ka start index store karne ke liye
    
    for end in range(len(text)):
        char = text[end]
        
        # Agar character pehle aa chuka hai aur wo current window ke andar hai
        if char in char_index_map and char_index_map[char] >= start:
            start = char_index_map[char] + 1
            
        # Current character ka latest index update karein
        char_index_map[char] = end
        
        # Current window ki length nikalain
        current_len = end - start + 1
        
        # Strictly greater (>) use kiya hai taake equal length par pehli wali (earliest) window hi rahe
        if current_len > max_len:
            max_len = current_len
            best_start = start
            
    # Substring extract karein
    substring = text[best_start : best_start + max_len]
    return (substring, best_start, max_len)

# --- Test Cases ---
print(longest_unique_window("abcabcbb"))  # Output: ('abc', 0, 3)
print(longest_unique_window(""))          # Output: ('', 0, 0)
print(longest_unique_window("pwwkew"))    # Output: ('wke', 2, 3)