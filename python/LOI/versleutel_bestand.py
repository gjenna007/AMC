def flip_bits(a):
    b=b'\xFF'
    c=int.from_bytes(a,'big')^int.from_bytes(b,'big')
    return c.to_bytes(len(a),'big')

def versleutel_bestand(orig,beeld):
    with open(orig,"rb") as f:
        with open(beeld,'wb') as g:
            volgende_blok=f.read(1)
            while not (volgende_blok == b''):
                reversed_blok=flip_bits(volgende_blok)
                g.write(reversed_blok)
                volgende_blok=f.read(1)
    return
        
versleutel_bestand('loi_logo.bmp','reversed_logo.bmp')    
        