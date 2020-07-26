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

"""


# Initial Values und Werte für die Variablen von User einlesen
def get_user_inputs():
    global a
    global b
    global l
    global d
    global g
    global m
    x0 = float(input("Enter the amount of preys: "))
    y0 = float(input("Enter the amount of predators: "))
    a = float(input("Enter the reproduction rate of the preys: "))
    b = float(input("Enter the feeding rate of the predators w.r.t. the preys: "))
    l = float(input("Enter the rate of negative social interactions of the preys: "))
    d = float(input("Enter the reproduction rate of the predators w.r.t. the amount of preys: "))
    g = float(input("Enter the dying rate of the predators: "))
    m = float(input("Enter the rate of negative social interactions of the predators: "))
    return [x0, y0]

# a = alpha, b = beta, l = lambda
# Die Ableitung von x nach t bilden nach den Vorgaben der Aufgabe.
def x_dt(x_k, y_k):
    return x_k * (a - b * y_k - l * x_k)

# d = delta, g = gamma, m = my
# Die Ableitung von y nach t bilden nach den Vorgaben der Aufgabe.
def y_dt(y_k, x_k):
    return y_k * (d * x_k - g - m * y_k)