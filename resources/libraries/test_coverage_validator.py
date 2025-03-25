import sys
import os
import io
from datetime import datetime
from robot.api import ExecutionResult
import json

# Forçar codificação UTF-8
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

def generate_markdown_report(result, min_coverage):
    """
    Gera um relatório de cobertura de testes em formato Markdown.
    
    Args:
        result (ExecutionResult): Resultado da execução dos testes
        min_coverage (float): Porcentagem mínima de cobertura
    
    Returns:
        str: Relatório em formato Markdown
    """
    # Calcula estatísticas
    total_tests = result.statistics.total.total
    passed_tests = result.statistics.total.passed
    failed_tests = result.statistics.total.failed
    skipped_tests = result.statistics.total.skipped
    
    # Calcula porcentagem de testes passados
    pass_percentage = (passed_tests / total_tests) * 100
    
    # Determina status da cobertura
    coverage_status = "Aprovado ✅" if pass_percentage >= min_coverage else "Reprovado ❌"
    
    # Cria relatório Markdown
    markdown_report = f"""## Relatorio de Cobertura de Testes

### Resumo Geral
| Metrica | Valor |
|---------|-------|
| Status da Cobertura | {coverage_status} |
| Cobertura Minima Requerida | {min_coverage}% |
| Cobertura Atual | {pass_percentage:.2f}% |

### Detalhes dos Testes
| Tipo de Teste | Quantidade |
|--------------|------------|
| Total de Testes | {total_tests} |
| Testes Passados | {passed_tests} |
| Testes Falhos | {failed_tests} |
| Testes Pulados | {skipped_tests} |

### Detalhamento por Suite
| Suite | Total de Testes | Testes Passados | Cobertura |
|-------|----------------|-----------------|-----------|
"""

    # Adiciona detalhes de cada suíte de testes
    for suite in result.statistics.suite:
        suite_pass_percentage = (suite.passed / suite.total) * 100 if suite.total > 0 else 0
        markdown_report += f"| {suite.name} | {suite.total} | {suite.passed} | {suite_pass_percentage:.2f}% |\n"

    # Adiciona rodapé
    markdown_report += f"\n*Gerado em: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}*"
    
    return markdown_report

def save_markdown_report(report, output_dir):
    """
    Salva o relatório Markdown em um arquivo.
    
    Args:
        report (str): Conteúdo do relatório em Markdown
        output_dir (str): Diretório para salvar o relatório
    
    Returns:
        str: Caminho completo do arquivo gerado
    """
    # Cria diretório se não existir
    os.makedirs(output_dir, exist_ok=True)
    
    # Gera nome de arquivo
    filename = f"test_coverage_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
    filepath = os.path.join(output_dir, filename)
    
    # Salva arquivo com codificação UTF-8
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"Relatorio Markdown gerado em: {filepath}")
    
    return filepath

def validate_test_coverage(
    output_file, 
    min_coverage=80, 
    output_dir='test_reports', 
    verbose=True
):
    """
    Valida a cobertura de testes e gera relatório Markdown.
    
    Args:
        output_file (str): Caminho para o arquivo de output.xml
        min_coverage (float, opcional): Porcentagem mínima de cobertura. Padrão é 80.
        output_dir (str, opcional): Diretório para salvar relatórios. Padrão é 'test_reports'.
        verbose (bool, opcional): Habilita log detalhado. Padrão é True.
    
    Raises:
        AssertionError: Se a cobertura de testes estiver abaixo do mínimo especificado.
    """
    try:
        # Carrega o resultado da execução dos testes
        result = ExecutionResult(output_file)
        
        # Calcula porcentagem de testes passados
        total_tests = result.statistics.total.total
        passed_tests = result.statistics.total.passed
        pass_percentage = (passed_tests / total_tests) * 100
        
        # Gera relatório Markdown
        markdown_report = generate_markdown_report(result, min_coverage)
        
        # Salva relatório Markdown
        save_markdown_report(markdown_report, output_dir)
        
        # Valida cobertura mínima
        if pass_percentage < min_coverage:
            print("Falha na Cobertura de Testes")
            raise AssertionError(
                f"Cobertura de testes de {pass_percentage:.2f}% "
                f"esta abaixo do minimo requerido de {min_coverage}%"
            )
        
        print(f"Cobertura de testes aprovada: {pass_percentage:.2f}%")
        sys.exit(0)
    
    except Exception as e:
        print(f"Erro na validacao de cobertura: {e}")
        sys.exit(1)

def main():
    """
    Funcao principal para execucao via linha de comando.
    Permite passar argumentos customizados.
    """
    import argparse
    
    parser = argparse.ArgumentParser(description='Validador de Cobertura de Testes')
    parser.add_argument('output_file', help='Caminho para o arquivo output.xml')
    parser.add_argument('--min-coverage', type=float, default=80, 
                        help='Porcentagem minima de cobertura (padrao: 80)')
    parser.add_argument('--output-dir', default='test_reports', 
                        help='Diretorio para salvar relatorios')
    parser.add_argument('--quiet', action='store_true', 
                        help='Desabilita log detalhado')
    
    args = parser.parse_args()
    
    validate_test_coverage(
        args.output_file, 
        min_coverage=args.min_coverage, 
        output_dir=args.output_dir,
        verbose=not args.quiet
    )

if __name__ == "__main__":
    main()