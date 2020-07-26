import matplotlib.pyplot as plt

values_predator = []
values_prey = []


with open('values_pred.txt') as my_file:
    for line in my_file:
        values_predator.append(line)

with open('values_prey.txt') as my_file:
    for line in my_file:
        values_prey.append(line)


# remove space
values_predator = [line.replace(' ', '') for line in values_predator]
values_prey = [line.replace(' ', '') for line in values_prey]

# remove \n
values_predator = [line.replace('\n', '') for line in values_predator]
values_prey = [line.replace('\n', '') for line in values_prey]

# cast strings to float
values_predator = list(map(float, values_predator))
values_prey = list(map(float, values_prey))

timeArray = []

for i in range(len(values_prey)):
    timeArray.append(i)


# Graph plotten
plt.plot(timeArray, values_prey, 'b', values_predator, 'r') # Prey sind blau, Predator rot
plt.xlabel('Quadranten')
plt.ylabel('Bestand in Anzahl Tiere')
plt.ticklabel_format(useOffset=False) # Genaueres Anzeigen großes Zahlen
plt.show()


