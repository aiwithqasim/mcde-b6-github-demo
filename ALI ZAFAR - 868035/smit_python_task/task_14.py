import json
import os

class ContactStorage:
    @staticmethod
    def load(filename):
        if not os.path.exists(filename):
            return {}
        try:
            with open(filename, 'r', encoding='utf-8') as f:
                return json.load(f)
        except json.JSONDecodeError:
            print("Warning: Corrupt JSON file detected. Starting with empty container to protect existing data.")
            return {}

    @staticmethod
    def save(filename, contacts):
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(contacts, f, indent=4)


class ContactManager:
    def __init__(self, filename="contacts.json"):
        self.filename = filename
        self.contacts = ContactStorage.load(self.filename)

    def add_contact(self, contact_id, name, phone, email):
        cid = str(contact_id)
        if cid in self.contacts:
            raise ValueError(f"Contact ID {cid} already exists.")
        if not name or not phone or not email:
            raise ValueError("Name, phone, and email cannot be empty.")
        
        self.contacts[cid] = {
            "id": cid,
            "name": name.strip(),
            "phone": phone.strip(),
            "email": email.strip()
        }
        ContactStorage.save(self.filename, self.contacts)

    def search_contact(self, query):
        query = query.lower()
        results = []
        for contact in self.contacts.values():
            if (query in contact["name"].lower() or 
                query in contact["phone"] or 
                query in contact["email"].lower()):
                results.append(contact)
        return results

    def update_contact(self, contact_id, name=None, phone=None, email=None):
        cid = str(contact_id)
        if cid not in self.contacts:
            raise ValueError(f"Contact ID {cid} not found.")
        
        if name:
            self.contacts[cid]["name"] = name.strip()
        if phone:
            self.contacts[cid]["phone"] = phone.strip()
        if email:
            self.contacts[cid]["email"] = email.strip()
            
        ContactStorage.save(self.filename, self.contacts)

    def delete_contact(self, contact_id):
        cid = str(contact_id)
        if cid not in self.contacts:
            raise ValueError(f"Contact ID {cid} not found.")
        del self.contacts[cid]
        ContactStorage.save(self.filename, self.contacts)

    def list_contacts(self):
        return list(self.contacts.values())


# Example usage:
manager = ContactManager("test_contacts.json")

# Add contact
manager.add_contact("1", "Ayesha", "0300-1234567", "ayesha@email.com")

# Search case-insensitively
print("Search Results:", manager.search_contact("aye"))

# List all contacts
print("All Contacts:", manager.list_contacts())