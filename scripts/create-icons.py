"""Render the code-native FunGuy mushroom mark; no external image dependencies."""
import struct
import zlib
from pathlib import Path


def icon(size):
    pixels = bytearray()
    for row in range(size):
        pixels.append(0)
        for col in range(size):
            x, y = (col + .5) / size, (row + .5) / size
            color = (23, 61, 54)
            if .43 < x < .57 and .42 < y < .77:
                color = (242, 223, 181)
            if ((x - .5) / .135) ** 2 + ((y - .76) / .045) ** 2 < 1:
                color = (242, 223, 181)
            if ((x - .5) / .30) ** 2 + ((y - .45) / .24) ** 2 < 1 and y < .49:
                color = (215, 109, 78)
                for sx, sy, radius in [(.36, .35, .035), (.53, .28, .03), (.65, .39, .038)]:
                    if (x - sx) ** 2 + (y - sy) ** 2 < radius ** 2:
                        color = (247, 232, 207)
            if ((x - .5) / .30) ** 2 + ((y - .49) / .035) ** 2 < 1:
                color = (237, 189, 141)
            pixels.extend(color)
    def chunk(kind, data):
        return struct.pack('>I', len(data)) + kind + data + struct.pack('>I', zlib.crc32(kind + data))
    return b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', size, size, 8, 2, 0, 0, 0)) + chunk(b'IDAT', zlib.compress(pixels, 9)) + chunk(b'IEND', b'')

for dimension in (192, 512):
    for variant in ('Icon-', 'Icon-maskable-'):
        Path(f'web/icons/{variant}{dimension}.png').write_bytes(icon(dimension))
Path('web/favicon.png').write_bytes(icon(64))
