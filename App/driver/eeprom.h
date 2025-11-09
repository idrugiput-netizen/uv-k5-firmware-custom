/* Copyright 2023 Dual Tachyon
 * https://github.com/DualTachyon
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

#ifndef DRIVER_EEPROM_H
#define DRIVER_EEPROM_H

#include <stdint.h>

#define EEPROM_MAX_ADDRESS 0x40000  // 256 KB

// Funkcije za čitanje/pisanje EEPROM-a
void EEPROM_ReadBuffer(uint32_t Address, void *pBuffer, uint16_t Size);
void EEPROM_WriteBuffer(uint32_t Address, const void *pBuffer, uint16_t Size);

#endif
