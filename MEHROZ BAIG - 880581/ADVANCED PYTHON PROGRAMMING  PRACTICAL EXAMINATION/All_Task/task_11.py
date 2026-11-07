import csv

def process_gradebook(students_path, scores_path, report_path):
    students = {}
    with open(students_path, mode='r', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            students[row['student_id']] = row['name']
            
    student_scores = {s_id: {} for s_id in students}
    seen_entries = set()
    
    with open(scores_path, mode='r', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            s_id, subject = row['student_id'], row['subject']
            try:
                marks = float(row['marks'])
            except ValueError:
                continue
                
            if s_id not in students or not (0 <= marks <= 100):
                continue
            if (s_id, subject) in seen_entries:
                continue
            seen_entries.add((s_id, subject))
            student_scores[s_id][subject] = marks
            
    def get_grade(avg):
        if avg >= 85: return 'A'
        elif avg >= 70: return 'B'
        elif avg >= 55: return 'C'
        elif avg >= 40: return 'D'
        return 'F'
        
    report_data = []
    for s_id, name in students.items():
        marks_list = list(student_scores[s_id].values())
        avg = sum(marks_list) / len(marks_list) if marks_list else 0.0
        report_data.append({
            'student_id': s_id, 'name': name,
            'average': round(avg, 2), 'grade': get_grade(avg)
        })
        
    report_data.sort(key=lambda x: (-x['average'], x['student_id']))
    
    with open(report_path, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['rank', 'student_id', 'name', 'average', 'grade'])
        writer.writeheader()
        for rank, row in enumerate(report_data, start=1):
            writer.writerow({'rank': rank, **row})