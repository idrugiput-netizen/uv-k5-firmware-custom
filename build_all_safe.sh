#!/bin/bash

# Lista svih build preset-a
PRESETS=("Basic" "Game" "RescueOps" "Broadcast" "Bandscope" "Custom")

# Verzija firmware
FW_VERSION="v4.2"

# Petlja kroz sve preset-e
for preset in "${PRESETS[@]}"; do
    echo "=========================="
    echo "Building $preset firmware..."
    echo "=========================="

    # Provera da li build direktorijum postoji, ako ne, kreira ga
    BUILD_DIR="build/$preset"
    if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p "$BUILD_DIR"
    fi

    # Kompajliranje
    if cmake --build --preset $preset; then
        echo "$preset build successful."
    else
        echo "$preset build FAILED!"
        echo "Skipping pack for $preset."
        continue
    fi

    # Provera FLASH memorije (na osnovu .map fajla)
    MAP_FILE="$BUILD_DIR/${preset}.map"
    OVERFLOW=$(grep "FLASH" "$MAP_FILE" | awk '{print $4}' | grep -o '[0-9]\+')
    REGION=$(grep "FLASH" "$MAP_FILE" | awk '{print $3}' | grep -o '[0-9]\+')
    if [ ! -z "$OVERFLOW" ] && [ "$OVERFLOW" -gt "$REGION" ]; then
        echo "WARNING: $preset firmware exceeds FLASH size by $((OVERFLOW-REGION)) bytes. Skipping pack."
        continue
    fi

    # Pack-ovanje bin fajla
    BIN_FILE="$BUILD_DIR/${preset}.bin"
    PACKED_FILE="$BUILD_DIR/${preset}.packed.bin"

    if [ -f "$BIN_FILE" ]; then
        python fw-pack.py "$BIN_FILE" F4HWN "$FW_VERSION" "$PACKED_FILE"
        echo "$preset packed successfully."
    else
        echo "Binary $BIN_FILE not found, skipping pack."
    fi
done

echo "All builds done."
