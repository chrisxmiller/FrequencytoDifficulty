'''
Christopher Miller
EECS349 - Spring 2018
Northwestern University
Final Project - Task difficulty selection based on user input frequency
Preprocessing step - this file picks the test and training sets and pads them
''' 


# LSTM with Dropout for sequence classification in the IMDB dataset
import numpy as np
import csv
import random
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout
from keras.layers.embeddings import Embedding
from keras.preprocessing import sequence

#Read in all CSV data
#Read in "raw" data
#dataset = np.loadtxt("combinedData.csv",delimiter=",")
dataset = np.loadtxt("doublefiltered.csv",delimiter=",")
#Read in filtered data
binclass = np.loadtxt("easyorhard.csv",delimiter=",")
top38 = np.loadtxt("top38.csv",delimiter=",")
threeclass = np.loadtxt("emh.csv",delimiter=",")

#design a train vs test set

#Train length - size of longest vector from dataset
trainlen = 4500 
#Test set size - 10% = 52
testlen = 52

testindx = []
for x in range(testlen):
	testindx.append(random.randint(1,(20*26+1)))

#Specify which dataset you're training on for results 
out = threeclass

xTrain =np.empty([520-testlen+1, trainlen])
yTrain =np.empty([520-testlen+1, 1])
traincnt = 0

xTest = np.empty([testlen, trainlen])
yTest = np.empty([testlen, 1])
testcnt = 0

#Define the training and test sets
for row in range(0,520):
	if dataset[row][0] == 1000000.0:
		print "Bad File"
	else:
		if row in testindx:
			xTest[testcnt][:] = (dataset[row][0:trainlen])
			yTest[testcnt] = out[row]
			#internal counter
			testcnt = testcnt+1
		else:
			xTrain[traincnt][:] = (dataset[row][0:trainlen])
			yTrain[traincnt] = out[row]
			#internal counter
			traincnt = traincnt+1
# NOW we start the keras stuff!

# create the model
embedding_vecor_length = 32
numLSTMs = 5

model = Sequential()
model.add(Embedding(200, embedding_vecor_length, input_length=trainlen))
model.add(LSTM(numLSTMs))
model.add(Dense(1, activation='sigmoid'))
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
print(model.summary())
model.fit(xTrain, yTrain, epochs=10, batch_size=64)
# Final evaluation of the model
scores = model.evaluate(xTest, yTest, verbose=0)
print("Accuracy: %.2f%%" % (scores[1]*100))
