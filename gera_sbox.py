import random

vals = list(range(1024))
random.shuffle(vals)

with open("sbox10.hex", "w") as f:
    for v in vals:
        f.write(f"{v:03X}\n")
