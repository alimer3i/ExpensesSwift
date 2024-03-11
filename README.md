# Expenses App README

Expenses is a Swift application built using UIKit framework, designed to manage your expenses effectively. It allows users to maintain a list of expenses, categorize them as either expenses or income, add tags, and conveniently filter results. The application follows the MVVM architectural pattern with a coordinator and adheres to the principles of CLEAN architecture, utilizing use cases for business logic.

## Features

- **Expense Management**: Keep track of your expenses and income conveniently.
- **Categorization**: Categorize your transactions as expenses or income.
- **Tagging**: Add tags to your transactions for better organization and analysis.
- **Filtering**: Easily filter expenses based on specific criteria to gain insights into your spending habits.
- **Light and Dark Mode**: Supports both light and dark mode for comfortable usage in different environments.

## Architecture

Expenses app follows the MVVM architectural pattern with a coordinator and adheres to CLEAN architecture principles. Here's a brief overview:

- **Model**: Represents the data model used within the application.
- **View**: Represents the user interface components responsible for displaying data and interacting with the user.
- **ViewModel**: Acts as an intermediary between the View and Model, handling the presentation logic and data manipulation.
- **Coordinator**: Coordinates navigation flow within the application.
- **Use Cases**: Contains business logic components, ensuring separation of concerns and promoting testability.
