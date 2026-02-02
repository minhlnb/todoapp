# 🛠 Installation & Setup

Follow these steps to get the project up and running on your local machine.

## Prerequisites
* **Mac** running macOS Ventura or later.
* **Xcode 14.0** or later (Required for SwiftUI `NavigationStack` support).
* **iOS 16.0+** deployment target.

## Steps to Run
1.  **Clone the repository**
    Open Terminal and run:
    ```bash
    git clone https://github.com/minhlnb/todoapp.git
    ```

2.  **Open the Project**
    * Navigate to the project folder.
    * Open the `.xcodeproj` file with Xcode.

3.  **Build and Run**
    * Select a Simulator (e.g., iPhone 15) from the top toolbar.
    * Press **Cmd + R** (or the Play button) to build and run the app.

---


# SwiftUI Todo App - Technical Documentation

## 1. SwiftUI Views

The application leverages **SwiftUI** to create a declarative user interface.

* **Components:** Uses `NavigationStack` for navigation, `List` and `ForEach` for dynamic items, and `TextField`/`Button` for inputs.
* **Main Screen:** Displays the current day, statistics, a search bar, and the list of todo items. It includes a floating action button (plus icon) in the navigation bar to transition to the **Add Todo** screen.

### User Interactions
Interactions are handled declaratively through SwiftUI views and state bindings:

* **Adding a Todo:**
    * User enters text in a `TextField`.
    * Input is bound to a local state using `@State`.
    * Tapping the **Add** button passes the new todo to the ViewModel.
* **Marking as Completed:**
    * Each row features a tap gesture.
    * Tapping updates the completion state in the ViewModel.
    * The UI updates automatically to reflect the change.
* **Deleting a Todo:**
    * Supports swipe-to-delete functionality.
    * SwiftUI’s built-in delete action triggers a ViewModel method to remove the item from the data source.

---

## 2. State Management

The app utilizes SwiftUI’s reactive state system to ensure the UI stays synchronized with the data.

### UI Updates
1.  The main data source is stored in the **ViewModel** as a property marked with `@Published`.
2.  **Action:** When a user adds, completes, or deletes an item, the ViewModel updates the underlying data.
3.  **Reaction:** The `@Published` property emits a change.
4.  **Render:** SwiftUI detects the change and automatically re-renders the affected views.

### Data Consistency
Data consistency is maintained by **centralizing all mutations** inside the ViewModel:
* Views **never** modify the todo list directly.
* All Create, Update, and Delete (CRUD) operations are handled exclusively by ViewModel methods.
* This establishes a **Single Source of Truth** for the application.

---

## 3. Persistence

The application uses **UserDefaults** combined with the **Codable** protocol for data storage.

* **Save Mechanism:** Uses a `didSet` property observer on the todos array. whenever a task is modified, the data is immediately encoded into JSON and saved.
* **Load Mechanism:** Data is decoded and loaded into the array within the `init()` function of the Repository/ViewModel at launch.

### Why UserDefaults?
* **Suitability:** Ideal for small, simple list data structures.
* **Performance:** Fast access speed and simple implementation.
* **Efficiency:** Less resource-intensive than CoreData or SQLite for the scope of a simple Todo application.

---

## 4. Architecture & Code Quality

The project follows the **MVVM (Model–View–ViewModel)** architecture to separate concerns effectively.

### 🏗 Models
* Defines data structures (e.g., `Todo` model).
* Contains only plain data conforming to `Identifiable` and `Codable`.
* **No** business logic or UI code.

### 📱 Views
* Contains all SwiftUI views (`TodoListView`, `AddTodoView`, subviews).
* Responsible strictly for displaying data.
* Forwards user intents (add, delete, toggle) to the ViewModel.
* **No** calculations or data manipulation.

### 🧠 ViewModels
* Contains the application logic (managing the list, filtering, counting stats).
* Exposes **observable state** for views to react to.

### 💾 Repositories
* Responsible for data persistence and retrieval.
* Abstracts the storage mechanism (`UserDefaults`) from the rest of the application.
