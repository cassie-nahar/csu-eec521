# Define our host system
SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_PROCESSOR arm)
SET(CMAKE_SYSTEM_VERSION 1)

SET(TOOL_PREFIX "/usr/bin/arm-linux-gnueabihf-")

# Define the cross compiler locations
SET(CMAKE_C_COMPILER            "${TOOL_PREFIX}gcc")
SET(CMAKE_CXX_COMPILER          "${TOOL_PREFIX}g++")
SET(CMAKE_LINKER                "${TOOL_PREFIX}ld")
SET(CMAKE_ASM_COMPILER          "${TOOL_PREFIX}as")
SET(CMAKE_STRIP                 "${TOOL_PREFIX}strip")
SET(CMAKE_NM                    "${TOOL_PREFIX}nm")
SET(CMAKE_AR                    "${TOOL_PREFIX}ar")
SET(CMAKE_OBJDUMP               "${TOOL_PREFIX}objdump")
SET(CMAKE_OBJCOPY               "${TOOL_PREFIX}objcopy")

SET(CMAKE_PREFIX_PATH "/")
