ROOT_DIR=$(shell pwd)
BUILD?=$(ROOT_DIR)/build
INCLUDE_DIR:=$(ROOT_DIR)/include
SRC_DIR:=$(ROOT_DIR)/src
Target_ELF:=$(ROOT_DIR)/test
CC = gcc
CFLAGS = -Wall -O3 
CFLAGS += -I $(INCLUDE_DIR)
LD = ld
LDFLAGS :=

DEFAULT	?=false	#debug means use the glibc malloc
ifeq ($(DEFAULT),true)
	CFLAGS += -D DEFAULT
endif

export ROOT_DIR BUILD INCLUDE_DIR CC CFLAGS
all: $(Target_ELF)
	@echo ${CFLAGS}

.PHONY:all

init:
	@echo "DIR	BUILD"
	@$(shell if [ ! -d $(BUILD) ];then mkdir $(BUILD); fi)

build: init
	@echo "BD"
	@$(MAKE) -C $(SRC_DIR) all

$(Target_ELF): build
	@echo "LD	" $(Target_ELF)
	@${CC} -o $@ $(shell find $(BUILD) -name *.o)

fmt:
	@find . -name '*.c' -print0 | xargs -0 clang-format -i -style=file
	@find . -name '*.h' -print0 | xargs -0 clang-format -i -style=file

clean:
	@echo "RM	OBJS"
	@-rm -rf $(BUILD)
	@-rm -f $(shell find $(BUILD) -name *.o)
