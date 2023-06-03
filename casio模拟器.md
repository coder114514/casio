### CLASSWIZ fx-991CN X

打开模拟器，Cheat Engine 搜索 0000C100，若地址为x：（实际机器应该也是一样的）

byte x: 08 代表shift按下，04 代表alpha按下，00表示都没按下

byte x+1: 当前模式 C1是COMP，C4是COMPLEX，C0是68

byte x+0x45: 光标位置 (从0开始，到255结束)，插入模式下，光标在对应字符的左侧

byte x+0x70 到 x+0x136 (两端包含): 输入区，长度199bytes，从输入区第189byte开始，光标变宽

byte x+0x137: 正常为00，用来分隔输入区和undo区 [输入区第200byte]

byte x+0x138 到 x+0x1FE (两端包含): undo区，长度199bytes，每次按下=之后输入区内容会被复制到undo区，然后没有字符时按左或右即可调出undo区内容 [输入区第201byte到第399byte]

byte x+0x1FF：正常为00，undo区结束

byte x+0x208 到 x+0x209: 不稳定字符 [输入区第409到410byte] (占2bytes)

变量(0x40 - 0x4F)：若变量字符编码为 n，则其地址范围为 x+0x20A+(n-0x40)\*0xA 到 x+0x213+(n-0x40)\*0xA

byte x+0x20A 到 x+0x213: 变量M 0x40 (长度10bytes)

byte x+0x214 到 x+0x21D: 变量Ans 0x41 (长度10bytes)

byte x+0x21E 到 x+0x227: 变量A 0x42 (长度10bytes)

byte x+0x228 到 x+0x231: 变量B 0x43 (长度10bytes)

byte x+0x232 到 x+0x23B: 变量C 0x44 (长度10bytes)

byte x+0x23C 到 x+0x245: 变量D 0x45 (长度10bytes)

byte x+0x246 到 x+0x24F: 变量E 0x46 (长度10bytes)

byte x+0x250 到 x+0x259: 变量F 0x47 (长度10bytes)

byte x+0x25A 到 x+0x263: 变量x 0x48 (长度10bytes)

byte x+0x264 到 x+0x26D: 变量y 0x49 (长度10bytes)

byte x+0x26E 到 x+0x277: 变量PreAns 0x4A (长度10bytes)

byte x+0x278 到 x+0x281: 变量@ 0x4B (长度10bytes)

byte x+0x282 到 x+0x411：历史记录 长度400bytes （每一条都会以0x23即冒号结尾）

​      byte x+0x282 到 x+0x28B: 变量@ 0x4C (长度10bytes)

​      byte x+0x28C 到 x+0x295: 变量@ 0x4D (长度10bytes)

​      byte x+0x296 到 x+0x29F: 变量@ 0x4E (长度10bytes)

​      byte x+0x2A0 到 x+0x2A9: 变量@ 0x4F (长度10bytes)

byte x+0xAF2 到 x+0xAFB: 变量$ 0x24 长度10bytes

#### lbf转换器原理

lbf/in^2->kPa 的代码是 0xFE 0x23

冒号代码是 0x23

历史记录中冒号会去掉，于是只剩下 0xFE

#### 常见字符

|              字符              |        代码         |
| :----------------------------: | :-----------------: |
|           lbf转换器            |        0xFE         |
|             PreAns             |        0x4A         |
|        t..E 这串乱码是         |      0xFE 0xFD      |
|             Unknow             |      0xFE 0xFE      |
|              Ran#              |      0xFD 0x18      |
|         闪屏爆机用的@          |        0x18         |
|               框               |        0x19         |
| 能刷任意字符的@ (lbf+shift748) |        0x4D         |
|  能刷出3/0的@ (lbf+shift714)   |        0x4F         |
|               $                |        0x24         |
|              0-9               |      0x30-0x39      |
|          十六进制A-F           |      0x3A-0x3F      |
|               an               |      0xFD 0x20      |
|               r                |      0xFD 0x13      |
|            循环小数            |        0x2F         |
|        循环小数（数学）        | 0x2F 0x1A 0x19 0x1B |
|         数学源码中的@          |     0x1A - 0x1F     |

#### 字符表

##### 单字符

![991单字节字符表](.\991单字节字符表.jpg)

##### FE 开头的双字节字符

![991FE字符表](.\991FE字符表.jpg)

##### FD 开头的双字节字符

![991FD字符表](.\991FD字符表.jpg)

##### FA 开头的双字节字符

![991FA字符表](.\991FA字符表.jpg)

##### FB 开头的双字节字符

![991FB字符表](.\991FB字符表.jpg)
