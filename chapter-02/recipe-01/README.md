### 断点概述

断点就像程序中的绊网：在程序中的特定“位置”设置断点，当到达那一点时，调试器会暂停程序的执行
（在GDB中，会出现命令行提示符）。

GDB中关于“位置”的含义是非常灵活的，它可以指各种源代码行、代码地址、源代码文件中的行号或者函数的入口等。

你可以用break命令(带变量) 来设置断点，例如：

```
(gdb) list
42	    cout << '\n';
43	
44	    ostream_iterator<int> oit_comma {cout, ", "};
45	
46	    for (int i : v) { *oit_comma = i; }
47	    cout << '\n';
48	
49	    copy(begin(v), end(v), oit);
50	    cout << '\n';
51	
(gdb) b 49
Breakpoint 1 at 0x232e: file ostream_printing.cpp, line 49.
(gdb) run
Starting program: /data/git/Cpp17.STL.Cookbook/chapter-07/ostream_printing 
12345
1, 2, 3, 4, 5, 

Breakpoint 1, main () at ostream_printing.cpp:49
49	    copy(begin(v), end(v), oit);
(gdb) 
```

很多人以为GDB显示的是最后执行的代码行，而事实上，
它显示的是将要执行的代码行。

### 跟踪断点

程序员创建的每个断点（包括断点、监视点和捕获点）都被标识为从1开始的唯一整数标识符。
这个标识符用来执行该断点上的各种操作。
调试器还包括一种列出所有断点及其属性的方式。

1. GDB中的断点列表
    当创建断点时，GDB会告知你分配给该断点的编号。例如：
    ```
    (gdb) break main
    Breakpoint 2 at 0x2018: file trie.cpp, line 65.
    ```
    如果忘记了分配给哪个断点的编号是什么，可以使用info breakpoints命令来提示，例如：
    ```
    (gdb) info breakpoints 
    Num     Type           Disp Enb Address            What
    1       breakpoint     keep y   0x0000000000003223 in trie<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >::subtrie<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const*>(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const*) const at trie.cpp:51
    2       breakpoint     keep y   0x0000000000002018 in main() at trie.cpp:65
    ```
    通过使用delete命令以及断点标识符，可以删除断点（监视点和捕获点），例如：
    ```
    (gdb) delete 2
    ```

### 设置断点

1. 在GDB中设置断点
    GDB中有许多指定断点的方式，下面是一些最常见的方式。
    - `break function`
        在函数`function()`的入口（第一行可执行代码）处设置断点。例如：
        ```
        (gdb) break main
        ```
        在main()的入口处设置断点。
    - `break line_number`
        在当前活动源代码文件的`line_number`处设置断点。例如：
        ```
        (gdb) break 51
        Breakpoint 1 at 0x3223: file trie.cpp, line 51.
        ```
        在文件trie.cpp中的第51行处设置了一个断点。
    - `break filename:line_number`
        在源代码文件`filename`的`line_number`处设置断点。如果`filename`不在当前工作目录中，
        则可以给出相对路径名或者完全路径名来帮助GDB查找该文件，例如：
        ```
        (gdb) break source/bed.c:35
        ```
    - `break filename:function`
        在文件`filename`中的函数`function`的入口处设置断点。重载函数或者使用同名静态的程序可能需要这种形式，例如：
        ```
        (gdb) break bed.c:parseArguments
        ```

    当设置一个断点时，该断点的有效性会持续到删除、禁用或退出GDB时。
    然而，`临时断点`是首次到达后就会被自动删除的断点。临时断点使用`tbreak`命令，它与break采用相同类型的参数。例如，
    `tbreak foo.c:10`在文件foo.c的第10行处设置临时断点。

    在任何给定时间，GDB都有一个焦点，可以将它看作当前“活动”文件。
    这意味着除非对命令做了限定，否则都是在GDB的焦点的文件上执行命令。默认情况下，
    具有GDB的初始焦点的文件是包含main()函数的文件，但是当发生如下任一动作时，
    焦点会转移到不同的文件上。
    - 向不同的源文件应用list命令。
    - 进入位于不同的源代码文件中的代码。
    - 当在不同的源代码文件中执行代码时GDB遇到断点。

### 删除断点

1. 在GDB中删除断点
    在GDB中有两个用来删除断点的命令。delete命令用来基于标识符删除断点，clear使用与创建断点相同的语法删除断点。
    - `delete breakpoint_list`
        删除断点使用数值标识符。断点可以是一个数字，比如`delete 2`删除第二个断点；
        也可以是数字列表，比如`delete 2 4`删除第二个和第四个断点。
    - `delete`
        删除所有断点。
    - `clear`
        清除GDB将执行的下一个指令处的断点。这种方法试用于要删除GDB已经到达的断点的情况。
    - `clear function`、`clear filename:function`、`clear line_number`和`clear filename:line_number`
        这些命令根据位置清除断点，工作方式与对应的break命令相似。

    例如，假设使用如下命令在foo()的入口设置断点。
    ```
    (gdb) break foo
    Breakpoint 2 at 0x804843a: file test.c, line22.
    ```
    可以用来删除该断点的代码为：
    ```
    (gdb) clear foo
    Deleted breakpoint 2
    ```
    或者
    ```
    (gdb) delete 2
    Deleted breakpoint 2
    ```

### 禁用断点

1. 在GDB中禁用断点
    只有当GDB遇到启用的断点时，才会暂停程序的执行；它会忽略禁用的断点。默认情况下，断点的生命期从启动时开始。

    使用`disable breakpoint-list`命令禁用断点，使用`enable break-list`命令启用断点，
    其中`breakpoint-list`是使用空格分隔的列表，其中有一个或多个断点标识符。例如，
    ```
    (gdb) disable 3
    ```
    将禁用第三个断点。类似地，
    ```
    (gdb) enable 1 5
    ```
    将启用第一个和第五个断点。

    不带任何参数地执行`disable`命令将禁用所有现有断点。类似地，不带参数的执行`enable`命令会启用所有现有断点。

    还有一个`enable once`命令，在断点下次引起GDB暂停执行后被禁用。语法为：
    ```
    enable once breakpoint-list
    ```
    例如，`enable once 3`会使得断点3在下次导致GDB停止程序的执行后被禁用。这个命令与`tbreak`命令非常类似，
    但是当遇到断点时，它是禁用断点，而不是删除断点。

