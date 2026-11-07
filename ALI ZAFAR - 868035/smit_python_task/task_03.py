def find_paths(data, target):
    result = []
    
    def explore(current, path):
        if type(current) is not bool and current == target:
            result.append(path)
            
        if isinstance(current, dict):
            for key, value in current.items():
                next_path = f"{path}.{key}" if path else key
                explore(value, next_path)
        elif isinstance(current, list):
            for index, item in enumerate(current):
                next_path = f"{path}[{index}]"
                explore(item, next_path)
                
    explore(data, "")
    return result

data = {"a": [{"x": 5}, 5], "b": {"y": 5}}
print(find_paths(data, 5))