# Constantes
LIMITE_SAQUES = 3
TAXA_JUROS = 0.1 # 10% ao mês

# Variáveis
saldo = 0
limite = 500
extrato = ""
numero_saques = 0
total_devido = 0
pagamento_minimo = 0

# Funções
def depositar(valor):
    global saldo, extrato, total_devido, pagamento_minimo
    saldo += valor
    extrato += f"Depósito: R$ {valor:.2f}\n"
    # Atualiza o total devido e o pagamento mínimo se o saldo for negativo
    if saldo < 0:
        total_devido = -saldo * (1 + TAXA_JUROS)
        pagamento_minimo = total_devido * 0.15 # 15% do total devido

def sacar(valor):
    global saldo, extrato, numero_saques, total_devido, pagamento_minimo
    excedeu_saldo = valor > saldo
    excedeu_limite = valor > limite
    excedeu_saques = numero_saques >= LIMITE_SAQUES
        
    if excedeu_saldo:
        print("Sem saldo suficiente")
    elif excedeu_limite:
        print("Excedeu o limite")
    elif excedeu_saques:
        print("Excedeu o número de saques")
    elif valor > 0:
        saldo -= valor
        extrato += f"Saque: R$ {valor:.2f}\n"
        numero_saques += 1
        # Atualiza o total devido e o pagamento mínimo se o saldo for negativo
        if saldo < 0:
            total_devido = -saldo * (1 + TAXA_JUROS)
            pagamento_minimo = total_devido * 0.15 # 15% do total devido
    else:
        print("Operação inválida")

def mostrar_saldo():
    global saldo, extrato, total_devido, pagamento_minimo
    print("Seu saldo atual é: R$ " + str(saldo))
    print("Seu extrato é:")
    print(extrato)
    # Mostra o total devido e o pagamento mínimo se o saldo for negativo
    if saldo < 0:
        print(f"Você está usando R$ {-saldo:.2f} do seu cheque especial.")
        print(f"O total devido ao banco é R$ {total_devido:.2f}.")
        print(f"O pagamento mínimo mensal é R$ {pagamento_minimo:.2f}.")

# Programa principal
while True:
    opcao = input("""
[d] Depositar
[s] Sacar
[e] Extrato
[q] Sair
=> """)
    
    if opcao == "d":
        valor = float(input("Quanto gostaria de depositar? \n"))
        if valor > 0:
            depositar(valor)
        else:
            print("Valor inválido")
    
    elif opcao == "s":
        valor = float(input("Informe o valor de saque: "))
        sacar(valor)
    
    elif opcao == "e":
        center = "EXTRATO"
        print(center.center(50,"-"))
        mostrar_saldo()
        center = ""
        print(center.center(50,"-"))
    
    elif opcao == "q":
        break
    
    else:
        print("Operação inválida, por favor, selecione a operação desejada.") 
