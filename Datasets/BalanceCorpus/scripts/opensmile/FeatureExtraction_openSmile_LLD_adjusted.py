# Constants
from config.constants import *

# General Purpose
import audiofile
import opensmile
import subprocess

###################Low Level Descriptors##############################

#determine the version of the model 
smilelld = opensmile.Smile(
    feature_set= opensmile.FeatureSet.ComParE_2016, #feature set
    feature_level=opensmile.FeatureLevel.LowLevelDescriptors, #feature level
    loglevel=2, 
    logfile='smile.log'
)

Batch = "103_203"

for file1 in os.listdir(os.path.join(AUDIO_PATH, Batch)):
    if file1.endswith(".wav"):
        file = (os.path.join(AUDIO_PATH, Batch, file1))
        print(file)
        #upload the file
        #signal, sampling_rate = audiofile.read(
        #file,
        #always_2d=True,
    #)   
        #extract features 
        output_LLD=smilelld.process_file(file)

        output_LLD = output_LLD.reset_index().drop(columns=['file'])
        output_LLD = output_LLD.set_index('end')

    #output_LLD_33 = output_LLD.resample('33.33ms').mean() #resample to 33.3ms 

        #add file name in the dataframe 
        output_LLD["file_path"] = file1
        #output_LLD['frame_number'] = range(0,output_LLD.shape[0])
        file_conv = file1.replace('.wav', '')
        output_LLD.to_csv(os.path.join(OUTPUT_PATH, Batch,'Compare_LLD_{}.csv'.format(file_conv)))