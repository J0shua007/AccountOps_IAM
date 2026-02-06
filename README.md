# 🚀 User Management Automation with Bash (CSV-Driven)

A powerful, menu-driven Bash automation tool to manage Linux users like a pro — at scale, safely, and auditable.
Built for SysAdmins, DevOps engineers, and Linux learners who want to stop typing repetitive commands and start managing users the smart way.

This script turns a simple CSV file into a full user-lifecycle management system.

# 🔥 Why This Project?

## Managing users manually is:

❌ Error-prone

❌ Time-consuming

❌ Hard to audit

## This script solves that by:

✅ Automating user operations

✅ Enforcing validation before changes

✅ Logging every action

✅ Supporting dry-run safety checks

# 🧠 What This Script Can Do

## This project provides an interactive CLI menu with 12 powerful operations, all backed by clean Bash functions.

✨ Core Features
📁 CSV-Driven User Creation

Create multiple users from a data.csv file

Assign passwords and groups automatically

Skip existing users safely

## 🔍 Prechecks & Validation

Detect empty passwords

Detect missing group names

Skip CSV headers automatically

Clear warnings with HEAL suggestions

## 👤 User Lifecycle Management

Create users (normal or sudo users)

Delete users (with confirmation)

Lock and unlock user accounts

Change user passwords

## 👥 Group Management

Add users to groups

Remove users from groups

List users in any group

List all sudo users

## 🧪 Dry-Run Mode (Safe Preview)

See exactly what will happen

No system changes applied

Perfect for production sanity checks

## 📝 Centralized Logging

Auto-generated daily logs

## Stored in:

/home/kali/Documents/Project_2/


Every action is timestamped and auditable

# 📊 Menu Overview
1  : Prechecks (CSV validation, empty fields, duplicates)<br>
2  : Create users based on CSV file<br>
3  : Create users with sudo access<br>
4  : Add users to groups<br>
5  : Remove users from groups<br>
6  : Change user passwords<br>
7  : Lock / Unlock users<br>
8  : Delete users<br>
9  : List sudo users<br>
10 : List users by group<br>
11 : Dry-run (show actions without executing)v
12 : Exit<br>

## 📄 CSV File Format

The script reads from data.csv.

username,password,group
john,Pass@123,developers
alice,Secure@456,devops
bob,Test@789,sudo


## 📌 Notes:

First line is treated as a header

Empty password or group triggers warnings

Group must already exist on the system

## 🔐 Security & Best Practices

# Script must be run as root

Home directory permissions set to 700

Passwords set using chpasswd

Confirmation required before destructive actions

## ⚙️ Requirements

Linux system (Tested on Kali / Debian-based systems)

Bash shell

Root privileges

CSV file (data.csv)

## ▶️ How to Run
chmod +x user_management.sh
sudo ./user_management.sh

## 🧩 Ideal Use Cases

👨‍💻 DevOps onboarding automation

🏢 Enterprise user provisioning

🧪 Lab & VM user management

📚 Learning Bash scripting (real-world project!)

🔐 Security-focused account control

🚧 Future Enhancements (Ideas)

Duplicate user detection in CSV

Group auto-creation

Password hashing support

CSV schema validation

Non-interactive (CI/CD) mode

# ❤️ Final Thoughts

This is not just a script —
It’s a mini user-management framework written in pure Bash.

If you’re learning Linux, Bash, or DevOps, this project proves you can build production-grade automation without heavy tools.

Happy scripting 🚀
Automate the boring stuff — securely.
