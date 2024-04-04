import random


f = open("A.txt","w")
A = []
temp = []
for j in range(30):
    for i in range(256):
        t = random.randint(0,9)
        temp.append(t)
        f.write(str(t)+"\n")
    A.append(temp)
    temp = []
f.close()

print("A \n")
print(A)

f = open("B.txt","w")
B = []
for i in range(256):
    t = random.randint(0,9)
    B.append(t)
    f.write(str(t)+"\n")
f.close()

print("B \n")
print(B)

R = []
for i in range(30):
    R.append(0)

for i in range(30):
    for j in range(256):
        R[i] += A[i][j]*B[j]

print("R \n")
print(R)


Rrev = []
for i in range(30):
    Rrev.append(0)

for i in range(30,-1,-1):
    for j in range(256,-1,-1):
        Rrev[i] += A[i][j]*B[j]

print("Rrev \n")
print(Rrev)