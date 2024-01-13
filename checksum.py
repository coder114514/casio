def bytes_to_words(d):
	e=[]
	i=0
	while i<len(d):
		e.append(d[i+1]*0x0100+d[i])
		i+=2
	return e

with open('rom.bin','rb') as f:
	d=f.read()
	assert(len(d)==0x40000)
	e=bytes_to_words(d)
	assert(len(e)==0x20000)
	cs=0
	cs+=sum(e[0x00000//2:0x0FC00//2])
	cs+=sum(e[0x10000//2:0x20000//2])
	cs+=sum(e[0x20000//2:0x30000//2])
	cs+=sum(e[0x30000//2:0x3FFF6//2])
	cs%=0x10000
	cs=0x10000-cs
	print(hex(cs))
	assert(cs==0x04A8)

# checksum 就是一些字的和的相反数
# 所以根据一系列的 checksum 是可以计算出 rom 的内容的
