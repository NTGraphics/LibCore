################################################################################
GCC_PREFIX  ?=
GCC_SUFFIX  ?=
COMPILER    := $(GCC_PREFIX)g++$(GCC_SUFFIX)
ALL_CCFLAGS := -g -W -O3 -lstdc++fs
ALL_CCFLAGS += -std=c++17
ALL_CCFLAGS += $(FLAG_FLTO)

################################################################################
ROOT_PATH := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

INCLUDES += -I$(ROOT_PATH)/
INCLUDES += -I$(ROOT_PATH)/Externals/glm
INCLUDES += -I$(ROOT_PATH)/Externals/json/single_include/nlohmann
INCLUDES += -I$(ROOT_PATH)/Externals/spdlog/include
INCLUDES += -I$(ROOT_PATH)/Externals/tinyobjloader
INCLUDES += -I$(ROOT_PATH)/Externals/tbb_linux/include

################################################################################
OUTPUT_DIR := ../../Build/Linux
OBJ_DIR    := ../../Build/Linux/OBJS
LIB_NAME   := libLibCommon.a

LIB_SRC     := $(shell find $(ROOT_PATH)/LibCommon -name *.cpp)
LIB_OBJ     := $(patsubst %.cpp, %.o, $(LIB_SRC))
COMPILE_OBJ := $(patsubst $(ROOT_PATH)/%, $(OBJ_DIR)/%, $(LIB_OBJ))
COMPILE_OBJ_SUBDIR := $(patsubst $(ROOT_PATH)/%, $(OBJ_DIR)/%, $(dir $(LIB_OBJ)))
COMPILE_OBJ_SUBDIR += $(OBJ_DIR)/LibCommon/Externals/tinyobjloader

################################################################################
all: create_out_dir $(COMPILE_OBJ) $(OBJ_DIR)/LibCommon/Externals/tinyobjloader/tiny_obj_loader.o
	$(GCC_PREFIX)gcc-ar$(GCC_SUFFIX) -rsv $(OUTPUT_DIR)/$(LIB_NAME) $(COMPILE_OBJ) $(OBJ_DIR)/LibCommon/Externals/tinyobjloader/tiny_obj_loader.o
	$(GCC_PREFIX)gcc-ranlib$(GCC_SUFFIX) $(OUTPUT_DIR)/$(LIB_NAME)

create_out_dir:
	mkdir -p $(OUTPUT_DIR)
	mkdir -p $(OBJ_DIR)
	mkdir -p $(COMPILE_OBJ_SUBDIR)

$(OBJ_DIR)/LibCommon/Externals/tinyobjloader/tiny_obj_loader.o: $(ROOT_PATH)/Externals/tinyobjloader/tiny_obj_loader.cc
	$(COMPILER) $(INCLUDES) $(ALL_CCFLAGS) -c $< -o $@

$(COMPILE_OBJ): $(OBJ_DIR)/%.o: $(ROOT_PATH)/%.cpp
	$(COMPILER) $(INCLUDES) $(ALL_CCFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR)/LibCommon
	rm -rf $(OBJ_DIR)/Externals/tinyobjloader
	rm $(OUTPUT_DIR)/$(LIB_NAME)
