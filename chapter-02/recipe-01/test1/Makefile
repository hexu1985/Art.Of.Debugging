RM = rm -f
CC = gcc
INCLUDE = 
CFLAGS = -Wall -g

PROGS =	test1

all:	${PROGS}

test1:	test1.o 
		${CC} ${CFLAGS} -o $@ $^

clean:
		rm -f ${PROGS} *.o
