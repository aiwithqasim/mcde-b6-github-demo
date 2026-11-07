import csv

def generate_gradebook(students_path, scores_path, report_path):
    students = {}
    with open(students_path, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            s_id = row['student_id'].strip()
            students[s_id] = {
                'name': row['name'].strip(),
                'subjects': {}
            }

    with open(scores_path, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            s_id = row.get('student_id', '').strip()
            subject = row.get('subject', '').strip()
            
            if s_id not in students:
                continue
            
            try:
                marks = float(row.get('marks', -1))
            except (ValueError, TypeError):
                continue
            
            if not (0 <= marks <= 100):
                continue
            
            if subject in students[s_id]['subjects']:
                continue
            
            students[s_id]['subjects'][subject] = marks

    report_data = []
    for s_id, data in students.items():
        marks_list = list(data['subjects'].values())
        avg = (sum(marks_list) / len(marks_list)) if marks_list else 0.0
        
        if avg >= 85:
            grade = 'A'
        elif avg >= 70:
            grade = 'B'
        elif avg >= 55:
            grade = 'C'
        elif avg >= 40:
            grade = 'D'
        else:
            grade = 'F'
            
        report_data.append({
            'student_id': s_id,
            'name': data['name'],
            'average': round(avg, 2),
            'grade': grade
        })

    report_data.sort(key=lambda x: (-x['average'], x['student_id']))

    for rank, item in enumerate(report_data, start=1):
        item['rank'] = rank

    with open(report_path, mode='w', newline='', encoding='utf-8') as f:
        fieldnames = ['student_id', 'name', 'average', 'grade', 'rank']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in report_data:
            writer.writerow(row)