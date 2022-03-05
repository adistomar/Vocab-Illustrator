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
      examples.append(((((row[4].replace("\u2018", "'")).replace("\u2019", "'")).replace("\u201c", '"')).replace("\u201d", '"')).replace("\n", ""))

def returnWord():
   global words
   global PoS
   global defs
   global examples

   word = str(random.choice(words))
   word_index = words.index(word)
   wordObject = {
      "word": word,
      "PoS": PoS[word_index],
      "definition": defs[word_index],
      "example": examples[word_index]
   }
   return wordObject

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
         example = (((((soup.find(class_="example").get_text().replace("\u2018", "'")).replace("\u2019", "'")).replace("\u201c", '"')).replace("\u201d", '"')).replace("\n", "")).strip('"')
      except:
         example = ""
   except:
      return 'Cannot find such word! Check spelling.'
   
   wordObject = {
      "word": word,
      "PoS": PoS,
      "definition": definition,
      "example": example
   }
   return wordObject