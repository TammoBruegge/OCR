boxes = 100

a = 2.0 # Die Parameter verändern die Anzahl der Schritte, jedoch ist kein klares Muster zu erkennen
b = 3.0 
g = 1.0 
d = 3.0
l = 1.0
m = 1.0

e = 10**-4

#kappa = 0.1 # 14043 Schritte normale Euler und 14044 Schritte improved Euler
#kappa = 0.01 # 14422 Schritte normale Euler und 14423 Schritte improved Euler
#kappa = 0.001 # 16026 Schritte normale Euler und 16028 Schritte improved Euler
kappa = 0.0001 # 18184 Schritte normale Euler und 18185 Schritte improved Euler

h = 1 / boxes

delta_t =  0.0005 # Schrittgröße