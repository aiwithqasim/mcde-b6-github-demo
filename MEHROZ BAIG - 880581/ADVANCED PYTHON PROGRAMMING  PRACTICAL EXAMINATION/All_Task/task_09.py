import re

def read_errors(path):
    pattern = re.compile(r'^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) \| (ERROR) \| (.*)$')
    malformed_count = 0
    
    with open(path, 'r', encoding='utf-8') as f:
        for line_num, line in enumerate(f, start=1):
            line = line.strip()
            if not line:
                continue
            match = pattern.match(line)
            if match:
                timestamp, level, message = match.groups()
                yield (line_num, timestamp, message)
            else:
                malformed_count += 1
                
    read_errors.malformed_count = malformed_count

def summarize_errors(path):
    error_counts = {}
    for _, timestamp, _ in read_errors(path):
        date = timestamp.split(' ')[0]
        error_counts[date] = error_counts.get(date, 0) + 1
    return error_counts