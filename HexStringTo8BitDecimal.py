H= "2100 0016 0006 9a0e fff3 0000 0000 0dca1580 c336 800e ff05 ca46 8000 0000 00000000 0000 0000 0000 0000 0000 0000 00000000 0000 0000 dbfe e640 5f7a 2f53 a3ca0a80 23c3 0e80 2260 eafb c9"

H1=H.replace(" ", "")
print (H1)
print ("Bytes from 0")
print(int (len(H1)/2)-1)
print (" ")


for i in range(0, len(H1), 2):
    op= H1[i:i+2]
    print (int(op, 16))    
