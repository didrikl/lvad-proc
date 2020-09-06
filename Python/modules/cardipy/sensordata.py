#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 10 12:45:39 2018

@author: mreinsfelt
"""

import io as capio
import matplotlib.pyplot as plt
import time
from datetime import datetime
import numpy as np
import copy
import pickle

class SensorData:
    
    def __init__(self, fname, drange=None):
        self.fname = fname
        t0 = time.time()
        self.raw = capio.custom_read_xml(fname, drange)
        t1 = time.time()
        print('Reading took ' + str(t1-t0) + 's' )
        data = capio.parse_xml(self.raw, show=False)
        print('Parsing took ' + str(time.time()-t1) + 's' )
        
        self.t0 = data['t0']
        self.sn = data['sn']
        self.t = data['t']
        self.acc = data['acc']
        self.adc = data['adc']
        
    def get_interval(self, t1, t2, fmt='%H:%M:%S'):
        
        t0 = self.t0/1000.0
        date = datetime.fromtimestamp(self.t0/1000.0).strftime('%Y%m%d')
        t1_o = datetime.strptime(date+t1, '%Y%m%d'+fmt)
        t2_o = datetime.strptime(date+t2, '%Y%m%d'+fmt)
        
        t1_s = t1_o.timestamp() - t0
        t2_s = t2_o.timestamp() - t0
        
        ix = self.find_nearest(self.t,[t1_s,t2_s])
        
        #print(t0, t1_o.timestamp(),t2_o.timestamp(),t1_s,t2_s,ix)
        
        self.acc = self.acc[ix[0]:ix[1],:]
        self.adc = self.adc[ix[0]:ix[1]]
        self.t = self.t[ix[0]:ix[1]] - self.t[ix[0]]
        self.t0 = t1_o.timestamp() * 1000.0
        
        
    def copy(self):
        return copy.deepcopy(self)
    
    def plot(self):
        ts = [datetime.fromtimestamp(t+(self.t0/1000.0)) for t in self.t]
        f,ax = plt.subplots(2,1, sharex=True)
        ax[0].plot(ts,self.acc[:len(self.t),:])
        ax[0].set_ylabel('Acc [g]')
        ax[0].legend(['x','y','z'], loc=1)
        ax[1].plot(ts,self.adc)
        ax[1].set_ylabel('ECG [mv]')
        ax[1].set_xlabel('Sample')
        plt.show()
        

    def find_nearest(self, array,value):
        ''' Find nearest value '''
        idx=[]
        for vals in value:
            idx.append(np.argmin(np.abs(array-vals)) )
    
    
        return idx#, array[idx]
        
        
#%% utility functions
def save_obj(obj, name ):
    with open(name + '.pkl', 'wb') as f:
        pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)

def load_obj(name ):
    with open(name + '.pkl', 'rb') as f:
        return pickle.load(f)
        

