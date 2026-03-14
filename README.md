# Robot Framework Test Automation Template

## 🚀 Project Overview

This comprehensive test automation framework leverages Robot Framework to streamline end-to-end testing across multiple environments, providing a robust and flexible testing solution. It follows a **Layered Architecture** (Core vs. App) to maximize reusability and maintainability.

## 📁 Project Structure

```text
├── resources/
│   ├── core/           # Infrastructure Keywords (Agnostic, by Domain)
│   ├── keywords/
│   │   ├── core/       # Infrastructure & Utility Keywords (Agnostic)
│   │   └── app/        # Feature-Based Organization (Locality)
│   │       └── Book_Store/
│   │           ├── bookStore.keywords.resource  (2nd Layer: Flows)
│   │           └── bookStore.pages.resource     (3rd Layer: Technical)
│   ├── libraries/      # Custom Python Libraries
│   └── files/          # Test data, JSON schemas
├── tests/              # 1st Layer: Test Suites (Intent)
├── tools/                  # Automation utility scripts (Install, Docs, DB Init)
├── config_variables.py     # Global framework configuration
└── dev.env, uat.env...     # Environment-specific variables
```

## 📋 Prerequisites

### System Requirements
- [Python™](https://www.python.org/downloads/) (3.10+)
- [uv](https://github.com/astral-sh/uv) (Highly recommended)
- [Node.js®](https://nodejs.org/en/download/) (18+)

## 📦 Package Management with uv

This project uses [uv](https://github.com/astral-sh/uv) for managing dependencies and virtual environments. **uv** is an extremely fast substitute for `pip` and `pip-tools`, written in Rust.

### Why uv?
- **Speed**: Up to 100x faster than `pip`.
- **Reliability**: Manages `pyproject.toml` and generates a deterministic `uv.lock` file.
- **Simplicity**: Manages Python versions, virtual environments, and dependencies in a single binary.
- **Efficiency**: Uses *hard links* to avoid package duplication on disk.

### Essential Commands
| Command | Description |
| :--- | :--- |
| `uv sync` | Installs all dependencies and creates the `.venv` automatically. |
| `uv add <package>` | Adds a new library to the project. |
| `uv remove <package>` | Removes a library from the project. |
| `uv run <command>` | Executes a command (e.g., `robot`) inside the virtual environment. |
| `uv lock` | Updates the `uv.lock` file without installing anything. |

## 🛠 Setup and Installation

### 1. Clone the Repository
```bash
git clone https://github.com/RafaelFerSilva/robot_framework_code_base_template.git
cd robot_framework_code_base_template
```

### 2. Setup Environment
```bash
# Syncs dependencies and creates the virtualenv automatically
uv sync

# Activate the environment (optional, but recommended for terminals)
source .venv/bin/activate
```

### 3. Install Browsers
```bash
python3 tools/make_install.py
```
This script handles Playwright browser initialization and final environment checks.

## 🌐 Environment Configuration

### Environment Variables (.env)
We use `python-dotenv` managed via `resources/libraries/DotEnv.py`.
Load variables for a specific environment (dev, uat, etc.) by setting the `${ENVIRONMENT}` variable at runtime.

**Example `uat.env`:**
```ini
DB_NAME=testdb
DB_USER=testuser
DB_PASSWORD=testpassword
DB_HOST=localhost
DB_PORT=3306
```

### Configuration Variables (`config_variables.py`)
Centralized settings for browser, timeouts, and URLs:
```python
BROWSER = "chromium"
HEADLESS = False
ENVIRONMENT = "UAT"
URLS = { 'UAT': 'https://demoqa.com/', ... }
```

## 🏗 3-Layer Architecture

This project follows a strict separation of concerns to ensure scalability:

1.  **Tests (Intent)**: Located in `tests/`. Focus on *what* is being tested.
2.  **Keywords (Flows)**: Logic for business processes. Grouped by feature in `resources/keywords/app/` or by utility in `resources/keywords/core/`.
3.  **Pages/Abstractions (Technical)**: Technical interface (selectors/API). Stays alongside keywords in `resources/keywords/app/<Feature>/` for maximum developer productivity.

## 🧪 Running Tests

### Standard Execution
```bash
robot -d ./reports tests/
```

### Dry Run (Validation)
```bash
robot --dryrun -d ./reports tests/
```

### Custom Environment
```bash
robot -v ENVIRONMENT:DEV -d ./reports tests/
```

## 📚 Best Practices for New Developers

### 1. Adding Infrastructure Keywords
Place generic keywords (browser helpers, date formatters, file handlers) in `resources/keywords/core/`. These must stay agnostic to the application being tested.

### 2. Adding Application Keywords
Place business logic and page-specific keywords in `resources/keywords/app/<App_Name>/`.

### 3. Imports
Always use relative paths or `${EXECDIR}` to ensure compatibility. You can run commands using `uv run` to ensure you are in the correct environment:
```bash
uv run robot -d ./reports tests/
```

```robotframework
Resource    ${EXECDIR}/resources/keywords/core/Environment.keywords.resource
Resource    ${EXECDIR}/resources/keywords/app/Book_Store/bookStore.keywords.resource
```

## 🛠 Tooling & Quality

### Linting (Robocop)
The project is configured with `robocop`. Check for quality issues:
```bash
robocop tests/ resources/
```
Local rules are defined in `.robocop` and `robot.toml`.

### Documentation
Generate an interactive HTML documentation for all keywords:
```bash
python3 tools/generate_docs.py
```

## 🤖 Robot Framework MCP (rf-mcp)

**RobotMCP** is an MCP (Model Context Protocol) server that allows AI agents (like Claude or Antigravity) to interact directly with this project, enabling the AI to plan, write, and execute tests autonomously.

### Available Features
- **Step-by-Step Execution**: The AI can execute one keyword at a time and analyze the result in real-time.
- **Keyword Discovery**: The agent automatically maps all business keywords (`resources/`) and infrastructure of this project.
- **Semantic Memory**: The server uses a local database (`.robot_memory.db`) to learn specific selectors and test patterns of this repository.

### Install

    uv tool install rf-mcp[all]

### Configure

    {
        "mcpServers": {
            "robotmcp": {
                "command": "C:/Users/rafae/Documents/Projetos/robot_framework_code_base_template-main/.venv/Scripts/robotmcp.exe",
                "args": [],
                "env": {
                    "ROBOT_PROJECT_ROOT": ""
                }
            }
        }
    }

### How to Use
The server is already globally configured in the `mcp_config.json` file. When interacting with the AI in this repository:
1. The agent automatically detects the `ROBOT_PROJECT_ROOT` as this folder.
2. You can ask: *"List the available business keywords"* or *"Create a test for flow X using existing keywords"*.
3. The agent will use MCP tools to validate locators and flows without you needing to run commands manually.

### 💡 Golden Tip: Prompt for AI
To ensure the AI strictly follows the layered architecture and writing patterns of this project, use a prompt based on this model:

```markdown
# Goal: Automate the flow [FLOW NAME]

## 1. Pattern Analysis (Architecture)
Before starting, analyze the 'resources/keywords/app/Book_Store' folder.
- Understand how selectors are organized in '.pages.resource' files.
- Observe how business logic is encapsulated in '.keywords.resource' files.
- Check how tests consume 'Environment.keywords.resource'.

## 2. Implementation
Apply the same architectural pattern:
- Page Objects in 'resources/keywords/app/[Feature]/[name].pages.resource'.
- Business Keywords in 'resources/keywords/app/[Feature]/[name].keywords.resource'.
- Test Suite in 'tests/[name].robot'.

## 3. Technical Requirements
- Use Browser Library.
- Run stepwise to validate locators before finalizing.
```

## 🤝 Contributing
Refer to [CONTRIBUTING.md](CONTRIBUTING.md) for pull request processes.

## 📞 Contact
**Rafael Fernandes da Silva** - [LinkedIn](https://www.linkedin.com/in/rafael-silva-8a10334b/)
