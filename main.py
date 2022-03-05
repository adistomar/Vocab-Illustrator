import csv
import random
from PyDictionary import PyDictionary
import urllib.request
from bs4 import BeautifulSoup

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

def returnWord():
   global words
   global PoS
   global defs
   global examples

   word = str(random.choice(words))
   word_index = words.index(word)
   return (word, PoS[word_index], defs[word_index], examples[word_index])

def getWord(word):
   word = str(word)
   dictionary = PyDictionary()

   url = "https://www.vocabulary.com/dictionary/" + word + ""
   htmlfile = urllib.request.urlopen(url)
   soup = BeautifulSoup(htmlfile, 'lxml')

   try:
      definition = dictionary.meaning(word)
      PoS = list(definition.keys())[0].lower()
      definition = list(definition.items())[0][1][0]
      try:
         example = soup.find(class_="example").get_text().replace("\n", "")
      except:
         example = ""
   except:
      return 'Cannot find such word! Check spelling.'
   
   return (word, PoS, definition, example)

