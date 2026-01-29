import pyodbc
import time
from datetime import datetime
import os

# ==========================================
# CONFIGURAÇÃO
# Em um cenário real, utilize variáveis de ambiente.
# Exemplo com python-dotenv:
# from dotenv import load_dotenv
# load_dotenv()
# DB_SERVER = os.getenv('DB_SERVER', 'LOCALHOST')
# ==========================================

DB_CONFIG = {
    'driver': '{ODBC Driver 17 for SQL Server}',
    'server': 'LOCALHOST',
    'database': 'Project', # Certifique-se que este banco existe
    'uid': 'sa',                  # SEU USUÁRIO DO SQL
    'pwd': 'FPTO@123',      # SUA SENHA DO SQL
}

def conectar_banco():
    """Cria a string de conexão e retorna o cursor."""
    conn_str = (
        f"DRIVER={DB_CONFIG['driver']};"
        f"SERVER={DB_CONFIG['server']};"
        f"DATABASE={DB_CONFIG['database']};"
        f"UID={DB_CONFIG['uid']};"
        f"PWD={DB_CONFIG['pwd']};"
    )
    try:
        conn = pyodbc.connect(conn_str)
        return conn
    except Exception as e:
        print(f"❌ Erro fatal de conexão: {e}")
        return None

def executar_auditoria():
    """Chama a Procedure e decide se emite alerta."""
    conn = conectar_banco()
    if not conn:
        print("⚠️ Não foi possível conectar ao banco de dados. Verifique as configurações.")
        return

    cursor = conn.cursor()
    print(f"[{datetime.now()}] 🔍 Iniciando auditoria de integridade...")

    try:
        # Executa a Procedure criada anteriormente
        cursor.execute("EXEC sp_Auditoria_Integridade_Vendas")
        
        # Captura o resultado do SELECT retornado pela procedure
        resultado = cursor.fetchone()
        
        if resultado:
            qtd_divergencias = resultado[0] # Primeira coluna (DivergenciasEncontradas)
            status_msg = resultado[2]       # Terceira coluna (Status)
            
            if qtd_divergencias > 0:
                # ==================================================
                # LÓGICA DE ALERTA (Simulação de Envio)
                # ==================================================
                alert_msg = (
                    f"⚠️ ALERTA CRÍTICO: {qtd_divergencias} inconsistências detectadas!\n"
                    f"Status: {status_msg}\n"
                    f"Ação: Verifique a tabela 'Auditoria_Divergencias' imediatamente."
                )
                print(alert_msg)
                # simulate_send_email("admin@empresa.com", alert_msg) 
            else:
                print(f"✅ Sistema Íntegro. Nenhuma divergência encontrada.")
        
        conn.commit() # Boa prática, garante commit de qualquer transação aberta, embora seja leitura/insert interno
        
    except pyodbc.Error as e:
        print(f"❌ Erro na execução da Procedure: {e}")
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    # Executa a auditoria
    executar_auditoria()
