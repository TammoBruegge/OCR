from Serie2_Tutorial import init, finalize

# Initial leere Arrays für die zu plottenden Werte
time = [] # enthält Zeitpunkte, also Floats
y = []  # enthält Arrays der Größe der Dimension des Systems von ODEs

def time_loop(time_integrator, f, deltaT, parameters):

    # Damit wir auf y[i-1] in Loop direkt zugreifen (ohne Index out of Range) können, müssen wir die erste Stelle der Arrays "von Hand" initialisieren.
    time.append(init.t0)
    y.append(init.y0)
    i = init.t0 + deltaT # Ersten Zeitschritt ebenfalls "von Hand" machen
    counter = 1 # Counter wird benötigt, um auf das Array y zuzugreifen. Er symbolisiert die Position, auf welcher der nächste Wert eingefügt wird.

    # Time Loop
    while i <= init.T:
        time.append(i)
        y.append(time_integrator(f, y[counter - 1], deltaT, parameters)) # y das Ergebnisarray des time-integrators hinzufügen. Also die neuesten berechneten Werte
        counter = counter + 1 # Laufvariablen inkrementieren
        i = i + deltaT # i wird nur für Abbruchbedingung benutzt, man könnte auch die Anzahl der Schritte berechnen und diese über counter mitzählen und darüber abbrechen

if __name__ == '__main__':
    init.initialize() # Model initialisieren. Mit Initial Values und Variablen für das Model, sowie Variablen für das Timestepping

    t = init.time_integrator_name # Die Variablen des gewünschten Models & Timeintegrators auslesen
    f = init.f_name

    # und basierend auf diesen Variablen die passende Module laden
    if t == "euler_method":
        from Serie2_Tutorial import euler_method as time_discretization
    if t == "improved_euler_method":
        from Serie2_Tutorial import improved_euler_method as time_discretization
    if f == "energy_balance_model":
        from Serie2_Tutorial import energy_balance_model as climate_model
    if f == "predator_prey_model":
        from Serie2_Tutorial import predator_prey_model as climate_model

    time_loop(time_discretization.euler, climate_model.dt, init.deltaT, init.parameters) # Aufruf der Timeloop
    finalize.visualize(f, time, y) # Nach Abschluss der Timeloop Ergebnisse visualisieren



