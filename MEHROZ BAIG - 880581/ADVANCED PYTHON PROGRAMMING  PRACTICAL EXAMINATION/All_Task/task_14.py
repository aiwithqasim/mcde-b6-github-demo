import json
import os

class ContactManager:
    def __init__(self, storage_path="contacts.json"):
        self.storage_path = storage_path
        self.contacts = self._load_contacts()

    def _load_contacts(self):
        if not os.path.exists(self.storage_path):
            return {}
        try:
            with open(self.storage_path, 'r', encoding='utf-8') as f:
                content = f.read().strip()
                return json.loads(content) if content else {}
        except (json.JSONDecodeError, IOError):
            backup_path = self.storage_path + ".bak"
            if os.path.exists(self.storage_path):
                os.replace(self.storage_path, backup_path)
            return {}

    def save_contacts(self):
        with open(self.storage_path, 'w', encoding='utf-8') as f:
            json.dump(self.contacts, f, indent=4)

    def add_contact(self, contact_id, name, phone, email):
        if contact_id in self.contacts:
            raise ValueError("Contact ID already exists")
        self.contacts[contact_id] = {"name": name, "phone": phone, "email": email}
        self.save_contacts()

    def search_contacts(self, query):
        q = query.lower()
        return {cid: d for cid, d in self.contacts.items() 
                if q in d['name'].lower() or q in d['phone'] or q in d['email'].lower()}

    def update_contact(self, contact_id, name=None, phone=None, email=None):
        if contact_id not in self.contacts:
            raise ValueError("Contact not found")
        if name: self.contacts[contact_id]['name'] = name
        if phone: self.contacts[contact_id]['phone'] = phone
        if email: self.contacts[contact_id]['email'] = email
        self.save_contacts()

    def delete_contact(self, contact_id):
        if contact_id not in self.contacts:
            raise ValueError("Contact not found")
        del self.contacts[contact_id]
        self.save_contacts()