import csv
import random

words = []
PoS = []
defs = []
examples = []

with open('words.csv') as csv_file:
   csv_reader = csv.reader(csv_file, delimiter=',')
   for row in csv_reader:
      words.append(row[1])
      PoS.append(row[2])
      defs.append(row[3])
      examples.append(row[4])

def getWord():
   global words
   global PoS
   global defs
   global examples

   word = str(random.choice(words))
   word_index = words.index(word)
   return (word, PoS[word_index], defs[word_index], examples[word_index])

print(getWord())