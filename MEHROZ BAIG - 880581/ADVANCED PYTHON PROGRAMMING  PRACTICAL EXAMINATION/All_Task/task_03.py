def find_paths(data, target):
    results = []
    
    def _recurse(current, path):
        if type(current) is not bool and current == target:
            results.append(path)
            
        if isinstance(current, dict):
            for k, v in current.items():
                new_path = f"{path}.{k}" if path else k
                _recurse(v, new_path)
        elif isinstance(current, list):
            for idx, item in enumerate(current):
                new_path = f"{path}[{idx}]"
                _recurse(item, new_path)
                
    _recurse(data, "")
    return results