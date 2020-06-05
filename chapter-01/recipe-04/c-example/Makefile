RM = rm -f
CC = gcc
INCLUDE = 
CFLAGS = -Wall -g

PROGS =	insert_sort

all:	${PROGS}

insert_sort:	insert_sort.o 
		${CC} ${CFLAGS} -o $@ $^

clean:
		rm -f ${PROGS} *.o
