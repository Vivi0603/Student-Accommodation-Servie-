from math import sqrt
import pandas as pd
import numpy as np
import sys

from sklearn.cluster import KMeans

kmeans = KMeans()

from sklearn.cluster import KMeans

# df_model = data[['EXT1', 'EXT2','EXT3','EXT4', 'EXT5', 'EXT6', 'EST1', 'EST2', 'EST3', 'EST5', 'EST7', 'EST9', 'AGR1', 'AGR2', 'AGR4', 'AGR5', 'AGR6', 'AGR8', 'CSN4', 'CSN6', 'CSN7', 'CSN8', 'CSN9', 'CSN10', 'OPN1', 'OPN3', 'OPN5', 'OPN7', 'OPN8', 'OPN9']].head(10000)

# df_model.to_csv('new_dataset.csv')

df_model = pd.read_csv("custom_dataset.csv")

df_model = df_model[['EXT1', 'EXT2','EXT3','EXT4', 'EXT5', 'EXT6', 'EST1', 'EST2', 'EST3', 'EST5', 'EST7', 'EST9', 'AGR1', 'AGR2', 'AGR4', 'AGR5', 'AGR6', 'AGR8', 'CSN4', 'CSN6', 'CSN7', 'CSN8', 'CSN9', 'CSN10', 'OPN1', 'OPN3', 'OPN5', 'OPN7', 'OPN8', 'OPN9']]

# df_model.dropna(inplace=True)

# df_sample = df_model.sample(50000)

# df_sample.to_csv('custom_dataset.csv')

#----------------Elbow Curve--------------------------
# from yellowbrick.cluster import KElbowVisualizer

# visualizer = KElbowVisualizer(kmeans, k=(2,15))
# visualizer.fit(df_sample)
# visualizer.poof()


kmeans = KMeans(n_clusters=5,random_state=3425)
k_fit = kmeans.fit(df_model) 

predictions = k_fit.labels_
df_model['Clusters'] = predictions

# print(k_fit.cluster_centers_)

# print(df_model['Clusters'])

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
# print(data_sums.groupby('clusters').mean())

sums = data_sums.groupby('clusters').mean()

# pd_test = pd.read_csv('fake-user.csv')
# pd_test = pd_test[['EXT1', 'EXT2','EXT3','EXT4', 'EXT5', 'EXT6', 'EST1', 'EST2', 'EST3', 'EST5', 'EST7', 'EST9', 'AGR1', 'AGR2', 'AGR4', 'AGR5', 'AGR6', 'AGR8', 'CSN4', 'CSN6', 'CSN7', 'CSN8', 'CSN9', 'CSN10', 'OPN1', 'OPN3', 'OPN5', 'OPN7', 'OPN8', 'OPN9']]
# # print(pd_test)
# test_personality = k_fit.predict(pd_test)

# print(test_personality)


test_data = sys.argv[1]+","+sys.argv[2]+","+sys.argv[3]+","+sys.argv[4]+","+sys.argv[5]

test_data = test_data.split(',')

t_data = []

for i in test_data:
    t_data.append(int(i))

cols = ['EXT1', 'EXT2','EXT3','EXT4', 'EXT5', 'EXT6', 'EST1', 'EST2', 'EST3', 'EST5', 'EST7', 'EST9', 'AGR1', 'AGR2', 'AGR4', 'AGR5', 'AGR6', 'AGR8', 'CSN4', 'CSN6', 'CSN7', 'CSN8', 'CSN9', 'CSN10', 'OPN1', 'OPN3', 'OPN5', 'OPN7', 'OPN8', 'OPN9']

t_data = np.array([t_data])
test_model = pd.DataFrame(t_data,columns = cols)

test_personality = k_fit.predict(test_model)

print(test_personality)


test_sums = pd.DataFrame()
test_sums['extroversion'] = test_model[ext].sum(axis=1)/6
test_sums['neurotic'] = test_model[est].sum(axis=1)/6
test_sums['agreeable'] = test_model[agr].sum(axis=1)/6
test_sums['conscientious'] = test_model[csn].sum(axis=1)/6
test_sums['open'] = test_model[opn].sum(axis=1)/6
test_sums['cluster'] = test_personality

ext1 = abs(float(sums.iloc[test_sums['cluster']]['extroversion']) - test_sums['extroversion'])**2
est1 = abs(float(sums.iloc[test_sums['cluster']]['neurotic']) - test_sums['neurotic'])**2
agr1 = abs(float(sums.iloc[test_sums['cluster']]['agreeable']) - test_sums['agreeable'])**2
csn1 = abs(float(sums.iloc[test_sums['cluster']]['conscientious']) - test_sums['conscientious'])**2
opn1 = abs(float(sums.iloc[test_sums['cluster']]['open']) - test_sums['open'])**2


def euclidean_dist(ext,est,agr,csn,opn):
    return sqrt(ext+est+agr+csn+opn)

test_sums['distance'] = euclidean_dist(ext1,est1,agr1,csn1,opn1)

if float(test_sums['distance']) > 2:
    print(1)
else:
    print(0)

print(float(test_sums['distance']))

# test = pd.read_csv('./test.csv')
# test = test[cols]
# print(test)

# test_personality = k_fit.predict(test)
# print('test Cluster: ', test_personality)