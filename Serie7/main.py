import matplotlib.pyplot as plt
import predator_prey_model as climate_model, values_predator_prey_model as values
import math
import numpy as np


def pred_prey():
    n = values.boxes

    
    x_temp = np.empty(shape=(n))  # Initial leere Arrays für x und y zum Zeitpunkt t und t-1
    y_temp = np.empty(shape=(n))
    x = np.empty(shape=(n))
    y = np.empty(shape=(n))



    diffMat = np.empty(shape=(n,n))
    diffMat_scale = np.empty(shape=(n,n))


    for j in range(n):
        for i in range(n):
            if((i == j) and (i == 0 or i == n-1)):
                diffMat[i,j] = -1
            elif (i == j):
                diffMat[i,j] = -2
            elif(i == j-1 or i == j+1):
                diffMat[i,j] = 1
            else:
                diffMat[i,j] = 0

    diffMat_scale = (values.kappa / (values.h*values.h)) * diffMat

    for i in range(values.boxes):
        x[i] = (math.sin((i * math.pi) / values.boxes))
        y[i] = 1
    

    for j in range(values.boxes):
        x_temp[j] = x[j]+100 # X_temp und Y_temp auf hohe Werte setzen , damit erste Distanz nicht direkt zum Abruch der Loop führt
        y_temp[j] = y[j]+100
    distx = 1337 #Hohe Zahl wegen initialen Loop durchlauf. Selbe für disty
    disty = 42
    steps = 0
    

    while (math.sqrt(distx+disty) > values.e): #Abbruch bedingung mit Euklidischer Distanz
        steps += 1
        distx = 0
        disty = 0

        for j in range(values.boxes):
            distx += (x[i] - x_temp[i])**2 #Erster Teil der Euklidische Distanz , Wurzel später in While Schleife
            disty += (y[i] - y_temp[i])**2


        x_temp = x
        y_temp = y

        x = time_discretization.euler(climate_model.ableitung_x, values.delta_t, x_temp, [y_temp, diffMat_scale])  # nun ersetze s_prey_temp durch x(tk+1), wenn s vorher x(tk) war

        y = time_discretization.euler(climate_model.ableitung_y, values.delta_t, y_temp, [x_temp, diffMat_scale])  # nun ersetze s_predator_temp durch y(tk+1), wenn s vorher y(tk) war

 
    boxArray = []

    for i in range(len(x)):
        boxArray.append(i)

    # Graph plotten
    plt.plot(boxArray, x, 'b', y, 'r') # Prey sind blau, Predator rot
    plt.xlabel('Quadranten')
    plt.ylabel('Bestand in Anzahl Tiere')
    plt.ticklabel_format(useOffset=False) # Genaueres Anzeigen großes Zahlen
    plt.show()
    print("Wir brauchten " + str(steps) + " Zeitschritte")



# Main-Methode, welche zuerst User-Input für alle Variablen, welche für das Lösen der ODE benötigt werden, liest.
if __name__ == '__main__':
    method = input("Which model do you wanna use? (a for Euler, b for Improved Euler): ")
    if method == "a":
        import euler_method as time_discretization
    if method == "b":
        import improved_euler_method as time_discretization
    pred_prey()
