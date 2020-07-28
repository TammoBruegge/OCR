# Anwenden eines Schrittes der Improved-Euler-Methode.
# Hierbei wird im Aufruf von f ein Aufruf von f mit halber Schrittgröße gemacht.
# f ist hierbei die Funktion, welche in der ODE mit der Ableitung von y gleichgesetzt wurde
# delta_t ist die Größe eines Zeitschrittes
# y_k ist y(tk)
# parameters ist eine Liste von Parametern, welche f außer y_k noch benötigt


def euler(f, delta_t, y_k, parameters):
    return y_k + delta_t * f(y_k + (delta_t / 2) * f(y_k, parameters), parameters)
