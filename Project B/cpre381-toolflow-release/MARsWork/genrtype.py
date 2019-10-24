import random
instruction = input()
print(".data\n.text\n#Initialize registers")
for i in range(1,31):
	s = "addi $" + str(i) + ", $0, " + str(random.randint(-32768, 32768))
	print(s)
print("#Begin tests")
for i in range (0,100):
	j = abs(i%32)
	k = abs((i-1)%32)
	s = instruction + " $" + str(j) + ", $" + str(k) + ", $" + str(j)
	print(s)
print("addi $2, $0, 10 #halt\nsyscall")
