import csv

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

print(words)
print(PoS)
print(defs)
print(examples)