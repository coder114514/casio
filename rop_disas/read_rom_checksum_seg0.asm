# 这个rop程序能够显示 checksum，按下AC后显示下一个checksum, 然后无限循环
# 之后由这些校验码就可以推断出 ROM 的内容
# 不得不说，这个代码细节很多（

	0x01fe # er14: calc_checksum n-byte count. must be even (otherwise loop forever)
home:
	org 0xd544 # 110an

	# xr0 = 0xf004, 0x01, 0x30
	# [er0] = r2

	# qr0 = 0x01, 0xfe, 0xf004, 0x34333231
	# # r1 can be arbitrary
	# # "pop xr0" can be used instead (if found)
	# [er2] = r0, r2 = 0

	qr0 = 0xf004, 0x01, 0xfe, 0x34333201
	[er0] = r2
	# now er4 = 0x01fe (er4好像没用) (初始的er10是任意的，所以第一次的checksum是没用的 (er10决定读取seg0的初始位置

	calc_checksum_0    # 2:23A4   xr4 为checksum的字符串 (4bytes
		0x303030303030 # qr8 rest (unused)
		adr_of y       # er14
	call pr_checksum_2 # 2:233E   在屏幕上显示 Pxx ...ReadXXXX (XXXX为checksum) 然后等待 AC 按下, 最后退出函数时 MOV SP,ER14; POP QR8; POP QR0; POP PC, 所以返回时是从 y 开始 pop 的

	0x34333231 # excess/pad. max 4 bytes. The printed line will start from this    Pxx ....ReadXXXX 中的 ....取决于这个 长度>=6bytes的话checksum就不能完整显示了
	0x36353433323130393837363534333231 # er14 buffer. store_reg_to_stack will write to this region
	# SP will always with restored to the correct position when the function returns
y:
	org 0xD578
	0x3030303030303030 # qr8      pr_checksum_2 返回

	0xd52c     # er0 = dest : undo buf(0xd522) + 0xa
	0xd252     # er2 = src : cache(0xd248) + 0xa = delta (mod 4 == 2)
	0x30303030 # qr0 rest (unused)


	call smart_strcpy_nn_ # keep er2 unchanged, xr8 er12 changes    这个复制主要是为了把更新后的"er10"复制过来 (er10决定读取seg0的初始位置)，以及修复被破坏的部分, 因为有些gadget会push和pop一些内容破坏rop程序
	# after this lr is good, lsr:lr=2:03D0

	call pop qr8, pop qr0
	adr_of [-0x2da] start_value # er8: 0x2da=diff between cache and undo
	0x30303030                  # r10~13, unused
	adr_of [-2] home            # er14
	0x3231                      # er0, unused
	0x3432                      # er2 (must be ==2 mod 4), used to increment "er10"    要做到只遍历所有奇偶性相同的地址 当且仅当 er2 == 2 (mod 4)
	0x38373635                  # r4~7, unused

	nop

	call r0=0, [er8] += er2, pop xr8 # only modify er2, lr and er14 unchanged

	0x3030   # er8: initial subtract value (calc checksum)
start_value:
	org 0xD5AA
	0x3131   # er10    must be odd (so LSB != nul, so strcpy can work properly)    不然遍历到有某个字节为0的地址就寄了

	# == goto home
	call mov sp, er14, pop er14
