#!/bin/bash

# Lista svih build preset-a
PRESETS=("Basic" "Game" "RescueOps" "Broadcast" "Bandscope" "Custom")

# Petlja kroz sve preset-e
for preset in "${PRESETS[@]}"; do
    echo "=========================="
    echo "Preparing $preset firmware..."
    echo "=========================="

    # Prvo konfiguracija (napravi build folder)
    if cmake --preset $preset; then
        echo "$preset configuration done."
    else
        echo "$preset configuration FAILED!"
        continue
    fi

    # Kompajliranje
    echo "=========================="
    echo "Building $preset firmware..."
    echo "=========================="
    if cmake --build --preset $preset; then
        echo "$preset build successful."
    else
        echo "$preset build FAILED!"
        continue
    fi

    # Pack-ovanje bin fajla
    BIN_FILE="build/$preset/${preset}.bin"
    PACKED_FILE="build/$preset/${preset}.packed.bin"

    if [ -f "$BIN_FILE" ]; then
        python fw-pack.py "$BIN_FILE" F4HWN v4.2 "$PACKED_FILE"
        echo "$preset packed successfully."
    else
        echo "Binary $BIN_FILE not found, skipping pack."
    fi
done

echo "All builds done."
