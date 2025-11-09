#include <stddef.h>
#include <string.h>

#include "driver/eeprom.h"
#include "driver/i2c.h"
#include "driver/system.h"

void EEPROM_ReadBuffer(uint32_t Address, void *pBuffer, uint16_t Size)
{
    if (pBuffer == NULL || Address + Size > EEPROM_MAX_ADDRESS)
        return;

    I2C_Start();
    I2C_Write(0xA0);  // Write mode za adresu

    // 16-bitna adresa za M24M02
    I2C_Write((Address >> 8) & 0xFF);  // MSB
    I2C_Write(Address & 0xFF);         // LSB

    I2C_Start();
    I2C_Write(0xA1);  // Read mode
    I2C_ReadBuffer(pBuffer, Size);
    I2C_Stop();
}

void EEPROM_WriteBuffer(uint32_t Address, const void *pBuffer, uint16_t Size)
{
    if (pBuffer == NULL || Address + Size > EEPROM_MAX_ADDRESS)
        return;

    uint8_t buffer[32];  // Uporedi postojeće podatke da se izbegne nepotreban upis
    uint16_t chunkSize = (Size > 32) ? 32 : Size;

    for (uint16_t offset = 0; offset < Size; offset += chunkSize) {
        uint16_t currentSize = (Size - offset > chunkSize) ? chunkSize : (Size - offset);
        EEPROM_ReadBuffer(Address + offset, buffer, currentSize);
        if (memcmp((uint8_t*)pBuffer + offset, buffer, currentSize) == 0)
            continue;

        I2C_Start();
        I2C_Write(0xA0);
        I2C_Write(((Address + offset) >> 8) & 0xFF);
        I2C_Write((Address + offset) & 0xFF);
        I2C_WriteBuffer((uint8_t*)pBuffer + offset, currentSize);
        I2C_Stop();

        SYSTEM_DelayMs(8);
    }
}
