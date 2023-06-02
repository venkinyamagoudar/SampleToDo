# SampleTodo

SampleTodo is a simple to-do list application developed using Swift, UIKit, and Xcode. It allows users to create and manage their tasks. The project follows the MVVM (Model-View-ViewModel) design pattern for a clean and maintainable architecture. CoreData is used for data persistence.

## Features

- Create new tasks with title and optional description.
- Mark tasks as completed.
- Edit existing tasks.
- Delete tasks.
- Persist tasks using CoreData.
- Follows the MVVM design pattern for a structured and scalable architecture.

## Screenshots
![Todo](https://github.com/venkinyamagoudar/SampleToDo/assets/109290394/9e6237dc-0b41-43a1-8a12-50ef021c2ebe)

## Requirements

- iOS 14.0+ 📱
- Xcode 14.0+ 🛠️
- Swift 5.0+

## Installation

1. Clone or download the SampleTodo repository to your local machine.

2. Open the project in Xcode.

3. Build and run the project on the iOS Simulator or a physical device.

## Usage

1. Launch the SampleTodo application on your iOS device or simulator.

2. The main screen displays a list of existing tasks, if any.

3. To create a new task, tap on the "+" button.

4. Enter a title and, optionally, a description for the task in the provided fields.

5. To mark a task as completed, tap the checkbox next to the task.

6. To edit an existing task, tap on the task in the list.

7. To delete a task, swipe left on the task in the list and tap the "Delete" button.

8. All tasks are automatically saved and persisted using CoreData.

## Architecture

The SampleTodo application follows the MVVM (Model-View-ViewModel) design pattern for a structured and scalable architecture. Here's a brief overview of each component:

- **Model**: Contains the data structures and logic for tasks, including the title, description, and completion status.
- **View**: Handles the user interface and displays the tasks to the user. Provides input fields for creating and editing tasks.
- **ViewModel**: Acts as a mediator between the Model and View, providing data and methods for manipulating tasks. Handles CoreData interactions for data persistence.

## Contributing

Contributions to the SampleTodo application are welcome! If you would like to contribute, please follow these guidelines:

1. Fork the repository and clone it to your local machine.

2. Create a new branch for your feature or bug fix.

3. Implement your changes, following the existing code style and architecture.

4. Write appropriate tests for your code changes.

5. Commit your changes and push them to your forked repository.

6. Open a pull request, providing a detailed description of your changes and any relevant information.
