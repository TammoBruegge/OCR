# Anwenden eines Schrittes der Euler-Methode.
# f ist hierbei die Funktion, welche in der ODE mit der Ableitung von y gleichgesetzt wurde.
# parameters ist eine Liste von Parametern, welche f außer y_k noch benötigt, der Zeitpunkt wird hier nicht explizit für die Berechnung gebraucht.
def euler(f, delta_t, y_k, parameters):
    return y_k + delta_t * f(y_k, parameters)
