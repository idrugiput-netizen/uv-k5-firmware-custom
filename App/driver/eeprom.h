#ifndef DRIVER_EEPROM_H
#define DRIVER_EEPROM_H

#include <stdint.h>

#define EEPROM_MAX_ADDRESS 0x40000  // 256 KB

// EEPROM mapa adresa
#define EEPROM_BOOTLOADER_START   0x00000
#define EEPROM_BOOTLOADER_END     0x00FFF   // 4 KB

#define EEPROM_CHANNELS_START     0x01000
#define EEPROM_CHANNELS_END       0x03FFF   // 12 KB (512 kanala x 24 B)

#define EEPROM_SETTINGS_START     0x04000
#define EEPROM_SETTINGS_END       0x04FFF   // 4 KB

#define EEPROM_LOGS_START         0x05000
#define EEPROM_LOGS_END           0x07FFF   // 12 KB

#define EEPROM_RESERVED_START     0x08000
#define EEPROM_RESERVED_END       0x3FFFF   // 240 KB za buduće funkcije

// Funkcije za čitanje/pisanje EEPROM-a
void EEPROM_ReadBuffer(uint32_t Address, void *pBuffer, uint16_t Size);
void EEPROM_WriteBuffer(uint32_t Address, const void *pBuffer, uint16_t Size);

#endif
