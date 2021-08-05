"""Write a python program (not a Jupyter notebook, 
but a py file you run from the command line) that accepts the 
cats_txt.txt file as input and counts the frequency of all 
words and punctuation in that text file, ordered by frequency. 
Make sure to handle capital and lowercase versions of words and 
count them together."""


text = open('cats_txt.txt','r')
#Create a dictionary from text
import string  
from collections import Counter
# Create an empty dictionary
d = dict()
  
# Loop through each line of the file
for line in text:
    # Remove the leading spaces and newline character
    line = line.strip()
  
    # Convert the characters in line to 
    # lowercase to avoid case mismatch
    line = line.lower()
    # Remove the punctuation marks from the line
    #line = line.translate(line.maketrans("", "", string.punctuation))
    #Counts the punctuation marks
    count = lambda l1, l2: str(list(filter(lambda c: c in l2, l1)))
    line_count = count(line, string.punctuation)
    print(line_count)
    # Split the line into words
    words = sorted(line.split(" "), reverse=True)
  
    # Iterate over each word in line
    for word in words:
        # Check if the word is already in dictionary
        if word in d:
            # Increment count of word by 1
            d[word] = d[word] + 1
        else:
            # Add the word to dictionary with count 1
            d[word] = 1

# Print the contents of dictionary

for key in list(d.keys()):
    print(key, ":", d[key])
    
    
    
