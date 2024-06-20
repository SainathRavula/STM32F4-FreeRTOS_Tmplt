TARGET:=FreeRTOS

##Setting Path of the tool chain##
#vlab@HYVLAB1:~$which arm-none-eabi-gcc --> /opt/gcc-arm/bin/arm-none-eabi-gcc
TOOLCHAIN_ROOT   := /opt/gcc-arm
TOOLCHAIN_PATH   := $(TOOLCHAIN_ROOT)/bin
TOOLCHAIN_PREFIX := arm-none-eabi


##Optimization level and Debug option##
OPTLVL:= 3	#can be [0, 1, 2, 3, s].
DBG:= -g	#To include debugging information in the compiled program. 	


SRCROOT 	:= $(CURDIR)
FREERTOS	:= $(SRCROOT)/FreeRTOS
STARTUP	:= $(SRCROOT)/startup
LINKER_SCRIPT	:= $(SRCROOT)/Linker/STM32F411VETx_FLASH.ld
BUILD_DIR 	:= $(SRCROOT)/build
BIN_DIR 	:= $(SRCROOT)/binary


INCLUDE	 = -I$(SRCROOT)/hardware
INCLUDE	+= -I$(FREERTOS)/include
INCLUDE	+= -I$(FREERTOS)/portable/GCC/ARM_CM4F
INCLUDE	+= -I$(SRCROOT)/Libraries/CMSIS/Device/ST/STM32F4xx/Include
INCLUDE	+= -I$(SRCROOT)/Libraries/CMSIS/Include
INCLUDE	+= -I$(SRCROOT)/Libraries/STM32F4xx_StdPeriph_Driver/inc
INCLUDE	+= -I$(SRCROOT)/config


vpath  %.c $(SRCROOT)/Libraries/STM32F4xx_StdPeriph_Driver/src
vpath  %.c $(SRCROOT)/Libraries/syscall
vpath  %.c $(SRCROOT)/hardware
vpath  %.c $(SRCROOT)/startup
vpath  %.c $(FREERTOS)
vpath  %.c $(FREERTOS)/portable/MemMang
vpath  %.c $(FREERTOS)/portable/GCC/ARM_CM4F
vpath  %.s $(STARTUP)
#In this makefile, the vpath directive is used to specify additional directories where the make utility should search for source files. 
#However, the vpath variable itself is not printed directly because it's a special variable in makefiles that holds the search paths 
#but isn't directly accessible for printing like regular variables.


# Assembly Source Files
ASRC		:= startup_stm32f4xx.s   
# Project Source Files
SRC		 = stm32f4xx_it.c
SRC		+= system_stm32f4xx.c
SRC		+= syscalls.c
SRC		+= main.c
# FreeRTOS Source Files
SRC		+= port.c
SRC		+= list.c
SRC		+= queue.c
SRC		+= tasks.c
SRC		+= event_groups.c
SRC		+= timers.c
SRC		+= heap_4.c
# Standard Peripheral Source Files
SRC		+= stm32f4xx_rcc.c
SRC		+= stm32f4xx_gpio.c
SRC		+= misc.c
SRC		+= stm32f4xx_usart.c
#SRC		+= stm32f4xx_dcmi.c
#SRC		+= stm32f4xx_hash.c
#SRC		+= stm32f4xx_rtc.c
#SRC		+= stm32f4xx_adc.c
#SRC		+= stm32f4xx_dma.c
#SRC		+= stm32f4xx_hash_md5.c
#SRC		+= stm32f4xx_sai.c
#SRC		+= stm32f4xx_can.c
#SRC		+= stm32f4xx_dma2d.c
#SRC		+= stm32f4xx_hash_sha1.c
#SRC		+= stm32f4xx_sdio.c
#SRC		+= stm32f4xx_cec.c
#SRC		+= stm32f4xx_dsi.c
#SRC		+= stm32f4xx_i2c.c
#SRC		+= stm32f4xx_spdifrx.c
#SRC		+= stm32f4xx_crc.c
#SRC		+= stm32f4xx_exti.c
#SRC		+= stm32f4xx_iwdg.c
#SRC		+= stm32f4xx_spi.c
#SRC		+= stm32f4xx_cryp.c
#SRC		+= stm32f4xx_flash.c
#SRC		+= stm32f4xx_lptim.c
#SRC		+= stm32f4xx_syscfg.c
#SRC		+= stm32f4xx_cryp_aes.c
#SRC		+= stm32f4xx_flash_ramfunc.c
#SRC		+= stm32f4xx_ltdc.c
#SRC		+= stm32f4xx_tim.c
#SRC		+= stm32f4xx_cryp_des.c
#SRC		+= stm32f4xx_pwr.c
#SRC		+= stm32f4xx_cryp_tdes.c
#SRC		+= stm32f4xx_fmpi2c.c
#SRC		+= stm32f4xx_qspi.c
#SRC		+= stm32f4xx_wwdg.c
#SRC		+= stm32f4xx_dac.c
#SRC		+= stm32f4xx_fsmc.c
#SRC		+= stm32f4xx_dbgmcu.c
#SRC		+= stm32f4xx_rng.c


#Preprocessor Macros
CDEFS		 = -DUSE_STDPERIPH_DRIVER
CDEFS		+= -DSTM32F4XX
CDEFS		+= -DSTM32F40_41xxx


