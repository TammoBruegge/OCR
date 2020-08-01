def initialize():
    # Parameter, welche ins Main-Modul importiert werden, müssen global sein, damit sie dort verwendet werden können
    global f_name
    global time_integrator_name
    global t0
    global T
    global y0
    global parameters
    global deltaT


    input_string_1 = input("Enter the initial values seperated by space: ") # Attribute durch Leerzeichen getrennt aufnehmen, später in Liste packen
    f_name = input("Whats the name of the python file for the model function? ") # String zur Identifikation der Model-Funktion
    time_integrator_name = input("Whats the name of the python file for the time integrator? ") # String zur Identifikation des Time-Integrators
    t0 = float(input("What is the starting time? "))
    T = float(input("When should the time stepping end? "))
    n = int(input("How many timesteps should we do? ")) # Auf Integer umcasten, da die Anzahl Schritte nie ein Float sein kann
    input_string_2 = input("Enter a list of parameters separated by space: ") # Attribute durch Leerzeichen getrennt aufnehmen, später in Liste packen

    y0 = input_string_1.split() # input_string in Array von Parametern aufsplitten
    y0 = list(map(float, y0)) # Aktuell stehen im Array Strings, umcasten auf floats
    parameters = input_string_2.split()
    parameters = list(map(float, parameters))
    deltaT = (T - t0) / n