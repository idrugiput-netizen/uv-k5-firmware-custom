import os
import re

# Folder sa .c fajlovima
APP_DIR = "./App"

# Regex za pronalazak poziva EEPROM_WriteBuffer sa 2 argumenta
pattern = re.compile(r'(EEPROM_WriteBuffer\s*\(\s*([^,]+)\s*,\s*([^)]+)\s*\))')

def process_file(filepath):
    with open(filepath, "r") as f:
        lines = f.readlines()

    new_lines = []
    changed = False

    for line in lines:
        match = pattern.search(line)
        if match:
            full_call = match.group(1)
            addr = match.group(2).strip()
            ptr = match.group(3).strip()
            # Novi poziv sa sizeof()
            new_call = f"EEPROM_WriteBuffer({addr}, {ptr}, sizeof({ptr}))"
            new_line = line.replace(full_call, new_call)
            new_lines.append(new_line)
            changed = True
        else:
            new_lines.append(line)

    if changed:
        print(f"[+] Patched: {filepath}")
        with open(filepath, "w") as f:
            f.writelines(new_lines)

def main():
    for root, dirs, files in os.walk(APP_DIR):
        for file in files:
            if file.endswith(".c"):
                process_file(os.path.join(root, file))

if __name__ == "__main__":
    main()
