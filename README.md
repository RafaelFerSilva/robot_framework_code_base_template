# Robot Framework Test Automation Template

## 🚀 Project Overview
This project provides a comprehensive test automation framework using Robot Framework, designed to streamline end-to-end testing across different environments.

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

## 🧪 Running Tests

### Local Execution
```bash
# Standard mode
robot -d ./reports --output output.xml ./tests

# Verbose mode
robot -d ./reports --output output.xml -L TRACE ./tests
```

### Pipeline Execution
```bash
robot -d ./reports --output output.xml -v HEADLESS:true -v PIPELINE:true ./tests
```

## 🌐 Environment Configuration

### Environment Variables
We use [python-dotenv](https://github.com/theskumar/python-dotenv) for environment variable management.

Create environment-specific `.env` files:
- `dev.env`
- `uat.env`
- `rc.env`
- `prod.env`

Refer to `example.env` for variable structure.

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

### Robot Metrics
Generate detailed test execution metrics:
```bash
# Standard report
robotmetrics --input reports/ --output output.xml

# Advanced options
robotmetrics --help
```

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📜 License
Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Contact
Rafael Fernandes da Silva

E-mail: rafatecads@gmail.com

linkedin: [Rafael Silva](https://www.linkedin.com/in/rafael-silva-8a10334b/)

Project Link: [robot_framework_code_base_template](https://github.com/RafaelFerSilva/robot_framework_code_base_template#)