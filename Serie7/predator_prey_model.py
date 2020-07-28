import values_predator_prey_model as values
import numpy as np


# Die Ableitung von x bilden nach den Vorgaben der Aufgabe.
def x_dt(x_k, paras):
    y_k = paras[0]
    diffMat = paras[1]
    return np.dot(diffMat, x_k) + np.multiply(x_k, (values.a - np.multiply(values.b, y_k) - np.multiply(values.l, x_k))) # Berechnen der Ableitung nach vorgegebener Art.

# d = delta, g = gamma, m = my
# Die Ableitung von y bilden nach den Vorgaben der Aufgabe.
def y_dt(y_k, paras):
    x_k = paras[0]
    diffMat = paras[1]
    return np.dot(diffMat, y_k) + np.multiply(y_k, (np.multiply(values.d, x_k) - values.g - np.multiply(values.m, y_k)))# Berechnen der Ableitung nach vorgegebener Art.

   