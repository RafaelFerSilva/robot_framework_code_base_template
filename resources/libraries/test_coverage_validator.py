import sys
import os
import io
import pytz
from datetime import datetime
from robot.api import ExecutionResult
import json

# Force UTF-8 encoding
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# Set the timezone to Brazil/Sao Paulo
brazil_tz = pytz.timezone('America/Sao_Paulo')

def generate_markdown_report(result, min_coverage):
    """
    Generates a test coverage report in Markdown format.
    
    Args:
        result (ExecutionResult): Test execution result
        min_coverage (float): Minimum coverage percentage
    
    Returns:
        str: Report in Markdown format
    """
    # Calculate statistics
    total_tests = result.statistics.total.total
    passed_tests = result.statistics.total.passed
    failed_tests = result.statistics.total.failed
    skipped_tests = result.statistics.total.skipped
    
    # Calculate percentage of passed tests
    pass_percentage = (passed_tests / total_tests) * 100
    
    # Determine coverage status
    coverage_status = "Passed ✅" if pass_percentage >= min_coverage else "Failed ❌"
    
    # Create Markdown report
    markdown_report = f"""## Test Coverage Report

### General Summary
| Metric | Value |
|--------|-------|
| Coverage Status | {coverage_status} |
| Minimum Required Coverage | {min_coverage}% |
| Current Coverage | {pass_percentage:.2f}% |

### Test Details
| Test Type | Quantity |
|-----------|----------|
| Total Tests | {total_tests} |
| Passed Tests | {passed_tests} |
| Failed Tests | {failed_tests} |
| Skipped Tests | {skipped_tests} |

### Suite Breakdown
| Suite | Total Tests | Passed Tests | Coverage |
|-------|-------------|--------------|----------|
"""

    # Add details for each test suite
    for suite in result.statistics.suite:
        suite_pass_percentage = (suite.passed / suite.total) * 100 if suite.total > 0 else 0
        markdown_report += f"| {suite.name} | {suite.total} | {suite.passed} | {suite_pass_percentage:.2f}% |\n"

    # Add footer with Brazil timezone
    markdown_report += f"\n*Generated on: {datetime.now(brazil_tz).strftime('%Y-%m-%d %H:%M:%S')}*"
    
    return markdown_report

def save_markdown_report(report, output_dir):
    """
    Saves the Markdown report to a file.
    
    Args:
        report (str): Markdown report content
        output_dir (str): Directory to save the report
    
    Returns:
        str: Full path of the generated file
    """
    # Create directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate filename using Brazil timezone
    filename = f"test_coverage_report_{datetime.now(brazil_tz).strftime('%Y%m%d_%H%M%S')}.md"
    filepath = os.path.join(output_dir, filename)
    
    # Save file with UTF-8 encoding
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"Markdown report generated at: {filepath}")
    
    return filepath

def validate_test_coverage(
    output_file, 
    min_coverage=80, 
    output_dir='test_reports', 
    verbose=True
):
    """
    Validates test coverage and generates Markdown report.
    
    Args:
        output_file (str): Path to output.xml file
        min_coverage (float, optional): Minimum coverage percentage. Defaults to 80.
        output_dir (str, optional): Directory to save reports. Defaults to 'test_reports'.
        verbose (bool, optional): Enables detailed logging. Defaults to True.
    
    Raises:
        AssertionError: If test coverage is below the specified minimum.
    """
    try:
        # Load test execution result
        result = ExecutionResult(output_file)
        
        # Calculate percentage of passed tests
        total_tests = result.statistics.total.total
        passed_tests = result.statistics.total.passed
        pass_percentage = (passed_tests / total_tests) * 100
        
        # Generate Markdown report
        markdown_report = generate_markdown_report(result, min_coverage)
        
        # Save Markdown report
        save_markdown_report(markdown_report, output_dir)
        
        # Validate minimum coverage
        if pass_percentage < min_coverage:
            print("Test Coverage Failed")
            raise AssertionError(
                f"Test coverage of {pass_percentage:.2f}% "
                f"is below the required minimum of {min_coverage}%"
            )
        
        print(f"Test coverage passed: {pass_percentage:.2f}%")
        sys.exit(0)
    
    except Exception as e:
        print(f"Error in coverage validation: {e}")
        sys.exit(1)

def main():
    """
    Main function for command-line execution.
    Allows passing custom arguments.
    """
    import argparse
    
    parser = argparse.ArgumentParser(description='Test Coverage Validator')
    parser.add_argument('output_file', help='Path to output.xml file')
    parser.add_argument('--min-coverage', type=float, default=80, 
                        help='Minimum coverage percentage (default: 80)')
    parser.add_argument('--output-dir', default='test_reports', 
                        help='Directory to save reports')
    parser.add_argument('--quiet', action='store_true', 
                        help='Disable detailed logging')
    
    args = parser.parse_args()
    
    validate_test_coverage(
        args.output_file, 
        min_coverage=args.min_coverage, 
        output_dir=args.output_dir,
        verbose=not args.quiet
    )

if __name__ == "__main__":
    main()