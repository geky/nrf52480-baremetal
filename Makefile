TARGET = main.elf

CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
AR = $(CROSS_COMPILE)ar
SIZE = $(CROSS_COMPILE)size
GDB = $(CROSS_COMPILE)gdb
GDBADDR = localhost
GDBPORT = 3333
TTY = $(firstword $(wildcard /dev/ttyACM* /dev/ttyUSB*))
BAUD = 115200

SRC += $(wildcard *.c *.s *.S)
SRC += $(wildcard nrfx/drivers/src/*.c)

INC += .
INC += cmsis/CMSIS/Core/Include
INC += nrfx
INC += nrfx/drivers/include
INC += nrfx/mdk # close enough to GCC
INC += nrfx/templates # use as is

LIB += m
LIB += c
LIB += gcc
LIB += nosys

LDSCRIPT += $(wildcard *.ld)

OBJ += $(patsubst %.S,%.o,$(patsubst %.s,%.o,$(patsubst %.c,%.o,$(SRC))))
DEP += $(patsubst %.o,%.d,$(OBJ))

ifdef DEBUG
override CFLAGS += -DDEBUG
override CFLAGS += -g
override CFLAGS += -O0
else
# -DNDEBUG disables asserts which usually isn't what we want
#override CFLAGS += -DNDEBUG
override CFLAGS += -Os
override CFLAGS += -flto
endif
override CFLAGS += -DNRF52840_XXAA
override CFLAGS += -DNRFX_CLOCK_ENABLED=1
override CFLAGS += -DNRFX_UARTE_ENABLED=1
override CFLAGS += -DNRFX_UARTE0_ENABLED=1
override CFLAGS += -mthumb
override CFLAGS += -mcpu=cortex-m4
override CFLAGS += -mfpu=fpv4-sp-d16
override CFLAGS += -mfloat-abi=softfp
override CFLAGS += -std=c99
override CFLAGS += -Wall -Wno-format
override CFLAGS += -fno-common
override CFLAGS += -ffunction-sections
override CFLAGS += -fdata-sections
override CFLAGS += -ffreestanding
override CFLAGS += -fno-builtin
override CFLAGS += -MMD -MP
override CFLAGS += $(patsubst %,-I%,$(INC))

override ASMFLAGS += $(CFLAGS)

override LFLAGS += $(CFLAGS)
override LFLAGS += -T$(LDSCRIPT)
override LFLAGS += -static
override LFLAGS += --specs=nano.specs
override LFLAGS += --specs=nosys.specs
override LFLAGS += -Wl,--gc-sections
override LFLAGS += -Wl,-static
override LFLAGS += -Wl,-z -Wl,muldefs
override LFLAGS += -Wl,--start-group $(patsubst %,-l%,$(LIB)) -Wl,--end-group

.PHONY: all build
all build: $(TARGET)

.PHONY: size
size: $(TARGET)
	$(SIZE) $<

.PHONY: debug
debug: $(TARGET)
	echo '$$qRcmd,68616c74#fc' | nc -N $(GDBADDR) $(GDBPORT) && echo # halt
	$(GDB) $< -ex "target remote $(GDBADDR):$(GDBPORT)"
	echo '$$qRcmd,676f#2c' | nc -N $(GDBADDR) $(GDBPORT) && echo # go

.PHONY: flash
flash: $(TARGET)
	echo '$$qRcmd,68616c74#fc' | nc -N $(GDBADDR) $(GDBPORT) && echo # halt
	$(GDB) $< -ex "target remote $(GDBADDR):$(GDBPORT)" \
		-ex "load" \
		-ex "monitor reset" \
		-batch

.PHONY: reset
reset:
	echo '$$qRcmd,7265736574#37' | nc -N $(GDBADDR) $(GDBPORT) && echo # reset
	echo '$$qRcmd,676f#2c' | nc -N $(GDBADDR) $(GDBPORT) && echo # go

.PHONY: cat
cat:
	stty -F $(TTY) sane nl $(BAUD)
	cat $(TTY)

.PHONY: tags
tags:
	ctags $(SRC) $$(find $(INC) -name '*.h')

-include $(DEP)

$(TARGET): $(OBJ) $(LDSCRIPT)
	$(CC) $(OBJ) $(LFLAGS) -o $@

%.o: %.c
	$(CC) -c -MMD $(CFLAGS) $< -o $@

%.s: %.c
	$(CC) -S -MMD $(CFLAGS) $< -o $@

%.o: %.s
	$(CC) -c -MMD $(ASMFLAGS) $< -o $@

%.o: %.S
	$(CC) -c -MMD $(ASMFLAGS) $< -o $@

clean:
	rm -f $(TARGET)
	rm -f $(OBJ)
	rm -f $(DEP)
