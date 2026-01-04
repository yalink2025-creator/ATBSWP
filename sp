import sys
import random
from pathlib import Path

# ------------------ character sets ------------------

upper = list("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
lower = list("abcdefghijklmnopqrstuvwxyz")
number = list("123456789")
symbol = ['!','@','£','$','%','&','*','-','_']

# ------------------ storage file ------------------

savingSP_file = Path("savingSP.py")

# ------------------ creating functions ------------------

def load_accounts():
    accounts = {}
    if savingSP_file.exists():
        for line in savingSP_file.read_text().splitlines():
            if "=" in line:
                name, value = line.split("=", 1)
                accounts[name.strip()] = value.strip()
    return accounts


def write_accounts(accounts):
    with savingSP_file.open("w") as f:
        for name, value in accounts.items():
            f.write(f"{name} = {value}\n")


def generate_password(length=16):
    req_char = [
        random.choice(upper),
        random.choice(lower),
        random.choice(number),
        random.choice(symbol)
    ]
    all_char = upper + lower + number + symbol
    req_char += random.choices(all_char, k=length - 4)
    random.shuffle(req_char)
    return ''.join(req_char)

# ------------------ actions ------------------

def create_password():
    accounts = load_accounts()
    account = input("Enter account name: ").strip()

    if account in accounts:
        print("Account already exists. Use edit instead.")
        return

    password = generate_password()
    accounts[account] = repr(password)
    write_accounts(accounts)

    print(f"Created password for {account}: {password}")


def edit_password():
    accounts = load_accounts()
    account = input("Enter account name to edit: ").strip()

    if account not in accounts:
        print("Account not found.")
        return

    password = generate_password()
    accounts[account] = repr(password)
    write_accounts(accounts)

    print(f"Updated password for {account}: {password}")


def read_password():
    accounts = load_accounts()
    account = input("Enter account name to read: ").strip()

    if account not in accounts:
        print("Account not found.")
        return

    password = eval(accounts[account])  # safe here because file is local
    print(f"{account} password: {password}")

# ------------------ menu loop------------------

def menu():
    print("\n===== PASSWORD MANAGER =====")
    print("1. Create new password")
    print("2. Edit existing password")
    print("3. Read password")
    print("4. Exit")

try:
    while True:
        menu()
        choice = input("Choose an option (1-4): ").strip()

        if choice == "1":
            create_password()
        elif choice == "2":
            edit_password()
        elif choice == "3":
            read_password()
        elif choice == "4":
            print("Goodbye!")
            break
        else:
            print("Invalid choice.")

except KeyboardInterrupt:
    print("\nExiting...")
    sys.exit()
