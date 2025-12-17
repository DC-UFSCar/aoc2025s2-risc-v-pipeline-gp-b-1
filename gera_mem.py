with open("text.hex", "r", encoding="UTF-8") as dataf:
    content = dataf.readlines()

content.insert(0, "@00000000\n")

with open("riscv.hex", "w+", encoding="utf-8") as hexf:
    hexf.writelines(content)

print("DONE")