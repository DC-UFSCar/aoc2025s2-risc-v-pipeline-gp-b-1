dp = float(input("Digite o desvio padrão: "))
notas = []
for i in range(5):
    nota = float(input(f"Digite a Nota #{i}:"))
    notas.append(nota)

print(f"Notas: {notas} | Desvio padrão: {dp}")

soma = 0
for n in notas:
    soma += (n - dp)
    soma += n
    soma += (n + dp)

media = soma / 15

print(f"Média: {media:.2f}")