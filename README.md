# Robot Framework Test Automation Template

## 🚀 Project Overview

This comprehensive test automation framework leverages Robot Framework to streamline end-to-end testing across multiple environments, providing a robust and flexible testing solution.

## 📋 Prerequisites

### System Requirements
- [Python™](https://www.python.org/downloads/) (3.8+)
- [Node.js®](https://nodejs.org/en/download/) (14+)

### Recommended Development Environment
- Python 3.10 or later
- Node.js 18 or later

## 🛠 Setup and Installation

### 1. Clone the Repository
```bash
git clone https://github.com/RafaelFerSilva/robot_framework_code_base_template.git
cd robot_framework_code_base_template
```

### 2. Create Virtual Environment
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux/MacOS
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies
```bash
python make_install.py
```

This script will:
- Install project dependencies
- Initialize RobotFramework Browser Library
- Set up the testing environment

## 🌐 Environment Configuration

### Environment Variables
We use [python-dotenv](https://github.com/theskumar/python-dotenv) for environment variable management.

#### Environment-Specific `.env` Files
- `dev.env`
- `uat.env`
- `rc.env`
- `prod.env`

Refer to `example.env` for variable structure.

### Configuration Variables
Configuration is managed through `resources/config_variables.py`:

```python
# Default Configuration
DB_API_MODULE_NAME = "pymysql"
BROWSER_TIMEOUT = "40"
BROWSER = "chromium"
HEADLESS = False
PIPELINE = False
ENVIRONMENT = "UAT"

URLS = {
    'DEV': 'https://demoqa.com/',
    'UAT': 'https://demoqa.com/',
    'RC': 'https://demoqa.com/',
    'PROD': 'https://demoqa.com/'
}

LANG = "pt"
MOBILE = False
DEVICE_NAME = "Nexus 5"

NEW_CONTEXT = {
    "acceptDownloads": True,
    "bypassCSP": False,
    # ... other context settings
}
```

### Runtime Configuration
Override default settings via command line:
```bash
robot -d ./reports --output output.xml \
    -v BROWSER:firefox \
    -v BROWSER_TIMEOUT:30 \
    -v HEADLESS:true \
    -v PIPELINE:true \
    -v ENVIRONMENT:DEV \
    ./tests
```

## 🔧 Framework Components

### `__init__.robot`
Executed before/after test suites, handling:
- Environment setup
- Database connections
- Global configurations

```robotframework
Suite Setup    Run Keywords
...    Set Environment Project Variables
...        pipeline=${PIPELINE}
...        environment=${ENVIRONMENT}
...        print_variables=True    AND
...    Connect to application database
Suite Teardown    Disconnect From Database
```

### Database Configuration
Uses Docker Compose for test database:
```bash
# Start database container
docker-compose up -d
```

## 🧪 Running Tests

### Local Execution
```bash
# Standard mode
robot -d ./reports --output output.xml ./tests

# Verbose mode
robot -d ./reports --output output.xml -L TRACE ./tests
```

## 📊 Test Coverage and Reporting

### Code Coverage Validation
```bash
# Basic usage
python resources/libraries/test_coverage_validator.py reports/output.xml

# Custom minimum coverage
python resources/libraries/test_coverage_validator.py reports/output.xml --min-coverage 85

# Custom report directory
python resources/libraries/test_coverage_validator.py reports/output.xml --output-dir custom_reports
```

### Continuous Integration

#### Pull Request Pipeline
- Location: `.github/workflows/pipeline_pull_request.yml`
- Validates code coverage
- Comments on pull requests

![Pull Request Pipeline](images/image.png)

#### Push Commit Pipeline
- Location: `.github/workflows/pipeline_push.yml`
- Triggers on commits to main/develop branches

### Robot Metrics
Generate detailed test execution metrics:
```bash
# Standard report
robotmetrics --input reports/ --output output.xml

# Advanced options
robotmetrics --help
```

![Robot Metrics Report](images/image-1.png)

## ⚠️ Important Notes
- Use secrets for environment variables in pipelines
- Customize database and configuration for your specific project needs

## 🤝 Contributing
Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📜 License
Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Contact
**Rafael Fernandes da Silva**
- Email: rafatecads@gmail.com
- LinkedIn: [Rafael Silva](https://www.linkedin.com/in/rafael-silva-8a10334b/)

**Project Link**: [robot_framework_code_base_template](https://github.com/RafaelFerSilva/robot_framework_code_base_template)