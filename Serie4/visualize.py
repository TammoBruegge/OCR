import matplotlib.pyplot as plt

# Liste zum Speichern der Werte
values_predator = []
values_prey = []



# Ergebnisdateien des Fortrancodes öffnen und in die Ergebnisliste speichern (Aktuell noch Strings und keine Zahlen)
with open('values_pred.txt') as my_file:
    for line in my_file:
        values_predator.append(line)

with open('values_prey.txt') as my_file:
    for line in my_file:
        values_prey.append(line)


# Leerzeichen entfernen
values_predator = [line.replace(' ', '') for line in values_predator]
values_prey = [line.replace(' ', '') for line in values_prey]

# Zeilenumbruch entfernen
values_predator = [line.replace('\n', '') for line in values_predator]
values_prey = [line.replace('\n', '') for line in values_prey]

# Strings zu Floats umcasten
values_predator = list(map(float, values_predator))
values_prey = list(map(float, values_prey))


# Beschriftung für die Boxen in einer Liste sammeln, da diese nicht vom Fortrancode erstellt werden
boxes = []

for i in range(len(values_prey)):
    boxes.append(i)


# Graph plotten
plt.plot(boxes, values_prey, 'bo', values_predator, 'ro') # Prey sind blau, Predator rot
plt.xlabel('Box')
plt.ylabel('Bestand in Anzahl Tiere (Preys sind blau und Predator rot)')
plt.ticklabel_format(useOffset=False) # Genaueres Anzeigen großes Zahlen
plt.show()


