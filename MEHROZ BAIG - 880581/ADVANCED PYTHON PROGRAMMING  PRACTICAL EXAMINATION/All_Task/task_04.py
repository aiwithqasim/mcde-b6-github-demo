import heapq

def get_execution_order(tasks, dependencies):
    task_set = set(tasks)
    graph = {task: set() for task in task_set}
    in_degree = {task: 0 for task in task_set}
    
    for a, b in dependencies:
        if a not in task_set or b not in task_set:
            raise ValueError(f"Unknown task in dependency pair: ({a}, {b})")
        if b not in graph[a]:
            graph[a].add(b)
            in_degree[b] += 1
            
    queue = [task for task, deg in in_degree.items() if deg == 0]
    heapq.heapify(queue)
    
    order = []
    while queue:
        current = heapq.heappop(queue)
        order.append(current)
        for neighbor in sorted(graph[current]):
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                heapq.heappush(queue, neighbor)
                
    if len(order) != len(task_set):
        raise ValueError("Circular dependency detected in tasks.")
        
    return order