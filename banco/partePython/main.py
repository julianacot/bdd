import mysql.connector
from mysql.connector import Error
from db_config import conectar_db
import os
from decimal import Decimal
import getpass
import sys 

HOST_DB = "localhost"
USUARIO_ROOT = "root" 
SENHA_ROOT = "sua_senha_root" 
NOME_DB = "supermais"
PASTA_SQL = "sql"

USUARIO_APP = "aplicacao"
SENHA_APP = "app_senha_123"

USUARIOS_SISTEMA = {
    "admin": {"senha": "admin123", "role": "administrador"},
    "gerente": {"senha": "gerente123", "role": "gerente"},
    "func": {"senha": "func123", "role": "funcionario"},
    "cad": {"senha": "cad123", "role": "cadastrador"}
}

def executar_script_simples(cursor, caminho_arquivo, usuario_conexao):
    caminho_completo = os.path.join(PASTA_SQL, caminho_arquivo)
    print(f"[{usuario_conexao}] Executando script: {caminho_arquivo}")
    
    if not os.path.exists(caminho_completo):
        print(f"Erro: Arquivo não encontrado: {caminho_completo}")
        return

    with open(caminho_completo, 'r', encoding='utf-8') as f:
        conteudo_sql = f.read()
    
    comandos = [cmd.strip() for cmd in conteudo_sql.split(';') if cmd.strip()]
    
    for comando in comandos:
        try:
            cursor.execute(comando)
        except Error as e:
            if e.errno == 1007 or e.errno == 1008: 
                continue
            print(f"Erro ao executar comando: {comando[:50]}...")
            print(e)
            raise 

def executar_script_complexo(cursor, caminho_arquivo, usuario_conexao):
    caminho_completo = os.path.join(PASTA_SQL, caminho_arquivo)
    print(f"[{usuario_conexao}] Executando script: {caminho_arquivo}")

    if not os.path.exists(caminho_completo):
        print(f"Erro: Arquivo não encontrado: {caminho_completo}")
        return

    with open(caminho_completo, 'r', encoding='utf-8') as f:
        conteudo_sql = f.read()
    
    blocos = conteudo_sql.split('DELIMITER ;')
    for bloco in blocos:
        bloco_limpo = bloco.strip()
        if not bloco_limpo: continue
        
        if "DELIMITER $$" in bloco_limpo:
            comando_final = bloco_limpo.split('DELIMITER $$', 1)[-1].strip()
        else:
            comando_final = bloco_limpo
            
        comando_final = comando_final.replace('$$', '').strip()
        if comando_final.endswith(';'):
            comando_final = comando_final[:-1].strip()

        if comando_final:
            try:
                cursor.execute(comando_final)
            except Error as e:
                print(f"Erro ao executar bloco: {comando_final[:50]}...")
                print(e)
                raise

def get_conexao_db():
    return conectar_db(HOST_DB, USUARIO_APP, SENHA_APP, NOME_DB)

def aguardar_enter():
    input("\nPressione Enter para voltar ao menu...")
    
def print_resultados(cursor, headers=None):
    if not headers:
        if cursor.description:
             headers = [i[0] for i in cursor.description]
    
    if headers:
        print("\n--- " + " | ".join(headers) + " ---")
    else:
        print("\n--- Resultados ---")

    rows = cursor.fetchall()
    if not rows:
        print("Nenhum resultado encontrado.")
        return
        
    for row in rows:
        print(row)

