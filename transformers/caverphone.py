import re

# grapheme to phoneme G2P
# https://github.com/cmusphinx/g2p-seq2seq
# https://isi.edu/~aderi/papers/g2p.pdf
# http://www.aclweb.org/anthology/W/W17/W17-5403.pdf
# https://github.com/unixpickle/neuralspell

def caverphone(term):
	"""returns the language key using the caverphone algorithm 2.0"""

	# Developed at the University of Otago, New Zealand.
	# Project: Caversham Project (http://caversham.otago.ac.nz)
	# Developer: David Hood, University of Otago, New Zealand
	# Contact: caversham@otago.ac.nz
	# Project Technical Paper: http://caversham.otago.ac.nz/files/working/ctp150804.pdf
	# Version 2.0 (2004-08-15)

	code = ''
	term_length = len(term)
	if (term_length == 0):
		# empty string ?
		return code
	# end if

	# convert to lowercase
	code = term.lower()

	# remove anything not in the standard alphabet (a-z)
	code = re.sub(r'[^a-z]', '', code)

	# remove final e
	if code.endswith('e'):
		code = code[:-1]

	# if the name starts with cough, rough, tough, enough or trough -> cou2f (rou2f, tou2f, enou2f, trough)
	code = re.sub(r'^([crt]|(en)|(tr))ough', r'\1ou2f', code)

	# if the name starts with gn -> 2n
	code = re.sub(r'^gn', r'2n', code)

	# if the name ends with mb -> m2
	code = re.sub(r'mb$', r'm2', code)

	# replace cq -> 2q
	code = re.sub(r'cq', r'2q', code)

	# replace c[i,e,y] -> s[i,e,y]
	code = re.sub(r'c([iey])', r's\1', code)

	# replace tch -> 2ch
	code = re.sub(r'tch', r'2ch', code)

	# replace c,q,x -> k
	code = re.sub(r'[cqx]', r'k', code)

	# replace v -> f
	code = re.sub(r'v', r'f', code)

	# replace dg -> 2g
	code = re.sub(r'dg', r'2g', code)

	# replace ti[o,a] -> si[o,a]
	code = re.sub(r'ti([oa])', r'si\1', code)

	# replace d -> t
	code = re.sub(r'd', r't', code)

	# replace ph -> fh
	code = re.sub(r'ph', r'fh', code)

	# replace b -> p
	code = re.sub(r'b', r'p', code)

	# replace sh -> s2
	code = re.sub(r'sh', r's2', code)

	# replace z -> s
	code = re.sub(r'z', r's', code)

	# replace initial vowel [aeiou] -> A
	code = re.sub(r'^[aeiou]', r'A', code)

	# replace all other vowels [aeiou] -> 3
	code = re.sub(r'[aeiou]', r'3', code)

	# replace j -> y
	code = re.sub(r'j', r'y', code)

	# replace an initial y3 -> Y3
	code = re.sub(r'^y3', r'Y3', code)

	# replace an initial y -> A
	code = re.sub(r'^y', r'A', code)

	# replace y -> 3
	code = re.sub(r'y', r'3', code)

	# replace 3gh3 -> 3kh3
	code = re.sub(r'3gh3', r'3kh3', code)

	# replace gh -> 22
	code = re.sub(r'gh', r'22', code)

	# replace g -> k
	code = re.sub(r'g', r'k', code)

	# replace groups of s,t,p,k,f,m,n by its single, upper-case equivalent
	for single_letter in ['s', 't', 'p', 'k', 'f', 'm', 'n']:
		otherParts = re.split(single_letter + '+', code)
		# code = string.join(otherParts, string.upper(single_letter))
		code = single_letter.upper().join(otherParts)

	# replace w[3,h3] by W[3,h3]
	code = re.sub(r'w(h?3)', r'W\1', code)

	# replace final w with 3
	code = re.sub(r'w$', r'3', code)

	# replace w -> 2
	code = re.sub(r'w', r'2', code)

	# replace h at the beginning with an A
	code = re.sub(r'^h', r'A', code)

	# replace all other occurrences of h with a 2
	code = re.sub(r'h', r'2', code)

	# replace r3 with R3
	code = re.sub(r'r3', r'R3', code)

	# replace final r -> 3
	code = re.sub(r'r$', r'3', code)

	# replace r with 2
	code = re.sub(r'r', r'2', code)

	# replace l3 with L3
	code = re.sub(r'l3', r'L3', code)

	# replace final l -> 3
	code = re.sub(r'l$', r'3', code)

	# replace l with 2
	code = re.sub(r'l', r'2', code)

	# remove all 2's
	code = re.sub(r'2', r'', code)

	# replace the final 3 -> A
	code = re.sub(r'3$', r'A', code)

	# remove all 3's
	code = re.sub(r'3', r'', code)

	return code ##

	# extend the code by 10 '1' (one)
	code += '1' * 10

	# take the first 10 characters
	caverphoneCode = code[:10]

	# return caverphone code
	return caverphoneCode
