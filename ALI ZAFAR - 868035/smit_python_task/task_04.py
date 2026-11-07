import heapq

def schedule_tasks(tasks, dependencies):
    task_set = set(tasks)
    adj = {task: [] for task in tasks}
    in_degree = {task: 0 for task in tasks}
    
    for u, v in dependencies:
        if u not in task_set or v not in task_set:
            raise ValueError("Unknown task name in dependencies")
        adj[u].append(v)
        in_degree[v] += 1
        
    heap = [task for task in tasks if in_degree[task] == 0]
    heapq.heapify(heap)
    
    order = []
    while heap:
        current = heapq.heappop(heap)
        order.append(current)
        for neighbor in adj[current]:
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                heapq.heappush(heap, neighbor)
                
    if len(order) != len(tasks):
        raise ValueError("Cycle detected in task dependencies")
        
    return order

tasks = ["build", "test", "deploy"]
dependencies = [("build", "test"), ("test", "deploy")]
print(schedule_tasks(tasks, dependencies))