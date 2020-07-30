import matplotlib.pyplot as plt

# Abhängig vom gewählten Model wird eine an das Model angepasste Visualisierungsfunktion aufgerufen
def visualize(f, time, y):
    # Hier ist y ein Array von einelementigen Floatarrays, welches sich direkt plotten lässt
    if f == "energy_balance_model":
        # Graph plotten
        plt.plot(time, y)
        plt.xlabel('Zeitpunkt in Jahren')
        plt.ylabel('Temperatur in Grad Kelvin')
        plt.ticklabel_format(useOffset=False)  # Genaueres Anzeigen großes Zahlen
        plt.show()

    # Hier ist y ein Array von 2-elementigen Arrays, deshalb teilen wir es in 2 Arrays auf, die wir getrennt voneinander plotten
    # Das ist nicht nötig, so können wir aber klare Farben für die jeweiligen Bestände zuweisen
    if f == "predator_prey_model":
        values_prey = []
        values_pred = []
        for i in range(0, len(y)):
            values_prey.append(y[i][0])
            values_pred.append(y[i][1])
        # Graph plotten
        plt.plot(time, values_prey, 'b', time, values_pred, 'r')  # Prey sind blau, Predator rot, beide auf y-Achse
        plt.xlabel('Zeitpunkt in Jahren')
        plt.ylabel('Bestand in Anzahl Tiere (Prey sind blau, Predator sind rot)')
        plt.ticklabel_format(useOffset=False)  # Genaueres Anzeigen großes Zahlen
        plt.show()