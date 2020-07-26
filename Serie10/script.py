import os
import matplotlib.pyplot as plt
import numpy as np 

alphaArray = []
values_prey = []
preyArray = []

tempArray = []

for i in range(0,200):
    tempArray.append(i / 100.0)


for j in range(0,len(tempArray),1):
    alphaArray.append(tempArray[j])

    inlines = []
    outlines = []
    with open('predatorprey.nml') as infile:
        for line in infile:
            inlines.append(line)

    for line in inlines:
        if(line[0:5] == 'alpha'):
            line = 'alpha = ' + str(tempArray[j])+ ' \n'
        outlines.append(line)

            
    with open('predatorprey.nml', 'w') as outfile:
        for line in outlines:
            outfile.write(line)


    os.system('gfortran -o output predator_prey.f90')
    os.system('./output')

    np.loadtxt(fname='outfilePrey.txt')
    my_file = np.loadtxt(fname='outfilePrey.txt')


    size = len(my_file)
    preyArray.append(my_file[size - 1])
        
# Graph plotten
plt.plot(alphaArray, preyArray)
plt.xlabel('Alpha')
plt.ylabel('Finaler Prey Bestand')
plt.ticklabel_format(useOffset=False) # Genaueres Anzeigen großes Zahlen
plt.show()


