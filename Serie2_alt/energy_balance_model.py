"""
# Gegebene Parameter
alpha = 0.3  # Albedoeffekt
e = 0.62  # Emissitivität
y0 = 23 # Startwert
"""

# Gegebene Konstanten, welche nicht vom Nutzer verändert werden sollen.
C = 9.96 * (10 ** 6)  # thermal coupling constant
phi = 5.67 * (10 ** -8)  # Boltzmannn constant
S = 1367.0  # solar constant

# Userinput für nicht konstante Variablen lesen
def get_user_inputs():
    global alpha
    global e
    y0 = float(input("Enter the starting temperature: "))
    alpha = float(input("Enter the value of albedo effect: "))
    e = float(input("Enter the emissivity: "))
    return [y0]


# Die Ableitung von y nach t bilden nach den Vorgaben der Aufgabe.
def y_dt(y, parameters):
    c1 = 1 / (4 * C)  # Berechnen von c1 und c2 nach vorgegebenen Regeln.
    c2 = (phi * e) / C
    return c1 * S * (1 - alpha) - c2 * (y ** 4) # Berechnen der Ableitung nach vorgegebener Art.