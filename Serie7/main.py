import matplotlib.pyplot as plt
import predator_prey_model as climate_model, values_predator_prey_model as values
import math
import numpy as np


def pred_prey():
    n = values.boxes

    x_old = np.empty(shape=(n))   # Initial leere Arrays für x und y zum Zeitpunkt t und t-1
    y_old = np.empty(shape=(n))   # x_old und y_old repräsentieren den jeweiligen Wert zum Zeitpunkt k-1, dieser wird zur Berechnung
                                  # der Distanz benötigt.
    x = np.empty(shape=(n))       # Wir nehmen numpy.empty, da wir in Python keine leeren Liste fester Größe erstellen können, da
    y = np.empty(shape=(n))       # sie dynamisch beim Einfügen wachsen


    diffMat = np.empty(shape=(n,n))
    


    # Diffusionsmatrix erstellen
    for i in range(n):
        for j in range(n):
            if((i == j) and (i == 0 or i == n-1)):
                diffMat[i,j] = -1
            elif (i == j):
                diffMat[i,j] = -2
            elif(i == j - 1 or i == j + 1):
                diffMat[i,j] = 1
            else:
                diffMat[i,j] = 0

    diffMat = (values.kappa / (values.h*values.h)) * diffMat # skalierte Diffusionsmatrix

    # Die Arrays mit den in der Aufgabenstellung geforderten Werten initialisieren
    for i in range(n):
        x[i] = (math.sin((i * math.pi) / n))
        y[i] = 1
    

    distx = float('inf') # Höchste darstellbare Zahl wegen initialem Schleifendurchlauf. Selbes für disty
    disty = float('inf')
    steps = 0
    

    while (math.sqrt(distx+disty) > values.e): # Abbruchbedingung mit Euklidischer Distanz
        steps += 1
        distx = 0
        disty = 0

        x_old = x
        y_old = y

        x = time_discretization.euler(climate_model.x_dt, values.delta_t, x_old, [y_old, diffMat])  # nun ersetze s_prey_temp durch x(tk+1), wenn s vorher x(tk) war

        y = time_discretization.euler(climate_model.y_dt, values.delta_t, y_old, [x_old, diffMat])  # nun ersetze s_predator_temp durch y(tk+1), wenn s vorher y(tk) war

        for j in range(values.boxes):
            distx += (x[i] - x_old[i])**2 # Erster Teil der Euklidischen Distanz , Wurzel wird später in der Bedingung gezogen
            disty += (y[i] - y_old[i])**2
 

    # Beschriftung für die Boxen in einer Liste sammeln
    boxArray = []
    for i in range(len(x)):
        boxArray.append(i)

    # Graph plotten
    plt.plot(boxArray, x, 'b', y, 'r') # Prey sind blau, Predator rot
    plt.xlabel('Boxen')
    plt.ylabel('Bestand in Anzahl Tiere (Preys sind blau und Predators sind rot)')
    plt.ticklabel_format(useOffset=False) # Genaueres Anzeigen großes Zahlen
    plt.show()
    print("Wir brauchten " + str(steps) + " Zeitschritte")



#Main Methode, wo per Benutzereingabe welcher time integrator genutzt werden soll
if __name__ == '__main__':
    method = input("Which time integrator do you want to use? (a for Euler, b for Improved Euler): ")
    if method == "a":
        import euler_method as time_discretization
    if method == "b":
        import improved_euler_method as time_discretization
    pred_prey()
