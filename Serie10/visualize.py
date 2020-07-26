import matplotlib.pyplot as plt

values_predator = []
values_prey = []
time = []


with open('outfilePred.txt') as my_file:
    for line in my_file:
        values_predator.append(line)

with open('outfilePrey.txt') as my_file:
    for line in my_file:
        values_prey.append(line)

with open('outfileTime.txt') as my_file:
    for line in my_file:
        time.append(line)



# remove space
values_predator = [line.replace(' ', '') for line in values_predator]
values_prey = [line.replace(' ', '') for line in values_prey]
time = [line.replace(' ', '') for line in time]

# remove \n
values_predator = [line.replace('\n', '') for line in values_predator]
values_prey = [line.replace('\n', '') for line in values_prey]
time = [line.replace('\n', '') for line in time]

# cast strings to float
values_predator = list(map(float, values_predator))
values_prey = list(map(float, values_prey))
time = list(map(float, time))


# Graph plotten
plt.plot(time, values_prey, 'b', time, values_predator, 'r') # Prey sind blau, Predator rot
plt.xlabel('Zeitpunkt in Sekunden')
plt.ylabel('Bestand in Anzahl Tiere')
plt.ticklabel_format(useOffset=False) # Genaueres Anzeigen großes Zahlen
plt.show()


