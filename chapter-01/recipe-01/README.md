### 初涉调试会话(一)

#### GDB方法

首先，启动GDB调试器，例子如下：
```shell
$ gdb insert_ort -tui
```

如果在调用GDB时没有请求TUI（Terminal User Interface，终端用户界面）模式，那么只会收到欢迎消息和GDB提示符，不会出现程序源代码子窗口。
可以用GDB的命令<kbd>Ctrl</kbd>+<kbd>X</kbd>+<kbd>A</kbd>组合键进入TUI模式。
这个命令用来打开或关闭TUI模式。

然后，从GDB中执行run命令以及程序的命令行参数来运行程序，然后按<kbd>Ctrl</kbd>+<kbd>C</kbd>组合键挂起它，例如：
```
(gdb) run 5 12
Starting program: /home/hexu/git/Art.Of.Debugging/chapter-01/recipe-01/c-example/insert_sort 5 12
^C

Program received signal SIGINT, Interrupt.
process_data () at insert_sort.c:52
```

打印指定变量值可以通过print命令完成，例如：
```
(gdb) print num_y
$1 = 1
```
对GDB的这一查询的输出表明num_y的值为1。`$1`标签意味着这是你要求GDB输出的第一个值。
(`$1`、`$2`、`$3`等表示的值统称为调试会话的值历史)。

我们可以通过break命名设置断点，例如：
```
(gdb) break 30
Breakpoint 1 at 0x555555554761: file insert_sort.c, line 30.
```
该命令在当前源文件的30行设置断点。

我们也可以用break指令后跟函数名的方式设置断点，例如：
```
(gdb) break insert
Breakpoint 1 at 0x555555554761: insert. (3 locations)
```
该命令指定在insert()的第一行处中断。

break命令一般会使得每次程序执行到指定行时都会暂停。 然而，我们可以使用condition命令设置条件断点，例如：
```
(gdb) condition 1 num_y==1
```
该命令把breakpoint 1设置成条件断点，只有当满足条件num_y==1的时候，GDB才会暂停程序的执行。

注意，与接受行号（或函数名）的break命令不同，condition接受断点号。

总是可以用命令info break来查询要查找的断点的编号。

用break if可以将break和condition命令组合成一个步骤，如下所示。
```
(gdb) break 30 if num_y==1
```

使用run命令可以再次运行程序。如果要重用老的命令行参数，就不必再次指定命令行参数。

我们可以通过next命令单步调试程序，例如：
```
(gdb) next
```

