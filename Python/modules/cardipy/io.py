#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 10 10:25:03 2018

@author: mreinsfelt
"""
from lxml import etree
import numpy as np
import matplotlib.pyplot as plt
import os
import time
import re

#%%
def fix_file(fname):
    print(fname)
    file = open(fname, "r+", encoding = "utf-8")

    #Move the pointer (similar to a cursor in a text editor) to the end of the file. 
    file.seek(0, os.SEEK_END)
    
    #This code means the following code skips the very last character in the file - 
    #i.e. in the case the last line is null we delete the last line 
    #and the penultimate one
    pos = file.tell() - 1
    
    #Read each character in the file one at a time from the penultimate 
    #character going backwards, searching for a newline character
    #If we find a new line, exit the search
    while pos > 0 and file.read(1) != "\n":
        pos -= 1
        file.seek(pos, os.SEEK_SET)
    
    #So long as we're not at the start of the file, delete all the characters ahead of this position
    if pos > 0:
        file.seek(pos, os.SEEK_SET)
        file.truncate()
    
    file.close()
    
#fix_file('../datasets/snippet/test_data2.txt')

#%%
def custom_read_xml(fname, drange=None):
    
    raw = {}
    with open(fname.replace('.xml','.txt'), 'r') as f:
        lines = f.readlines() if drange is None else f.readlines()[drange[0]:drange[1]]
        for l in lines:
            #elements = re.split('\W+(?<==")\W+', l)
            elements = [foo.replace('"','') for foo in l[4:-3].split('" ')]
            if 'status=ok' in elements:
                #print(l)
                #print(len(elements),elements)
                for ei in elements:
                    key,value=ei.split('=')
                    if key not in raw.keys():
                        raw[key] = [value]
                    else:
                        raw[key].append(value)
            #else:
            #    print('sfefsef')
    return raw
            
#foo= custom_read_xml('../datasets/snippet/test_data.xml')
#print(foo.keys())

#%%
def read_xml(fname):
    print('Reading file: '+fname)
    
#    xmlschema_doc = etree.parse('./cardipy/XMLschema.xml')
#    xmlschema = etree.XMLSchema(xmlschema_doc)
    
#    parser = etree.XMLParser(schema=xmlschema)
    
    # Fix broken line
    fix_file(fname.replace('.xml','.txt'))
    
    
    #t = time.time()
    tree = etree.parse(fname)
    #tree = custom_parse(fname.replace('.xml','.txt'))
    #print('Parsing took '+ str(time.time() - t) + ' s')
    
    raw={}
    for i,element in enumerate(tree.iter()):
        
        if 'status' not in element.attrib.keys(): continue
        #print(element.attrib)
        
        if element.attrib['status'] == 'ok':
            for key, value in element.attrib.items():
                #print(i,key,value)
                
                if key not in raw.keys():
                    raw[key] = [value]
                else:
                    raw[key].append(value)
        else:
            print(element.attrib['id'],element.attrib['status'])
                    
    return raw

#raw = read_xml('../datasets/snippet/test_data.xml')

#%%

def parse_xml(raw, show=False):
    print('Parsing XML...')
    
    # get scaling, TODO add logic for changing scale
    accscale = float(raw['accscale'][0]) if 'accscale' in raw.keys() else 1.0
    adcscale = float(raw['adcscale'][0]) if 'adcscale' in raw.keys() else 1.0
    
    t0 = time.time()
    # Parse accelerometer data
    if 'acc' in raw.keys():
        acc = []
        for i in raw['acc'][:-1]:
            samplist = i.split(' ')
            for s in samplist:
                samp = s.split(',')
                sampint = [int(j) for j in samp]
                sampfloat = np.array(sampint) * accscale
                acc.append(sampfloat)
                
    t1 = time.time()
    frames = [int(frame) for frame in raw['frame']]
    deltaframe = np.diff(frames)
    t2 = time.time()
    
    # Parse ADC data
    if 'adc' in raw.keys():
        adc = []
        for dframe,sample in zip(deltaframe,raw['adc'][:-1]):
            sampint = int(sample)
            sampfloat = sampint * adcscale
            #adc = adc + [sampfloat]*dframe
            for i in range(dframe): adc.append(sampfloat)
            
            
    t3 = time.time()
    
    if 't' in raw.keys():
        t0 = int(raw['t'][0])
        ts = [int(t) for t in raw['t']]
        ts = np.array(ts) - t0
        dts = np.diff(ts)
        foos = []
        for i,j,k in zip(ts[:-1],deltaframe,dts):
            #print(i,j,k)
            for l in range(j):
                foo = i + (l*(k/j))
                foos.append(foo)
                #print(foo)
                
        ts = np.array(foos)/ 1000.0
        
    t4 = time.time()
        
    # Check for equal length
    length = min([len(acc),len(adc), len(ts)])
    if len(acc) - length > 0: del acc[length-len(acc)]
    if len(adc) - length > 0: del acc[length-len(adc)]
    if len(ts) - length > 0: del acc[length-len(ts)]
    
    
    #print(len(acc),len(adc), len(foos))

    data = {'t'      : ts,
            'acc'    : np.stack(acc,axis=0),
            'adc'    : np.array(adc),
            't0'     : t0,
            'sn'     : raw['sn'][0],
            'status' : raw['status']     
            }
    
    t5 = time.time()
    #print(t1-t0,t2-t1,t3-t2,t4-t3,t5-t4)
    
    # Plot
    if show:
        f,ax = plt.subplots(2,1, sharex=True)
        ax[0].plot(ts,acc)
        ax[0].set_ylabel('Acc [g]')
        ax[0].legend(['x','y','z'], loc=1)
        ax[1].plot(ts,adc)
        ax[1].set_ylabel('ECG [mv]')
        ax[1].set_xlabel('Sample')
        plt.show()
        
    return data
        
#%%
if __name__ == "__main__":
    raw=custom_read_xml('C:/Users/Didrik/Dropbox/Arbeid/OUS/Data/Recorded/Surface/monitor-20181207-154327.txt')
    #raw = read_xml('../datasets/snippet/test_data2.xml')
    data = parse_xml(raw, show=True)
    
            