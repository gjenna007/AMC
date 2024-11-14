import struct
def giveDimensions (image):
    with open(image,"rb") as f:
        signature=f.read(2)
        if signature != b'BM':
            raise RuntimeError("Bestand heeft geen geldige BMP-indeling")
        else:
            f.seek(16,1)
            widthstring=f.read(4)
            width=struct.unpack('<L',widthstring)[0]
            heightstring=f.read(4)
            height=struct.unpack('<L',heightstring)[0]
    return (width, height)

a=giveDimensions("loi_logo.bmp")
print(a)