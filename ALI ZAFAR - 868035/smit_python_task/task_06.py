import uuid

class Account:
    def __init__(self, account_id, initial_balance=0.0):
        if initial_balance < 0:
            raise ValueError("Initial balance cannot be negative")
        self._account_id = account_id
        self._balance = float(initial_balance)
        self._ledger = []

    @property
    def account_id(self):
        return self._account_id

    @property
    def balance(self):
        return self._balance

    @property
    def statement(self):
        return tuple(self._ledger)

    def deposit(self, amount):
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
        self._balance += float(amount)
        record = {
            "transaction_id": str(uuid.uuid4()),
            "action": "DEPOSIT",
            "amount": float(amount),
            "resulting_balance": self._balance
        }
        self._ledger.append(record)
        return record["transaction_id"]

    def withdraw(self, amount):
        if amount <= 0:
            raise ValueError("Withdrawal amount must be positive")
        if amount > self._balance:
            raise ValueError("Insufficient funds")
        self._balance -= float(amount)
        record = {
            "transaction_id": str(uuid.uuid4()),
            "action": "WITHDRAWAL",
            "amount": float(amount),
            "resulting_balance": self._balance
        }
        self._ledger.append(record)
        return record["transaction_id"]

    def _apply_transfer_in(self, amount, tx_id):
        self._balance += float(amount)
        record = {
            "transaction_id": tx_id,
            "action": "TRANSFER_IN",
            "amount": float(amount),
            "resulting_balance": self._balance
        }
        self._ledger.append(record)

    def _apply_transfer_out(self, amount, tx_id):
        self._balance -= float(amount)
        record = {
            "transaction_id": tx_id,
            "action": "TRANSFER_OUT",
            "amount": float(amount),
            "resulting_balance": self._balance
        }
        self._ledger.append(record)


class Bank:
    def __init__(self):
        self._accounts = {}

    def create_account(self, account_id, initial_balance=0.0):
        if account_id in self._accounts:
            raise ValueError("Account already exists")
        account = Account(account_id, initial_balance)
        self._accounts[account_id] = account
        return account

    def get_account(self, account_id):
        if account_id not in self._accounts:
            raise ValueError("Account does not exist")
        return self._accounts[account_id]

    def transfer(self, from_id, to_id, amount):
        if amount <= 0:
            raise ValueError("Transfer amount must be positive")
        
        sender = self.get_account(from_id)
        receiver = self.get_account(to_id)

        if sender.balance < amount:
            raise ValueError("Insufficient funds for transfer")

        tx_id = str(uuid.uuid4())
        
        # Atomic execution
        sender._apply_transfer_out(amount, tx_id)
        receiver._apply_transfer_in(amount, tx_id)
        return tx_id

bank = Bank()
acc_a = bank.create_account("A", 1000)
acc_b = bank.create_account("B", 200)

bank.transfer("A", "B", 350)
print(f"A={acc_a.balance}, B={acc_b.balance}")