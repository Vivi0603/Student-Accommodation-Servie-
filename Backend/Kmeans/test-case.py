# from math import sqrt
from math import sqrt
from matplotlib import pyplot as plt
import pandas as pd
import numpy as np

from sklearn.cluster import KMeans

kmeans = KMeans()

pd.set_option('display.max_columns', 50)

df_model = pd.read_csv("custom_dataset.csv")

df_model = df_model[['EXT1', 'EXT2','EXT3','EXT4', 'EXT5', 'EXT6', 'EST1', 'EST2', 'EST3', 'EST5', 'EST7', 'EST9', 'AGR1', 'AGR2', 'AGR4', 'AGR5', 'AGR6', 'AGR8', 'CSN4', 'CSN6', 'CSN7', 'CSN8', 'CSN9', 'CSN10', 'OPN1', 'OPN3', 'OPN5', 'OPN7', 'OPN8', 'OPN9']]

kmeans = KMeans(n_clusters=5,random_state=3425)
k_fit = kmeans.fit(df_model) 

# centroids = k_fit.cluster_centers_

# print(centroids)
# centroids_x = centroids[:,0]
# centroids_y = centroids[:,1]

# print(centroids_x)
# print(centroids_y)

# fig, ax = plt.subplots()
# ax.scatter(centroids_x,centroids_y)

predictions = k_fit.labels_
df_model['Clusters'] = predictions

col_list = list(df_model)
ext = col_list[0:6]
est = col_list[6:12]
agr = col_list[12:18]
csn = col_list[18:24]
opn = col_list[24:30]

data_sums = pd.DataFrame()
data_sums['extroversion'] = df_model[ext].sum(axis=1)/6
data_sums['neurotic'] = df_model[est].sum(axis=1)/6
data_sums['agreeable'] = df_model[agr].sum(axis=1)/6
data_sums['conscientious'] = df_model[csn].sum(axis=1)/6
data_sums['open'] = df_model[opn].sum(axis=1)/6
data_sums['clusters'] = predictions
print(data_sums.groupby('clusters').mean())

test_model = pd.read_csv('test.csv')
test_model = test_model[['EXT1', 'EXT2','EXT3','EXT4', 'EXT5', 'EXT6', 'EST1', 'EST2', 'EST3', 'EST5', 'EST7', 'EST9', 'AGR1', 'AGR2', 'AGR4', 'AGR5', 'AGR6', 'AGR8', 'CSN4', 'CSN6', 'CSN7', 'CSN8', 'CSN9', 'CSN10', 'OPN1', 'OPN3', 'OPN5', 'OPN7', 'OPN8', 'OPN9']]

print(test_model)

test_personality = k_fit.predict(test_model)

print(f'cluster: {test_personality}')

test_sums = pd.DataFrame()
test_sums['extroversion'] = test_model[ext].sum(axis=1)/6
test_sums['neurotic'] = test_model[est].sum(axis=1)/6
test_sums['agreeable'] = test_model[agr].sum(axis=1)/6
test_sums['conscientious'] = test_model[csn].sum(axis=1)/6
test_sums['open'] = test_model[opn].sum(axis=1)/6
test_sums['cluster'] = test_personality

# test_sums1 = [test_model[ext].to_numpy('int').tolist(),test_model[est].to_numpy('int').tolist(),test_model[agr].to_numpy('int').tolist(),test_model[csn].to_numpy('int').tolist(),test_model[opn].to_numpy('int').tolist()]

# # print(test_sums1.shape())
# new_arr = []
# for i in test_sums1:
#     for j in i:
#         new_arr.append(j)

# new_arr = np.array(new_arr)

# test_x = new_arr[:,0]
# test_y = new_arr[:,1]
# print(test_x)
# print(test_y)
# # print(k_fit.cluster_centers_)
# # ax.scatter(test_x,test_y,c='r')
# plt.show()

sums = data_sums.groupby('clusters').mean()

def euclidean_dist(ext,est,agr,csn,opn):
    return sqrt(ext+est+agr+csn+opn)


print(test_sums.groupby('cluster').mean())

# def cal_distance(sums,num,test_sums):
#     ext1 = abs(float(sums.iloc[num]['extroversion']) - test_sums['extroversion'])**2
#     est1 = abs(float(sums.iloc[num]['neurotic']) - test_sums['neurotic'])**2
#     agr1 = abs(float(sums.iloc[num]['agreeable']) - test_sums['agreeable'])**2
#     csn1 = abs(float(sums.iloc[num]['conscientious']) - test_sums['conscientious'])**2
#     opn1 = abs(float(sums.iloc[num]['open']) - test_sums['open'])**2

#     print(f'{num}: {euclidean_dist(ext1,est1,agr1,csn1,opn1)}')

# cal_distance(sums,0,test_sums)
# cal_distance(sums,1,test_sums)
# cal_distance(sums,2,test_sums)
# cal_distance(sums,3,test_sums)
# cal_distance(sums,4,test_sums)


test_sums = test_sums.drop('cluster', axis=1)
plt.bar(test_sums.columns, test_sums.iloc[0,:], color='green', alpha=0.2)
plt.plot(test_sums.columns, test_sums.iloc[0,:], color='red')
plt.title(f'Cluster {test_personality}')
plt.xticks(rotation=45)
plt.ylim(0,4)
plt.show()