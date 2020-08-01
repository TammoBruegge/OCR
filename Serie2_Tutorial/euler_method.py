# Anwenden eines Schrittes der Euler-Methode.
# f ist hierbei die Funktion, welche in der ODE mit der Ableitung von y gleichgesetzt wurde.
# parameters ist eine Liste von Parametern, welche f außer y_k noch benötigt, der Zeitpunkt wird hier nicht explizit für die Berechnung gebraucht.
def euler(f, y_k, deltaT, parameters):
    model_value = f(y_k, parameters) # Aufruf der Modelfunktion mit den gegebenen Parametern
    result = []
    for i in range(0, len(y_k)):
        result.append(y_k[i] + deltaT * model_value[i]) # Elementweise Berechnung des Ergebnisses (result hat Größe der Dimension des ODEs).
                                                        # Für jeden Eintrag in result wird ein Eulerstep mit den zugehörigen Werten gemacht
    return result