def chamar_calcula_idade():
    print("\n--- Chamar FUNÇÃO: Calcula_idade ---")
    conn = None
    try:
        id_cliente = int(input("Digite o ID do Cliente: "))
        conn = get_conexao_db()
        cursor = conn.cursor()
        cursor.execute("SELECT Calcula_idade(%s) AS Idade", (id_cliente,))
        resultado = cursor.fetchone()
        
        if resultado and resultado[0] is not None:
            print(f"Resultado: A idade do cliente {id_cliente} é {resultado[0]} anos.")
        else:
            print("Cliente não encontrado.")
            
    except ValueError:
        print("Erro: ID deve ser um número.")
    except Error as e:
        print(f"Erro de SQL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def chamar_soma_fretes():
    print("\n--- Chamar FUNÇÃO: Soma_fretes ---")
    conn = None
    try:
        destino = input("Digite o Endereço de destino (ex: 'Rua 1, São Paulo'): ")
        conn = get_conexao_db()
        cursor = conn.cursor()
        cursor.execute("SELECT Soma_fretes(%s) AS Total_Fretes", (destino,))
        resultado = cursor.fetchone()
        
        if resultado and resultado[0] is not None:
            print(f"Resultado: O total de fretes para '{destino}' é R$ {resultado[0]:.2f}")
        else:
            print(f"Nenhum frete encontrado para '{destino}'.")
            
    except Error as e:
        print(f"Erro de SQL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def chamar_arrecadado():
    print("\n--- Chamar FUNÇÃO: Arrecadado ---")
    conn = None
    try:
        data = input("Digite a data (YYYY-MM-DD): ")
        id_func = int(input("Digite o ID do Funcionário: "))
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        cursor.execute("SELECT Arrecadado(%s, %s) AS Total_Arrecadado", (data, id_func))
        resultado = cursor.fetchone()
        
        if resultado and resultado[0] is not None:
            print(f"Resultado: Total arrecadado em {data} pelo func. {id_func} foi R$ {resultado[0]:.2f}")
        else:
            print("Nenhum dado encontrado.")
            
    except ValueError:
        print("Erro: ID deve ser um número.")
    except Error as e:
        print(f"Erro de SQL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def chamar_reajuste():
    print("\n--- Chamar PROCEDURE: Reajuste ---")
    conn = None
    try:
        percentual = Decimal(input("Digite o percentual de reajuste (ex: 10.5): "))
        categoria = input("Digite a categoria (vendedor, gerente, CEO): ")
        
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        cursor.callproc('Reajuste', (percentual, categoria))
        conn.commit() 

        for result in cursor.stored_results():
            print(f"Resultado: {result.fetchone()[0]}")
            
    except ValueError:
        print("Erro: Percentual deve ser um número.")
    except Error as e:
        print(f"Erro de SQL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def chamar_sorteio():
    print("\n--- Chamar PROCEDURE: Sorteio ---")
    conn = None
    try:
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        cursor.callproc('Sorteio', [])
        
        for result in cursor.stored_results():
            print_resultados(result, headers=["Cliente", "Valor_Voucher", "Tipo_Cliente"])
            
    except Error as e:
        print(f"Erro de SQL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def chamar_venda():
    print("\n--- Chamar PROCEDURE: Venda (Reduzir Estoque) ---")
    conn = None
    try:
        id_venda = int(input("Digite o ID da Venda para dar baixa no estoque: "))
        
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        cursor.callproc('Venda', (id_venda,))
        conn.commit() 

        for result in cursor.stored_results():
            print(f"Resultado: {result.fetchone()[0]}")
            
    except ValueError:
        print("Erro: ID deve ser um número.")
    except Error as e:
        print(f"Erro de SQL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()
    
def chamar_estatisticas():
    print("\n--- Chamar PROCEDURE: Estatisticas ---")
    conn = None
    try:
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        cursor.callproc('Estatisticas', [])
        
        for result in cursor.stored_results():
            headers = [i[0] for i in result.description]
            print_resultados(result, headers=headers)
            
    except Error as e:
        print(f"Erro de SQL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()
    
def visualizar_views():
    print("\n--- Visualizar VIEWS ---")
    print("1. vw_admin_vendas")
    print("2. vw_gerente_funcionarios")
    print("3. vw_funcionario_resumo_vendas")
    print("4. vw_clientes_produtos")
    escolha = input("Escolha a VIEW (1-4): ")
    
    views = {
        '1': 'vw_admin_vendas',
        '2': 'vw_gerente_funcionarios',
        '3': 'vw_funcionario_resumo_vendas',
        '4': 'vw_clientes_produtos'
    }
    
    if escolha not in views:
        print("Opção inválida.")
        aguardar_enter()
        return

    conn = None
    try:
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        view_nome = views[escolha]
        print(f"\nExibindo 10 primeiras linhas de: {view_nome}")
        
        cursor.execute(f"SELECT * FROM {view_nome} LIMIT 10")
        print_resultados(cursor)
            
    except Error as e:
        print(f"Erro de SQL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def testar_triggers():
    print("\n--- Testar TRIGGERS (Cashback e Bônus) ---")
    print("Esta operação insere uma venda para testar o disparo dos triggers.")
    
    conn = None
    try:
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        cursor.execute("SELECT Bonus FROM Funcionario_Esp WHERE Id = 3")
        bonus_antes = cursor.fetchone()[0]
        cursor.execute("SELECT Cashback FROM Cliente_Esp WHERE Id = 2")
        cashback_antes = cursor.fetchone()[0]

        print(f"\nSaldo antes: Bônus Func. 3 = {bonus_antes}, Cashback Cli. 2 = {cashback_antes}")

        print("\n1. Criando nova Venda para o Cliente 2 e Funcionario 3...")
        cursor.execute("""
            INSERT INTO Venda (Data, Hora, Endereco, Frete, idCliente, idFuncionario, idTransportadora) 
            VALUES (CURDATE(), CURTIME(), 'Rua Teste Trigger', 50.00, 2, 3, 1)
        """)
        id_nova_venda = cursor.lastrowid
        print(f"Venda ID={id_nova_venda} criada.")

        print("2. Adicionando Produto (ID 2) à Venda (assumindo que gera bônus/cashback)...")
        cursor.execute("INSERT INTO Produto_Venda (idVenda, idProduto) VALUES (%s, 2)", (id_nova_venda,))
        
        conn.commit()
        
        print("\n--- RESULTADOS DOS TRIGGERS ---")
        
        cursor.execute("SELECT Bonus FROM Funcionario_Esp WHERE Id = 3")
        bonus_depois = cursor.fetchone()[0]
        cursor.execute("SELECT Cashback FROM Cliente_Esp WHERE Id = 2")
        cashback_depois = cursor.fetchone()[0]

        print(f"Saldo depois: Bônus Func. 3 = {bonus_depois} (Ganho: {bonus_depois - bonus_antes:.2f})")
        print(f"Saldo depois: Cashback Cli. 2 = {cashback_depois} (Ganho: {cashback_depois - cashback_antes:.2f})")
        print("\nVenda de teste commitada. Triggers ativados.")

    except Error as e:
        print(f"Erro de SQL: {e}")
        conn.rollback()
    except TypeError:
        print("Erro: Verifique se as tabelas Cliente_Esp/Funcionario_Esp têm os IDs 2 e 3.")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def chamar_cadastrar_cliente():
    print("\n--- Cadastrar Novo Cliente ---")
    conn = None
    try:
        nome = input("Nome: ")
        sexo = input("Sexo (m/f/o): ").lower()
        nasc = input("Data Nascimento (YYYY-MM-DD): ")
        
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        query = "INSERT INTO Cliente (Nome, Sexo, Nasc) VALUES (%s, %s, %s)"
        cursor.execute(query, (nome, sexo, nasc))
        conn.commit()
        
        print(f"Cliente '{nome}' cadastrado com sucesso! ID: {cursor.lastrowid}")

    except Error as e:
        print(f"Erro de SQL: {e}")
        conn.rollback()
    except Exception as e:
        print(f"Erro: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def chamar_cadastrar_produto():
    print("\n--- Cadastrar Novo Produto ---")
    conn = None
    try:
        nome = input("Nome do Produto: ")
        estoque = int(input("Estoque inicial: "))
        valor = Decimal(input("Valor (ex: 199.90): "))
        desc = input("Descrição: ")
        id_func_padrao = 1
        
        conn = get_conexao_db()
        cursor = conn.cursor()
        
        query = """
            INSERT INTO Produto (Nome, Estoque, Descricao, Valor, idFuncionario) 
            VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query, (nome, estoque, desc, valor, id_func_padrao))
        conn.commit()
        
        print(f"Produto '{nome}' cadastrado com sucesso! ID: {cursor.lastrowid}")

    except ValueError:
        print("Erro: Estoque e Valor devem ser números.")
    except Error as e:
        print(f"Erro de SQL: {e}")
        conn.rollback()
    except Exception as e:
        print(f"Erro: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
    aguardar_enter()

def resetar_banco_dados():
    print("\n--- [ADMIN] Resetar Banco de Dados ---")
    confirm = input("ATENÇÃO! Isso apagará TUDO. Tem certeza? (s/n): ").lower()
    
    if confirm != 's':
        print("Operação cancelada.")
        aguardar_enter()
        return

    conn_servidor = None
    conn_db = None
    try:
        print("Etapa 1: Destruindo e recriando o Schema (Conectando como ROOT)...")
        conn_servidor = conectar_db(HOST_DB, USUARIO_ROOT, SENHA_ROOT) 
        if not conn_servidor: 
             print("Falha crítica na conexão com o servidor. Verifique as credenciais do ROOT.")
             return
        cursor_serv = conn_servidor.cursor()

        executar_script_simples(cursor_serv, '00_destroi.sql', USUARIO_ROOT)
        executar_script_simples(cursor_serv, '01_cria_schema.sql', USUARIO_ROOT)
        
        cursor_serv.close()
        conn_servidor.close()
        
        print("Etapa 2: Populando o banco e configurando lógica (Conectando como aplicacao)...")
        conn_db = conectar_db(HOST_DB, USUARIO_APP, SENHA_APP, NOME_DB)
        if not conn_db: 
            print("Falha crítica na conexão com o DB 'supermais'. Verifique o usuário 'aplicacao'.")
            return
        cursor_db = conn_db.cursor()

        executar_script_simples(cursor_db, '02_insere_dados.sql', USUARIO_APP)
        conn_db.commit()
        
        print("Etapa 3: Criando Funções, Triggers e Procedures...")
        executar_script_complexo(cursor_db, '03_funcoes.sql', USUARIO_APP)
        executar_script_complexo(cursor_db, '04_triggers.sql', USUARIO_APP)
        executar_script_complexo(cursor_db, '07_procedures.sql', USUARIO_APP)
        
        print("Etapa 4: Criando Usuários e Views...")
        executar_script_simples(cursor_db, '05_usuarios.sql', USUARIO_APP)
        executar_script_simples(cursor_db, '06_views.sql', USUARIO_APP)
        cursor_db.execute('FLUSH PRIVILEGES')
        conn_db.commit()
        
        print("\nSUCESSO! O banco foi totalmente resetado e configurado.")

    except Error as e:
        print(f"Ocorreu um erro geral no reset: {e}")
        if conn_db and conn_db.is_connected(): conn_db.rollback()
    except FileNotFoundError as e:
        print(f"Erro: Arquivo SQL não encontrado. {e}")
    finally:
        if conn_servidor and conn_servidor.is_connected(): conn_servidor.close()
        if conn_db and conn_db.is_connected(): conn_db.close()
            
    aguardar_enter()

def tela_login():
    os.system('cls' if os.name == 'nt' else 'clear')
    print("========================================")
    print("      Login - Sistema 'supermais'     ")
    print("========================================")
    
    while True:
        login = input("Usuário: ").strip().lower()
        senha = getpass.getpass("Senha: ").strip()
        
        usuario = USUARIOS_SISTEMA.get(login)
        
        if usuario and usuario["senha"] == senha:
            print(f"Login bem-sucedido! Bem-vindo, {login} (Cargo: {usuario['role']})")
            input("Pressione Enter para continuar...")
            return usuario["role"]
        else:
            print("Usuário ou senha inválidos. Tente novamente.\n")

def main_menu(role):
    
    pode_ver_funcoes = role in ["administrador", "gerente"]
    pode_ver_procedures = role in ["administrador", "gerente"]
    pode_ver_views = role in ["administrador", "gerente", "funcionario", "cadastrador"]
    pode_fazer_venda = role in ["administrador", "funcionario"]
    pode_cadastrar = role in ["administrador", "cadastrador"]
    pode_resetar = role == "administrador"
    
    while True:
        os.system('cls' if os.name == 'nt' else 'clear') 
        print("========================================")
        print(f"  Painel de Controle - DB 'supermais'  ")
        print(f"  Usuário: {role.upper()}")
        print("========================================")
        
        if pode_ver_funcoes:
            print("\n--- Funções (Relatórios) ---")
            print("1. Calcula_idade ")
            print("2. Soma_fretes destino")
            print("3. Arrecadado data")
            
        if pode_ver_procedures:
            print("\n--- Procedures (Ações Gerenciais) ---")
            print("4. Reajuste percentual, categoria")
            print("5. Sorteio")
            print("6. Venda id_venda ")
            print("7. Estatisticas")
            
        if pode_ver_views:
            print("\n--- Visualizações ---")
            print("8. Visualizar VIEWS (TOP 10)")

        if pode_fazer_venda:
            print("\n--- Vendas/Triggers ---")
            print("9. Registrar Venda ")
            
        if pode_cadastrar:
            print("\n--- Cadastros ---")
            print("C. Cadastrar Novo Cliente")
            print("P. Cadastrar Novo Produto")
            
        if pode_resetar:
            print("\n--- Administração ---")
            print("R. [ADMIN] Resetar e Reinstalar Banco de Dados")
            
        print("\n----------------------------------------")
        print("S. Sair (Logout)")
        print("========================================")
        
        escolha = input("Escolha uma opção: ").strip().lower()
        
        if escolha == '1' and pode_ver_funcoes:
            chamar_calcula_idade()
        elif escolha == '2' and pode_ver_funcoes:
            chamar_soma_fretes()
        elif escolha == '3' and pode_ver_funcoes:
            chamar_arrecadado()
        elif escolha == '4' and pode_ver_procedures:
            chamar_reajuste()
        elif escolha == '5' and pode_ver_procedures:
            chamar_sorteio()
        elif escolha == '6' and pode_ver_procedures:
            chamar_venda()
        elif escolha == '7' and pode_ver_procedures:
            chamar_estatisticas()
        elif escolha == '8' and pode_ver_views:
            visualizar_views()
        elif escolha == '9' and pode_fazer_venda:
            testar_triggers()
            
        elif escolha == 'c' and pode_cadastrar:
            chamar_cadastrar_cliente()
        elif escolha == 'p' and pode_cadastrar:
            chamar_cadastrar_produto()
            
        elif escolha == 'r' and pode_resetar:
            resetar_banco_dados()
            
        elif escolha == 's':
            print("Fazendo logout...")
            break
        else:
            print("Opção inválida ou não permitida para seu cargo.")
            aguardar_enter()

if __name__ == "__main__":
    
    while True:
        role_logado = tela_login()
        if role_logado:
            main_menu(role_logado)
        else:
            print("Encerrando o programa.")
            break
