import os
import matplotlib.pyplot as plt
import numpy as np 

alphaArray = [] # Das Array ist zum Speichern der Alpha Werte
preyArray = [] # Das Array zum Speichern der Prey Bestände zum letzten Zeitpunkt für jedes Alpha

N = 100

for i in range(0, 2 * N + 1, 2): # Wertebereich soll von [0,2], Schrittgröße 2, da sonst 2 * N Werte gespeichert werden
    alphaArray.append(i / N) # Teile den Wertebereich von Alpha gleichmäßig in N Punkte auf

# Loop, in der für jeden Alpha-Wert einmal die Namelist-geändert wird und das Fortran-Programm neu kompiliert und ausgeführt wird 
for j in range(0, len(alphaArray),1):
    inlines = []
    outlines = []
    
    # namelist Zeilenweise in inlines speichern
    with open('predatorprey.nml') as infile:
        for line in infile:
            inlines.append(line)

    # Zeile der Namelist in der Alpha steht suchen und Wert von Alpha durch Wert alphaArray[j] ersetzen
    for line in inlines:
        if(line[0:5] == 'alpha'):
            line = 'alpha = ' + str(alphaArray[j])+ ' \n'
        outlines.append(line) 

            
    # Alte Namelist Zeile für Zeile mit Einträgen des Outline Arrays überschreiben
    with open('predatorprey.nml', 'w') as outfile:
        for line in outlines:
            outfile.write(line)


    os.system('gfortran -o output predator_prey.f90') # Programm kompilieren
    os.system('./output') # Programm ausführen
                                                    
    my_file = np.loadtxt(fname='outfilePrey.txt') # Outputdatei des predator_prey.f90 Programms wird in Array my_file gespeichert. Hier sparen wir uns das Entfernen der Leerzeichen,
    						    # \n und das konvertieren des Typs

    preyArray.append(my_file[len(my_file) - 1]) # dem preyArray den Bestand zum letzten Zeitpunkt dieser Ausführung hinzufügen
        
# Graph plotten
plt.plot(alphaArray, preyArray)
plt.xlabel('Alpha')
plt.ylabel('Finaler Bestand der Preys')
plt.ticklabel_format(useOffset=False) # Genaueres Anzeigen großes Zahlen
plt.show()


