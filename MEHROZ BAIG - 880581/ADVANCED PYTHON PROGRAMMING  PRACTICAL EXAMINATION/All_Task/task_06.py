import uuid

class Account:
    def __init__(self, account_id, initial_balance=0.0):
        if initial_balance < 0:
            raise ValueError("Initial balance cannot be negative")
        self.account_id = account_id
        self._balance = float(initial_balance)
        self.transactions = []
        self._record_transaction("INITIAL", initial_balance, self._balance)

    @property
    def balance(self):
        return self._balance

    def _record_transaction(self, action, amount, resulting_balance):
        tx = {
            "tx_id": str(uuid.uuid4())[:8],
            "action": action,
            "amount": amount,
            "resulting_balance": resulting_balance
        }
        self.transactions.append(tx)

    def deposit(self, amount):
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
        self._balance += amount
        self._record_transaction("DEPOSIT", amount, self._balance)

    def withdraw(self, amount):
        if amount <= 0:
            raise ValueError("Withdrawal amount must be positive")
        if amount > self._balance:
            raise ValueError("Insufficient funds")
        self._balance -= amount
        self._record_transaction("WITHDRAW", amount, self._balance)

class Bank:
    def __init__(self):
        self.accounts = {}

    def create_account(self, account_id, initial_balance=0.0):
        if account_id in self.accounts:
            raise ValueError("Account already exists")
        self.accounts[account_id] = Account(account_id, initial_balance)

    def transfer(self, from_id, to_id, amount):
        if amount <= 0:
            raise ValueError("Transfer amount must be positive")
        if from_id not in self.accounts or to_id not in self.accounts:
            raise ValueError("Nonexistent account")
        
        acc_from = self.accounts[from_id]
        acc_to = self.accounts[to_id]
        
        if acc_from.balance < amount:
            raise ValueError("Insufficient funds for transfer")
            
        acc_from._balance -= amount
        acc_from._record_transaction("TRANSFER_OUT", amount, acc_from._balance)
        
        acc_to._balance += amount
        acc_to._record_transaction("TRANSFER_IN", amount, acc_to._balance)

    def get_statement(self, account_id):
        if account_id not in self.accounts:
            raise ValueError("Nonexistent account")
        return self.accounts[account_id].transactions