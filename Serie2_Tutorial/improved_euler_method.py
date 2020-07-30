# Anwenden eines Schrittes der Improved-Euler-Methode.
# f ist hierbei die Funktion, welche in der ODE mit der Ableitung von y gleichgesetzt wurde.
# parameters ist eine Liste von Parametern, welche f außer y_k noch benötigt, der Zeitpunkt wird hier nicht explizit für die Berechnung gebraucht.
def euler(f, y_k, deltaT, parameters):
    half_step_value = f(y_k, parameters) # Aufruf der Modelfunktion mit den gegebenen Parametern
    half_step_array = []
    for i in range(0, len(y_k)):
        half_step_array.append(y_k[i] + (deltaT / 2) * half_step_value[i]) # Elementweise Berechnung des Ergebnisses des halben Eulerschrittes (half_step_array hat Dimension des ODEs).
                                                                           # Für jeden Eintrag in half_step_array wird ein halber Eulerstep mit den zugehörigen Werten gemacht
    model_value = f(half_step_array, parameters) # Aufruf der Modelfunktion mit den gegebenen Parametern und dem halben Eulerstep
    result = []
    for j in range(0, len(y_k)):
        result.append(y_k[j] + deltaT * model_value[j]) # Elementweise Berechnung des Ergebnisses (result hat Dimension des ODEs).
                                                        # Für jeden Eintrag in result wird ein Eulerstep mit den zugehörigen Werten gemacht
    return result
