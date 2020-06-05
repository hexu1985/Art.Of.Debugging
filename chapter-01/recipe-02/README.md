### 初涉调试会话(二)

#### GDB方法

删除断点。要做到这一点，需要给出断点的行号。或者用GDB的info break命令来查找。
然后用clear命令删除断点。例如：
```
(gdb) info break
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x0000555555554761 in insert at insert_sort.c:30
(gdb) clear 30
已删除的断点 2
(gdb) info break
No breakpoints or watchpoints.
```

