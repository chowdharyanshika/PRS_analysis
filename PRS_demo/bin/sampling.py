

import os
import numpy as np
import pandas as pd
from pandas_read_xml import flatten, fully_flatten, auto_separate_tables
import random
import csv



random.seed(111)
samples_table  =  pd.read_csv('/lustre/groups/itg/teams/data-informatics/projects/plink_cineca_synthetic/PRS_wf/test_data/test_synthetic_21.fam', sep=" ", header=None)
sampleslist =  samples_table.iloc[: , 0].to_list()
samplelist_target= random.sample(sampleslist, 300)
#df = samples_table.sample(n=300)
#print(df)
#samples_table_TARGET = samples_table.sample(frac = 0.15)
#samples_table_BASE = samples_table.drop(samples_table_TARGET.index)
#print(samples_table_BASE.shape)
#print(samples_table_TARGET.shape)

#samples_table_BASE.to_csv('base_21.fam', sep=' ')
#samples_table_TARGET.to_csv('targets_21.fam', sep=' ')



set_1 = set(samplelist_target)  # this reduces the lookup time from O(n) to O(1)
sampleslist_base = [item for item in sampleslist if item not in set_1]
print(len(sampleslist_base))
print(len(samplelist_target))
with open('samples_base.csv', 'w') as f:
       writer = csv.writer(f, delimiter='\t')
       writer.writerows(zip(sampleslist_base,sampleslist_base))

with open('samples_target.csv', 'w') as f:
       writer = csv.writer(f, delimiter='\t')
       writer.writerows(zip(samplelist_target,samplelist_target))



'''
with open('base_samples.txt', 'w') as f:
    for item in sampleslist_base:
        f.write("%s\n" % item)

with open('target_samples.txt', 'w') as f:
    for item in samplelist_target:
        f.write("%s\n" % item)
        

'''






