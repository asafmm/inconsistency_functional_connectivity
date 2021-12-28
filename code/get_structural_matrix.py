import scipy.io
import matplotlib.pyplot as plt
import urllib
import glob
import re
import pandas as pd
import numpy as np

def create_structural_matrix_df(path, pass_end, measure):
    paths_p_tracts = glob.glob(f'{path}/*_{measure}_{pass_end}.mat')
    # initiate atlas and labels
    # initiate atlas and labels
    with open("../data/Schaefer2018_100Parcels_7Networks_order_info.txt", 'r') as f:
        parcels_text = f.read()
    # select only even rows, which contain the labels 
    lines = parcels_text.split('\n')[:-1]
    lines = lines[::2]
    # remove prefix from label: "7Networks_"
    roi_labels = [parcel[10:] for parcel in lines]
    # remove prefix from label: "7Networks_"
    # roi_labels = [roi[10:] for roi in lines]
    
    pattern = re.compile('.*(\d\d\d)_ep2d*') # pattern to find subject id
    df_rows = []
    for path in paths_p_tracts:
        cm = scipy.io.loadmat(path)['CM']
        tril_ind = np.tril_indices(cm.shape[0])
        cm_tril = cm[tril_ind]
        subject = int(re.findall(pattern, path)[0])
        df_row = np.insert(cm_tril, obj=0, values=subject)
        df_rows.append(df_row)
        
    # create label matrix
    multi_ind = list(zip(tril_ind[0], tril_ind[1]))
    label_mat = ['__'.join([roi_labels[i], roi_labels[j]]) for i,j in multi_ind]
    df_columns = np.insert(label_mat, obj=0, values='Subject')
    sc_df = pd.DataFrame(df_rows, columns=df_columns)
    sc_df = sc_df.iloc[sc_df.Subject.argsort(),:].reset_index(drop=True)
    sc_df = sc_df.set_index(sc_df['Subject'].astype(int))
    return sc_df