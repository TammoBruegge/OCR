"""
# Gegebene Parameter
alpha = 0.3  # Albedoeffekt
e = 0.62  # Emissitivität
y0 = 23 # Startwert

t0 = 0
T = 450000000
n = 450000
"""

# Gegebene Konstanten, welche nicht vom Nutzer verändert werden sollen.
C = 9.96 * (10 ** 6)  # thermal coupling constant
phi = 5.67 * (10 ** -8)  # Boltzmannn constant
S = 1367.0  # solar constant


# Ausführen eines Schrittes des Energy-Balance-Modells
# Hierbei ist y_k ein Array der Größe 1, welches nur die Temperatur zum vorherigen Zeitpunkt enthält, und Parameters ein Array der Größe 2
# Am Ende wird ein eindimensionales Result-Array erstellt, welches die  Temperatur zum nächsten Zeitpunkt enthält
def dt(y_k, parameters):
    y = y_k[0]
    alpha = parameters[0]
    e = parameters[1]
    c1 = 1 / (4 * C)  # Berechnen von c1 und c2 nach vorgegebenen Regeln.
    c2 = (phi * e) / C
    return [c1 * S * (1 - alpha) - c2 * (y ** 4)] # Berechnen der Ableitung nach vorgegebener Art.