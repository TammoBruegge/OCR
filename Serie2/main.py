import matplotlib.pyplot as plt

def energy_balance():
    temperature = []  # Initial leere Arrays für die zu plottenden Werte.
    time = []

    user_inputs = climate_model.get_user_inputs() # Werte für Variablen von Nutzer einlesen
    y0 = user_inputs[0]

    # Laufvariablen initialisieren.
    i = values.t0  # i auf t0 setzen
    s = y0  # s auf y(t0) setzen (Initial value)

    # Timeloop ausführen.
    while i <= values.T:
        temperature.append(s)  # Werte dem Array hinzufügen
        time.append(i)
        s = time_discretization.euler(climate_model.y_dt, values.delta_t, s, 0)  # nun ersetze s durch y(tk+1), wenn s vorher y(tk) war
        i += values.delta_t  # Zeitpunkt inkrementieren

    # Graph plotten
    plt.plot(time, temperature)
    plt.xlabel('Zeitpunkt in Jahren')
    plt.ylabel('Temperatur in Grad Kelvin')
    plt.ticklabel_format(useOffset=False)  # Genaueres Anzeigen großes Zahlen
    plt.show()


def pred_prey():
    values_predator = []  # Initial leere Arrays für die zu plottenden Werte.
    values_prey = []
    time = []

    user_inputs = climate_model.get_user_inputs()
    x0 = user_inputs[0]
    y0 = user_inputs[1]

    # Laufvariablen initialisieren.
    i = values.t0  # i auf t0 setzen
    x_t = x0  # s_prey ist Anfangsbestand an Gejagten
    y_t = y0  # s_predator ist Anfangsbestand an Jägern
    x_t_temp = x_t # Platzhalter für Berechnung damit beide Bestände gleichzeitig inkrementiert werden
    y_t_temp = y_t # Platzhalter für Berechnung damit beide Bestände gleichzeitig inkrementiert werden

    # Timeloop ausführen.
    while i <= values.T:
        time.append(i)  # Werte dem Array hinzufügen
        values_predator.append(y_t_temp)
        values_prey.append(x_t_temp)

        x_t_temp = time_discretization.euler(climate_model.x_dt, values.delta_t, x_t, y_t)  # nun ersetze s_prey_temp durch x(tk+1), wenn s vorher x(tk) war
        y_t_temp = time_discretization.euler(climate_model.y_dt, values.delta_t, y_t, x_t)  # nun ersetze s_predator_temp durch y(tk+1), wenn s vorher y(tk) war

        i += values.delta_t  # Zeitpunkt inkrementieren

        x_t = x_t_temp  # gleichzeitiges Ändern beider Bestände, damit nicht die Änderung eines Bestandes die Berechnung des anderen beeinflusst, dafür temp-Variablen, die zu speichernde Werte enthalten
        y_t = y_t_temp

    # Graph plotten
    plt.plot(time, values_prey, 'b', time, values_predator, 'r') # Prey sind blau, Predator rot, beide auf y-Achse
    plt.xlabel('Zeitpunkt in Jahren')
    plt.ylabel('Bestand in Anzahl Tiere (prey = blau, pred = rot)')
    plt.ticklabel_format(useOffset=False) # Genaueres Anzeigen großes Zahlen
    plt.show()


# Main-Methode, welche erfragt welcher Time-Integrator und welches Klimamodell genutzt werden sollen und entsprechend importiert und startet
if __name__ == '__main__':
    model = input("Which model do you wanna use? (a for Energy Balance Model, b for Predator Prey Model): ")
    method = input("Which model do you wanna use? (a for Euler, b for Improved Euler): ")
    if method == "a":
        from Serie2 import euler_method as time_discretization
    if method == "b":
        from Serie2 import improved_euler_method as time_discretization
    if model == "a":
        from Serie2 import energy_balance_model as climate_model, values_energy_balance_model as values
        energy_balance()
    if model == "b":
        from Serie2 import predator_prey_model as climate_model, values_predator_prey_model as values
        pred_prey()
