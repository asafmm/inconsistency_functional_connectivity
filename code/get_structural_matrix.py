import scipy.io
import matplotlib.pyplot as plt
# import urllib
import glob
import re
import pandas as pd
import numpy as np

def get_cm_df(path, pass_end, measure):
    paths = glob.glob(f'{path}/{pass_end}/*_{measure}_{pass_end}.mat')
    with open("../data/Schaefer2018_100Parcels_7Networks_order_info.txt", 'r') as f:
        parcels_text = f.read()
    # select only even rows, which contain the labels 
    lines = parcels_text.split('\n')[:-1]
    lines = lines[::2]
    # remove prefix from label: "7Networks_"
    roi_labels = [parcel[10:] for parcel in lines]
    
    pattern = re.compile('.*(\d\d\d)_ep2d*') # pattern to find subject id
    df_rows = []
    for path in paths:
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
    sc_df.Subject = sc_df.Subject.astype(int)
    sc_df = sc_df.set_index('Subject')
    return sc_df

def get_avg_cm(path, pass_end, measure):
    paths = glob.glob(f'{path}/{pass_end}/*_{measure}_{pass_end}.mat')
    avg_cm = np.nanmean([scipy.io.loadmat(path)['CM'] for path in paths], axis=0)
    return avg_cm

def get_subject_full_cm(path, pass_end, measure, subject):
    subject_file = glob.glob(f'{path}/{pass_end}/{subject}*_{measure}_{pass_end}.mat')[0]
    cm = scipy.io.loadmat(subject_file)['CM']
    return cm