"""
# Gegebene Parameter
a = 0.6 # Reproduktionsrate der Beute
b = 0.03 # Fressrate der Räuber pro Lebewesen
l = 0

d = 0.02 # Reproduktionsrate der Räuber
g = 0.8 # Sterberate der Räuber
m = 0

x0 = 100 # preys
y0 = 20 # predators

t0 = 0
T = 45
n = 4500
"""

# Ausführen eines Schrittes des Predator-Prey-Modells
# Hierbei ist y_k ein Array der Größe 2, welches die Bestände der Preys und Predators zum vorherigen Zeutpunkt enthält, und Parameters ein Array der Größe 6
# Am Ende wird ein zweidimensionales Result-Array erstellt, welches die  Bestände der Preys und Predators zum nächsten Zeitpunkt enhält
def dt(y_k, parameters):
    x = y_k[0]
    y = y_k[1]
    a = parameters[0]
    b = parameters[1]
    l = parameters[2]
    d = parameters[3]
    g = parameters[4]
    m = parameters[5]
    result = []
    result.append(x * (a - b * y - l * x))
    result.append(y * (d * x - g - m * y))
    return result