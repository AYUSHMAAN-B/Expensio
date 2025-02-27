# 📌 EXPENSE TRACKER APP TO-DO LIST

✅ **Symbols:**

- [✔] Completed
- [-] Ongoing
- [x] Not working properly
- [ ] Not yet started

---

## ✔ **NOW WORKING ON**

- [✔] Creating models for UserProfile, Expense and Post.
- [✔] Creating screens and bottom navigation bar.
- [ ] Creating UI components for all screens.
  - [✔] Creating UI components for Daily Expenses.
  - [✔] Creating UI components for Monthly Expenses.
  - [✔] Creating UI components for Yearly Expenses.
  - [✔] Creating UI components for Pots Screen.
  - [-] Creating UI components for Stats Screen.
  - [✔] Creating UI components for Profile Screen.
- [✔] Writing Firestore functions for the database.

---

## ✔ **Step 1: Plan & Define Features**

- [✔] User authentication (Login, Signup)
- [✔] Expense tracking (Add, Edit, Delete expenses)
- [✔] Categorization of expenses
- [✔] Savings pots for big purchases
- [ ] Budgeting & spending insights
- [ ] Recurring transactions automation
- [-] Export expenses as CSV/PDF
- [✔] Cloud backup for expenses

---

## [-] **Step 2: Design Database Schema (Firestore)**

- [✔] Define collections and documents
- [ ] Implement Firestore structure in the app
  - [✔] `users` collection (stores user details)
  - [✔] `expenses` collection (stores expenses per user)
  - [✔] `categories` collection (stores expense categories)
  - [✔] `pots` collection (tracks user savings goals)
  - [ ] `budgets` collection (tracks monthly budgets)
  - [ ] `recurringTransactions` collection (stores recurring payments)
  - [ ] `notifications` collection (stores reminders & alerts)

---

## [ ] **Step 3: UI/UX Design**

### [ ] Design authentication screens

- [-] Login Screen
- [-] Signup Screen
- [-] Forgot Password Screen

### [ ] Design main dashboard

- [✔] Expense overview section
- [ ] Budget tracking section
- [✔] Savings pots progress section

### [ ] Design expense management screens

- [✔] Add new expense
- [✔] Edit/Delete existing expenses
- [✔] Filter expenses by category, date, and payment method

### [ ] Design budget tracking UI

- [✔] Monthly budget overview
- [✔] Category-wise budget breakdown
- [ ] Alerts for overspending

### [ ] Design savings pots UI

- [✔] Create a new savings pot
- [✔] Track savings goal progress
- [✔] Add money to a savings pot

### [ ] Implement notifications UI

- [ ] Show transaction reminders
- [ ] Show goal progress alerts

---

## [ ] **Step 4: Backend Development (Firestore & Authentication)**

### [ ] Implement User Authentication

- [✔] Sign up users with email/password
- [✔] Login users securely
- [✔] Logout functionality
- [-] Reset password feature

### [ ] Implement Firestore Functions

#### **User Management**

- [✔] Store user data in Firestore (`users/{userId}`)
- [-] Update user profile details
- [-] Fetch user settings from Firestore

#### **Expense Management**

- [✔] Add a new expense (`users/{userId}/expenses/{expenseId}`)
- [✔] Edit an existing expense
- [✔] Delete an expense
- [✔] Fetch expenses by date range
- [✔] Filter expenses by category
- [✔] Get total spending for a given period

#### **Category Management**

- [✔] Create custom categories (`users/{userId}/categories/{categoryId}`)
- [✔] Fetch all categories for a user
- [✔] Edit/Delete a category

#### **Budget Management**

- [ ] Set a monthly budget (`users/{userId}/budgets/{budgetId}`)
- [ ] Track budget usage
- [ ] Alert user when budget is exceeded

#### **Savings Pots**

- [✔] Create a new savings pot (`users/{userId}/savingsPots/{potId}`)
- [✔] Update savings progress
- [✔] Delete a savings pot

#### **Recurring Transactions**

- [ ] Store recurring payments (`users/{userId}/recurringTransactions/{recurringId}`)
- [ ] Auto-generate expenses based on recurring payments
- [ ] Notify users of upcoming recurring payments

#### **Export & Backup**

- [-] Export expense data as CSV
- [-] Export expense data as PDF
- [ ] Implement cloud backup (Firestore rules & security)

---

## [ ] **Step 5: Testing & Debugging**

- [ ] Unit test Firestore functions
- [ ] Test authentication & security rules
- [ ] Check database read/write performance
- [ ] Ensure UI responsiveness across devices
- [ ] Validate all user inputs (prevent incorrect data)
- [ ] Handle edge cases in expense tracking
- [ ] Test budget tracking logic for different spending cases
- [ ] Test notifications for reminders & alerts

---

## [ ] **Step 6: Deployment & Optimization**

- [ ] Optimize Firestore queries for efficiency
- [ ] Set up Firestore security rules
- [ ] Prepare Play Store listing (Android)
- [ ] Release the app & gather user feedback

---

## [ ] **Step 7: Future Enhancements**

- [ ] Multi-currency support
- [ ] Dark mode & themes

---
