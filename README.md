# ROBOT FRAMEWORK CODE BASE TEMPLATE

## Prerequisites

Browser Library installation requires both Python and NodeJs

Install [Python™](https://www.python.org/downloads/)

Install [Node.js®](https://nodejs.org/en/download/)

## Environment

Create a python virtual environment:

    python3 -m venv venv

Active environment:

- Windows
    
      venv\script\activate

- Linux/MacOS

      source venv/bin/activate

## Dependências.
Basic dependêncies for project are on requirements.txt file and use a make_install.py script for install and initializate the robotframework-browser library.

    python make_install.py


## Run the Tests
  ### Local
      robot -d ./reports --output output.xml ./tests
  
  ### Pipeline
      robot -d ./reports --output output.xml  -v HEADLESS:true -v PIPELINE:true  ./tests




## Code Coverage
We have a script to validate tests code coverage and generate markdown report (resources\libraries\test_coverage_validator.py)

    # Basic mode
    python .\resources\libraries\test_coverage_validator.py .\reports\output.xml

    # Customizing minimum coverage
    python .\resources\libraries\test_coverage_validator.py .\reports\output.xml --min-coverage 85

    # Setting Report Directory
    python .\resources\libraries\test_coverage_validator.py .\reports\output.xml --output-dir custom_reports --min-coverage 85

    # Silent mode
    python .\resources\libraries\test_coverage_validator.py .\reports\output.xml --quiet

## Robot Metrics Usage

[robotframework-metrics](https://github.com/adiralashiva8/robotframework-metrics )

After executing your Robot Framework tests, you can generate a metrics report by running:

    robotmetrics --input .\reports\ --output output.xml
    
For more options:

    robotmetrics --help