MCUFLAGS 	 = -mcpu=cortex-m4	#Specifies the target processor architecture as ARM Cortex-M4
#MCUFLAGS 	+= -mthumb		#Enables Thumb mode,  a more code-efficient instruction set for ARM processors.
MCUFLAGS 	+= -mfloat-abi=hard	#Tells the compiler to use hardware floating-point instructions and registers.
MCUFLAGS 	+= -finline-functions	#Enables function inlining optimization.Can improve performance by reducing function call overhead.
MCUFLAGS 	+= -Wdouble-promotion	#Enables a warning for implicit conversions from float to double
MCUFLAGS	+= -std=gnu99		#Specifies the C language standard to use, in this case, GNU C99.


COMMONFLAGS	:= -O$(OPTLVL) $(DBG) -Wall -ffunction-sections -fdata-sections
#-Wall: Enables a set of warning messages, known as "all" warnings.
#-ffunction-sections: Instructs the compiler to place each function into its own section in the output object file.Useful for optimizing memory usage.
#-fdata-sections: Similar to -ffunction-sections, but applies to global and static variables (data) rather than functions.


CFLAGS		:= $(COMMONFLAGS) $(MCUFLAGS) $(INCLUDE) $(CDEFS)


##Linker Libraries##
LDLIBS		 = -lc		#links C std library (libc), which provides fundamental functions and definitions required by C programs.
LDLIBS		+= -lgcc	#links GCC support lib (libgcc), which contains runtime support functions required by the GCC compiler.


##Linker Flags##
LDFLAGS 	 = $(MCUFLAGS)
LDFLAGS 	+= -fno-exceptions			#-Wl prefix passes options to the linker, Flag disables exceptions handling support.
LDFLAGS 	+= -Wl,--gc-sections			#Instructs the linker to enable garbage collection of unused sec.
LDFLAGS 	+= -T$(LINKER_SCRIPT)			#Specifies the linker script (LINKER_SCRIPT) to use during the linking process.
LDFLAGS 	+= -Wl,-Map=$(BIN_DIR)/$(TARGET).map	#Generates a mem map file ($(BIN_DIR)/$(TARGET).map) during the linking process.
#A memory map file, often generated during the linking process of compiling software, provides a detailed breakdown of how memory is utilized by the program




##Various tools of gcc-arm-none-eabi toolchain##

CC		 := $(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-gcc
#Compiler Commands responsible for compiling C source files (*.c) into object files (*.o). 
#It translates C code into machine code specific to the target architecture.

OBJCOPY 	 := $(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-objcopy
#Object File Copy Command copies object files and can be used to convert the format of object files. 
#For example, it can convert object files into binary, Intel Hex, or ELF format.

AS 		 := $(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-as
#The assembler command translates assembly source files (*.s) into object files (*.o). 
#It converts human-readable assembly language code into machine code instructions.

GDB  		 := $(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-gdb
#Debugger Command launches the GNU Debugger (GDB), a powerful tool for debugging software.



##Creating list of Object files to be generated##

OBJ 		 := $(SRC:%.c=$(BUILD_DIR)/%.o)
ASM_OBJ	 := $(ASRC:%.s=$(BUILD_DIR)/%.o)
#$(ASRC:%.s=$(BUILD_DIR)/%.o): This is a pattern substitution This syntax substitutes each filename in the variable $(ASRC) 
#with a corresponding output filename in the build directory ($(BUILD_DIR)), replacing the .s extension with .o.



##Compiling .c files to generate .o files##

#$< :- name of dependency; $@ :- name of target 
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(BUILD_DIR)
	@echo [CC] $(notdir $<)
	@$(CC) $(CFLAGS) $< -c -o $@


##Compiling .s to generate .o file, linking object files to generate .elf file and converting elf to bin and hex files##

.PHONY: all

all: $(OBJ)
	@echo [AS] $(ASRC)
	@$(AS) -o $(ASM_OBJ) $(STARTUP)/$(ASRC)
#arm-none-eabi-as -o startup_stm32f4xx.o startup_stm32f4xx.s
	
	@mkdir -p $(BIN_DIR)
	@echo [LD] $(TARGET).elf
	@$(CC) -o $(BIN_DIR)/$(TARGET).elf $(LDFLAGS) $(OBJ) $(ASM_OBJ) $(LDLIBS)
#arm-none-eabi-gcc -o FreeRTOS.elf file1.o file2.o ....
	
	@echo [HEX] $(TARGET).hex
	@$(OBJCOPY) -O ihex $(BIN_DIR)/$(TARGET).elf $(BIN_DIR)/$(TARGET).hex
	@echo [BIN] $(TARGET).bin
	@$(OBJCOPY) -O binary $(BIN_DIR)/$(TARGET).elf $(BIN_DIR)/$(TARGET).bin
#"-O" is used to specify the output format not output file name



##Removing the Object and executable files##

.PHONY: clean

clean:
	@rm -r $(BUILD_DIR)
	@echo [RM] OBJ
	@rm -r $(BIN_DIR)
	@echo [RM] BIN
	
	
##Flashing FreeRTOS.bin to STM32F411 board##

.PHONY: flash

flash:
	@st-flash write $(BIN_DIR)/$(TARGET).bin 0x8000000

