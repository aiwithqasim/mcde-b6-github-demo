def evaluate(expression):
    def tokenize(expr):
        tokens = []
        i = 0
        n = len(expr)
        while i < n:
            char = expr[i]
            if char.isspace():
                i += 1
            elif char in "+-*/()":
                tokens.append(char)
                i += 1
            elif char.isdigit():
                num = 0
                while i < n and expr[i].isdigit():
                    num = num * 10 + int(expr[i])
                    i += 1
                tokens.append(str(num))
            else:
                raise ValueError(f"Invalid character: {char}")
        return tokens

    tokens = tokenize(expression)
    
    processed_tokens = []
    expect_operand = True
    for t in tokens:
        if t in "+-*/":
            if t == '-' and expect_operand:
                processed_tokens.extend(['0', '-'])
            else:
                processed_tokens.append(t)
            expect_operand = True
        elif t == '(':
            processed_tokens.append(t)
            expect_operand = True
        elif t == ')':
            processed_tokens.append(t)
            expect_operand = False
        else:
            processed_tokens.append(t)
            expect_operand = False

    precedence = {'+': 1, '-': 1, '*': 2, '/': 2}
    output = []
    stack = []
    
    for token in processed_tokens:
        if token.isdigit():
            output.append(token)
        elif token in precedence:
            while stack and stack[-1] in precedence and precedence[stack[-1]] >= precedence[token]:
                output.append(stack.pop())
            stack.append(token)
        elif token == '(':
            stack.append(token)
        elif token == ')':
            while stack and stack[-1] != '(':
                output.append(stack.pop())
            if not stack:
                raise ValueError("Mismatched parentheses")
            stack.pop()
            
    while stack:
        if stack[-1] == '(':
            raise ValueError("Mismatched parentheses")
        output.append(stack.pop())

    eval_stack = []
    for token in output:
        if token.isdigit():
            eval_stack.append(float(token))
        else:
            if len(eval_stack) < 2:
                raise ValueError("Malformed expression")
            b = eval_stack.pop()
            a = eval_stack.pop()
            if token == '+':
                eval_stack.append(a + b)
            elif token == '-':
                eval_stack.append(a - b)
            elif token == '*':
                eval_stack.append(a * b)
            elif token == '/':
                if b == 0:
                    raise ZeroDivisionError("Division by zero")
                eval_stack.append(a / b)
                
    if len(eval_stack) != 1:
        raise ValueError("Malformed expression")
    return eval_stack[0]

expression = "-(3 + 2) * 4 + 18 / 3"
print(evaluate(expression))