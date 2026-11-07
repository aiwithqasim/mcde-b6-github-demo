from collections import defaultdict

def read_errors(path, malformed_stats=None):
    if malformed_stats is None:
        malformed_stats = {'count': 0}
        
    with open(path, 'r', encoding='utf-8') as f:
        for line_no, line in enumerate(f, start=1):
            line = line.strip()
            if not line:
                continue
            parts = line.split(" | ", 2)
            if len(parts) != 3:
                malformed_stats['count'] += 1
                continue
            
            timestamp, level, message = parts
            if level.upper() == "ERROR":
                yield (line_no, timestamp, message)

def summarize_errors(path):
    malformed = {'count': 0}
    summary = defaultdict(int)
    
    for line_no, timestamp, message in read_errors(path, malformed):
        date = timestamp.split(" ")[0]
        summary[date] += 1
        
    return dict(summary), malformed['count']