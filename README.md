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
- [uv](https://github.com/astral-sh/uv) (Extremamente recomendado)
- [Node.js®](https://nodejs.org/en/download/) (18+)

## 📦 Gerenciamento de Pacotes com uv

Este projeto utiliza o [uv](https://github.com/astral-sh/uv) para gerenciar dependências e ambientes virtuais. O **uv** é um substituto extremamente rápido para o `pip` e `pip-tools`, escrito em Rust.

### Por que uv?
- **Velocidade**: Até 100x mais rápido que o `pip`.
- **Confiabilidade**: Gerencia o `pyproject.toml` e gera um arquivo `uv.lock` determinístico.
- **Simplicidade**: Gerencia versões do Python, ambientes virtuais e dependências em um único binário.
- **Eficiência**: Utiliza *hard links* para evitar duplicidade de pacotes no disco.

### Comandos Essenciais
| Comando | Descrição |
| :--- | :--- |
| `uv sync` | Instala todas as dependências e cria o `.venv` automaticamente. |
| `uv add <pacote>` | Adiciona uma nova biblioteca ao projeto. |
| `uv remove <pacote>` | Remove uma biblioteca do projeto. |
| `uv run <comando>` | Executa um comando (ex: `robot`) dentro do ambiente virtual. |
| `uv lock` | Atualiza o arquivo `uv.lock` sem instalar nada. |

## 🛠 Setup and Installation

### 1. Clone the Repository
```bash
git clone https://github.com/RafaelFerSilva/robot_framework_code_base_template.git
cd robot_framework_code_base_template
```

### 2. Setup Environment
```bash
# Sincroniza dependências e cria o virtualenv automaticamente
uv sync

# Ative o ambiente (opcional, mas recomendado para terminais)
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

## 🤝 Contributing
Refer to [CONTRIBUTING.md](CONTRIBUTING.md) for pull request processes.

## 📞 Contact
**Rafael Fernandes da Silva** - [LinkedIn](https://www.linkedin.com/in/rafael-silva-8a10334b/)