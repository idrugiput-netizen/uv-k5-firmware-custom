#!/bin/bash

# Provera da li je unet preset kao argument
if [ -z "$1" ]; then
    echo "Usage: ./build_each_safe.sh <PresetName>"
    echo "Example: ./build_each_safe.sh Basic"
    exit 1
fi

PRESET="$1"
BUILD_DIR="build/$PRESET"

echo "=========================="
echo "Building $PRESET firmware..."
echo "=========================="

# Provera da li postoji build folder za preset
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: $BUILD_DIR is not a directory"
    exit 1
fi

# Pokretanje build-a
if cmake --build --preset "$PRESET"; then
    echo "$PRESET build successful."
else
    echo "$PRESET build FAILED!"
    exit 1
fi

# Provera da li ELF fajl postoji
ELF_FILE="$BUILD_DIR/f4hwn.$PRESET.elf"
if [ ! -f "$ELF_FILE" ]; then
    echo "ELF file not found, skipping pack."
    exit 1
fi

# Pack-ovanje bin fajla
BIN_FILE="$BUILD_DIR/f4hwn.$PRESET.bin"
PACKED_FILE="$BUILD_DIR/f4hwn.$PRESET.packed.bin"

cd "$BUILD_DIR" || exit

# Konverzija u bin i hex
arm-none-eabi-objcopy -O binary "$ELF_FILE" "$BIN_FILE"
arm-none-eabi-objcopy -O ihex "$ELF_FILE" "f4hwn.$PRESET.hex"

# Pack sa fw-pack.py
python /workspaces/uv-k5-firmware-custom/fw-pack.py "$BIN_FILE" F4HWN v4.2 "$PACKED_FILE"

echo "$PRESET packing done."
