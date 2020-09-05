import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('SpatialDataSet.txt', delimiter=";")
print(df.head())
#BBox = (46.2342, 46.2780, 20.1098, 20.2078)
BBox = (46.4061, 46.1142, 19.8145, 20.2959)
#BBox = (df.longitude.min(), df.longitude.max(), df.latitude.min(), df.latitude.max())

szeg = plt.imread('map.png')

fig, ax = plt.subplots(figsize = (8,7))
ax.scatter(df.longitude, df.latitude, zorder=1, alpha= 0.2, c='b', s=10)
ax.set_title('Plotting Spatial Data on Szeged Map')
ax.set_xlim(BBox[0],BBox[1])
ax.set_ylim(BBox[2],BBox[3])
#ax.set_aspect(1)
ax.imshow(szeg, zorder=0, extent = BBox, aspect= 'equal')
plt.show()