import re

def evaluate_expression(expr):
    tokens = re.findall(r'\d+(?:\.\d+)?|[+\-*/()]', expr.replace(' ', ''))
    if not tokens:
        raise ValueError("Empty expression")
        
    processed_tokens = []
    prev = None
    for token in tokens:
        if token == '-' and (prev is None or prev in '(+-*/'):
            processed_tokens.extend(['0', '-'])
        else:
            processed_tokens.append(token)
        prev = token
    tokens = processed_tokens

    def precedence(op):
        if op in ('+', '-'): return 1
        if op in ('*', '/'): return 2
        return 0

    def apply_op(op, b, a):
        if op == '+': return a + b
        if op == '-': return a - b
        if op == '*': return a * b
        if op == '/':
            if b == 0:
                raise ZeroDivisionError("Division by zero")
            return a / b
        return 0

    values, ops = [], []
    for token in tokens:
        if token.replace('.', '', 1).isdigit():
            values.append(float(token) if '.' in token else int(token))
        elif token == '(':
            ops.append(token)
        elif token == ')':
            while ops and ops[-1] != '(':
                op = ops.pop()
                b, a = values.pop(), values.pop()
                values.append(apply_op(op, b, a))
            if not ops:
                raise ValueError("Mismatched parentheses")
            ops.pop()
        elif token in '+-*/':
            while ops and precedence(ops[-1]) >= precedence(token):
                op = ops.pop()
                b, a = values.pop(), values.pop()
                values.append(apply_op(op, b, a))
            ops.append(token)
        else:
            raise ValueError(f"Invalid token: {token}")
            
    while ops:
        op = ops.pop()
        if op == '(':
            raise ValueError("Mismatched parentheses")
        b, a = values.pop(), values.pop()
        values.append(apply_op(op, b, a))
        
    if len(values) != 1:
        raise ValueError("Malformed expression")
    return values[0]