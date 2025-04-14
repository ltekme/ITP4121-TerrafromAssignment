import multiprocessing
import numpy as np


materialsInBurner: list[multiprocessing.Process] = list()


def startBurningMaterial():
    # fucking stress out the cpu
    while True:
        m1 = np.random.randn(512, 512)
        m2 = np.random.randn(512, 512)
        np.linalg.norm(np.dot(m1, m2))


def startABurnerMaterial():
    p = multiprocessing.Process(target=startBurningMaterial)
    p.start()
    return p


def stopABurnerMaterial(p: multiprocessing.Process):
    p.terminate()
    return p


def addMaterialsToBurner(count: int):
    for _ in range(count):
        burningMaterial = startABurnerMaterial()
        materialsInBurner.append(burningMaterial)


def removeMaterialsFromBurner(count: int):
    for _ in range(count):
        burningMaterial = materialsInBurner.pop()
        stopABurnerMaterial(burningMaterial)
