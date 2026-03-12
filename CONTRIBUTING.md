# Contributing Guidelines

Welcome to the project! This document outlines the standards and processes for contributing to the Robot Framework Test Automation Template.

## 🏗 Architectural Standards

### 3-Layer Logic Separation
We follow a strict separation between **Tests**, **Keywords**, and **Pages**:

1.  **Tests Layer (`tests/`)**:
    - Orchestrates business scenarios.
    - No low-level technical calls.

2.  **Keywords Layer**: 
    - **Core (`resources/keywords/core/`)**: Agnostic infra (DB, Browser, Strings). Grouped by domain/utility.
    - **App (`resources/keywords/app/<Feature>/`)**: Domain specific logic. Grouped by feature folder.
  
3.  **Pages Layer (`resources/keywords/app/<Feature>/`)**:
    - Low-level technical interactions.
    - Stays alongside keywords in the feature folder to facilitate development.

## ✍️ Coding Standards

### Keyword Naming
- Use clear, descriptive names.
- Use **Title Case** for keyword names: `Open Application Login Page`.
- Avoid abbreviations unless they are project standard.
- Prefer explicit arguments instead of global variables when possible.

### Variables
- Use uppercase for global/suite variables: `${GLOBAL_VAR}`.
- Use lowercase for local/test variables: `${local_var}`.
- Use prefixes for dictionary/list access: `${user}[name]`.

### Documentation
Every `.resource` file and custom `keyword` must have a `[Documentation]` segment:
```robotframework
*** Keywords ***
My Awesome Keyword
    [Arguments]    ${arg1}
    [Documentation]    Describes what the keyword does and lists arguments/returns.
    ...    Arguments:
    ...    - arg1: Description of argument 1
    ...    Returns:
    ...    - Result description
    Log    ${arg1}
```

## 🛠 Workflow

1.  **Dependencies**: Always update `requirements.txt` if you add a new library.
2.  **Linting**: Run `robocop` before submitting code. Address all `High` and `Medium` severity issues.
3.  **Dry Run**: Ensure your changes don't break the suite structure:
    ```bash
    ./.venv/bin/robot --dryrun tests/
    ```
4.  **Pull Requests**:
    - Use descriptive titles.
    - Link to any relevant issue.
    - Include a summary of changes and verification steps.

## 🤝 Need Help?
Contact the project maintainers or check the `README.md` for contact details.
