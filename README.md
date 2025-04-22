# MVVM Framework

A Flutter library for implementing the Model-View-ViewModel (MVVM) architectural pattern. <br/>
This framework simplifies state management and promotes a clean separation of concerns in Flutter applications.

## Advantages of Transitioning to MVVM

- **Enforced Separation**<br/> 
The MVVM architecture enforces a strict separation between business logic (ViewModel) and the UI (View).<br/>
This ensures a clean architecture by preventing the mixing of concerns, which can lead to a more organized and scalable codebase.

- **Improved Readability**<br/>
By isolating business logic within the ViewModel, the code becomes more structured, readable, and easier to maintain, simplifying collaboration and future development.

- **Enhanced Testability**<br/>
ViewModels are inherently unit-testable, enabling comprehensive testing of business logic.<br/> Views are simplified, making widget testing more efficient by allowing the mocking and manipulation of model data returned to the View.

- **Centralized State Management**<br/>
A base MVVM class provides a unified approach to handling common states such as loading and error handling, significantly reducing boilerplate code and improving consistency across the application.

Adopting the MVVM architecture results in a more robust, maintainable, and testable codebase, ultimately enhancing the overall development experience and product quality.

## Features

- **MVVM Architecture**<br/>
Provides base classes for Model, View, ViewModel, and the MVVM component.

- **Flutter Bloc**<br/>
Built on top of `flutter_bloc` for state management.<br/>
This framework extends `flutter_bloc`, allowing you to leverage all its features while providing additional capabilities through the MVVM component. This ensures flexibility for scenarios where the MVVM component may not fully address specific requirements.

- **Cross-Platform**<br/>
Compatible with iOS, Android, macOS, Windows, Linux, and Web.

- **Loading Handling**<br/>
Manage loading states globally for the entire application or customize them for specific components.

- **Error Handling**<br/>
Manage error states globally for the entire application or customize them for specific components.

## Usage

Refer to the [Basic Example](example/lib/basic_example.dart) for a quick start guide on how to use this framework.

## Examples

Check the `example` folder for a complete Flutter application demonstrating the usage of this framework. For more information, refer to the [Example README](example/README.md).

## Code Snippets

This library comes with useful VS Code snippets to help you quickly scaffold MVVM components.

### Installation

Copy the [mvvm.code-snippets](https://github.com/Draxent/mvvm_framework/blob/main/.vscode/mvvm.code-snippets) file in the `.vscode` folder of your project.

### Available Snippets

| Trigger       | Snippet Content            |
|---------------|----------------------------|
| `mvvm`        | Create a complete MVVM component |
| `mvvm view`   | Create a MVVM view widget  |
| `mvvm view-model` | Create a MVVM view model |
| `mvvm model`  | Create a MVVM model        |
| `mvvm test`   | Create a MVVM test setup   |

These snippets assume that your application uses the following libraries:

- `freezed` for immutable data classes.
- `injectable` for dependency injection.
- `mockito` for mocking in tests.

Make sure these libraries are included in your project to fully utilize the provided snippets.

## Contributing

Contributions are welcome! Here's how you can contribute:

1. Create an issue to discuss the feature or bug you want to address (e.g. issue #123)
2. Create your feature branch
3. Run `dart format .` before committing the code
4. Commit your changes following the [Conventional Commits](https://www.conventionalcommits.org/) format: `<type>[(optional scope)][!]: <description> #<issue-number>`

   Where `<type>` is one of:
   - **fix**: Patches a bug in the codebase (correlates with PATCH in semantic versioning)
   - **feat**: Introduces a new feature to the codebase (correlates with MINOR in semantic versioning)
   - **docs**: Documentation only changes
   - **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc)
   - **refactor**: A code change that neither fixes a bug nor adds a feature
   - **perf**: A code change that improves performance
   - **test**: Adding missing tests or correcting existing tests
   - **build**: Changes that affect the build system or external dependencies
   - **ci**: Changes to our CI configuration files and scripts
   - **chore**: Other changes that don't modify src or test files

   **Additional format rules:**
   - Breaking changes must be indicated by a `!` before the colon or by including "BREAKING CHANGE:" in the footer
   - The description must be clear and concise
   - The issue number must be included at the end prefixed with #

   **Examples of valid commit messages:**
   ```
   fix: resolve animation stuttering in integrated view #123
   feat: add dark mode support to all widgets #456
   docs: update README with better installation instructions #789
   chore: update dependencies to latest versions #321
   refactor: improve code organization in view_model.dart #654
   test: add unit tests for counter_repository #987
   perf: optimize restaurant listing rendering #246
   style: format code according to analysis_options.yaml #135
   ci: improve GitHub Actions workflow for testing #579
   build: update Flutter SDK requirements #802
   feat!: redesign user interface with breaking changes #432
   ```
5. Push to the branch
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
