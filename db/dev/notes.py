Python 3.2.5 (default, May 15 2013, 23:06:03) [MSC v.1500 32 bit (Intel)] on win32
Type "copyright", "credits" or "license()" for more information.
>>> ================================ RESTART ================================
>>> 
>>> pivot.keys()
dict_keys(['Zip', 'Telephone', 'Comments (Done?)', 'Contact', 'Arrow', 'Address', 'Calendar', 'Company Name (print your name)', 'City, State'])
>>> ZIP = tuple(set(filter(None, pivot['Zip'])))
>>> def generate_zip():
	while True:
		yield random.choice(ZIP)

		
>>> z = generate_zip()
>>> next(z)
'36561'
>>> next(z)
'36527'
>>> next(z)
'36526'
>>> next(z)
'32524'
>>> next(z)
'36619'
>>> next(z)
'32503'
>>> def extract_contact_parts(row):
    contact = row['Contact']
    row['contact_fname'] = row['contact_lname'] = row['contact_title'] = ''
    if contact:
        parts = contact.split()
        if parts[0] in {'Mr.', 'Mrs.', 'Dr.', 'Miss'}:
            row['contact_title'] = parts.pop(0)
        assert parts, 'Parts should not be empty!'
        if len(parts) == 1:
            row['contact_fname'] = parts[0]
        else:
            *first_name, last_name = parts
            row['contact_fname'] = ' '.join(first_name)
            row['contact_lname'] = last_name

            
>>> type(table)
<class 'list'>
>>> ================================ RESTART ================================
>>> 
>>> pivot.keys()
dict_keys(['Zip', 'contact_lname', 'Address', 'Telephone', 'Comments (Done?)', 'Contact', 'Arrow', 'contact_fname', 'Calendar', 'Company Name (print your name)', 'contact_title', 'City, State'])
>>> set(contact_title)
Traceback (most recent call last):
  File "<pyshell#17>", line 1, in <module>
    set(contact_title)
NameError: name 'contact_title' is not defined
>>> set(pivot['contact_title'])
{'', 'Mr.', 'Miss', 'Mrs.', 'Dr.'}
>>> set(pivot['contact_lname'])
{'', 'Hirst', 'Dunbar', 'Paris', 'Barnes', 'Wei', 'Kowal', 'Smith', 'Fuqua', 'Phillips', 'Canady', 'Bellanova', 'Vick???', 'Porter', 'Shaw', 'Kathy', 'Cowan', 'Epstein', 'Cochran', 'Maxwell', 'Leonard', 'Sellers', 'Hedges', 'Rankins', 'Fisher', 'Jeary', 'Atkins', 'Rimmer', 'Agency', 'McKinnon', 'Leatherberry', 'Palomares', 'Winn', 'Nelson', 'Solis', 'Thomas', 'Maghee', 'Weekley', 'Harkins', 'Sowell', 'Stolt', 'Cartwright', 'Koury', 'Worch', 'Bekele', 'Tan', 'Jackson', 'Christim', 'Howard', 'Steele', 'Brandenburg', 'Denman', 'Anderson', 'Mandel', 'Stenerson', 'Collins', 'Gonsalves', 'Ross', 'Nadolny', 'Merritt', 'Avery', 'Sheffield', 'Bobe', 'Yates', 'Gahimer', 'See', 'Ford', 'Nguyen', 'Reed', 'Rademacher', 'Deane', 'Yelverton', 'Johnson', 'Mullen', 'Galloway', 'Loughridge', 'Wiessner', 'Strobel', 'Green', 'Glover', 'Zephir?', 'Ivey', 'Epstien', 'Willem', 'Fillingim', 'Kierce', 'Spann', 'Bowen', 'Eubanks', 'Willey', 'Ohman', 'Vasconcelos???', 'Graham', 'Newlin', 'Drew???', 'Hadley', 'Finger', 'Graves', 'Messina', 'Cook???', 'Carr', 'Bernhardt', 'Fell', 'Ciccone', 'Hermetz', 'Evers', 'Deloney', 'Hollman', 'Snyder', 'Choi', 'Rodriquez', 'Pitt', 'Armentrout', 'Nager', 'Searcy', 'Neyra', 'Fifer', 'Palaguta', 'Thomas???', 'Nobles', 'Clark', 'Buckner', 'Howlett', 'Lee???', 'Ragsdale', 'Hurst', 'Miller', 'Wade', 'Talamo', 'Oliver', 'Cheng', 'Theriot', 'Cummins', 'Cassy', 'Douglas', 'Dodson', 'Galvan', 'Milligan', 'Murph', 'Shields', 'Williams', 'McDaniel', 'Carlisle???', 'Glumac', 'Murphy', 'Kinderman', 'Stoodt', 'Picou', 'Kepko', 'Mitchell', 'Tanner', 'Hackney', 'Stafford', 'Jones', 'Stamitoles', 'Harville', 'Fields', 'Fitzpatrick', 'Beckman', 'Newby', 'Wong', 'Coe', 'Prescott', 'Joiner', 'LeFevre', 'Bond', 'Hornsby', 'Cornelius', 'Constant', 'Dowler', 'Robinson', 'Groce', 'Matson', 'Paruch', 'Bombard', 'Moran', 'Chen', 'Wheelus', 'Heinold', 'Addison???', 'Porras???'}
>>> set(pivot['contact_fname'])
{'', 'Glen & Cynthia', 'Matt', 'Jay', 'Jan', 'Wayne', 'J.D.', 'Lesli', 'A.', 'Kurt', 'Kathy', 'Sharlyn', 'Barbara', 'Dan', 'Dao', 'Higiuio', 'Brooks', 'Fred', 'Margaret', 'Jacob', 'Philip', 'A. E.', 'Homer', 'Michael', 'Candy', 'Crystal', 'Betty', 'Rodney', 'Summer', 'Darrin', 'Chung', 'Zhiwei', 'Troy', 'Daniel', 'Allen', 'Paul', 'Suzanne', 'Sandy', 'Leanne', 'Zoe', 'Mark', 'Kristi', 'Eddy', 'Joseph', 'Derek', 'Silvana', 'Alex', 'John', 'Mary', 'Carole', 'Ross', 'Shawna', 'Mike', 'Frank', 'Thaddeus', 'Joe', 'Belinda', 'Terry', 'Chris', 'Mary Kaye', 'Valerie', 'Susan', 'Charlie', 'Bill', 'David', 'Judy', 'Lindsey', 'Bob', 'Stephanie', 'Dana', 'Chad', 'Rob', 'Meagan', 'Rhanh', 'Roy', 'Karen', 'Doug', 'Dawn', 'Shelley', 'Eric', 'Katie', 'Terry & Eric', 'Robert', 'Isidro', 'Aaron', 'Rhoda', 'Tom', 'Basil', 'Hank', 'Sonia', 'Chantea', 'Shawn', 'Kitty', 'Amy', 'Larry', 'Tammy', 'Sarah', 'Stan', 'Finis Calvert/Arthur', 'Christina', 'Rocky', 'Christine', 'Robert/Wendy', 'Roger', 'Beverly', 'Jo Ann', 'Gene', 'Chelsea', 'Dee', 'Haile', 'Chloe', 'Jeff', 'Craig', 'Andy', 'Peter', 'Sharon', 'Richard', 'Jodi', 'Angela', 'Tim', 'Rachia', 'Danielle', 'Linda', 'Wyndell', 'Pam', 'Cheryl', 'Jake', 'Hannah', 'Luke', 'Felicita', 'Virginia', 'Suansee', 'Kay', 'Gerry', 'Lynn', 'Don', 'Daren', 'Marian', 'Mickie', 'Joyce', 'Didi', 'Steve', 'Ryan', 'Greg', 'Cindy', 'Martin', 'Kelly', 'Lisa', 'Joey', 'Billy', 'Gavin', 'Philip Renfroe or', 'Scott', 'Tonita', '???', 'uses Appleyard', 'Adam'}
>>> 
>>> 
>>> 
>>> title = set()
>>> fname = set()
>>> lname = set()
>>> for value in filter(None, pivot['contact_title']):
	title.add(value)

	
>>> title
{'Mr.', 'Miss', 'Mrs.', 'Dr.'}
>>> for value in filter(str.isalpha, pivot['contact_fname']):
	fname.add(value)

	
>>> fname
{'Sarah', 'Matt', 'Jay', 'Jan', 'Wayne', 'Lesli', 'Kathy', 'Sharlyn', 'Barbara', 'Dan', 'Dao', 'Higiuio', 'Brooks', 'Fred', 'Margaret', 'Jacob', 'Philip', 'Homer', 'Michael', 'Candy', 'Crystal', 'Betty', 'Rodney', 'Summer', 'Darrin', 'Chung', 'Zhiwei', 'Troy', 'Daniel', 'Allen', 'Paul', 'Suzanne', 'Sandy', 'Leanne', 'Zoe', 'Mark', 'Kristi', 'Eddy', 'Joseph', 'Derek', 'Silvana', 'Alex', 'John', 'Mary', 'Carole', 'Ross', 'Shawna', 'Mike', 'Frank', 'Thaddeus', 'Joe', 'Belinda', 'Terry', 'Chris', 'Valerie', 'Susan', 'Charlie', 'Bill', 'David', 'Judy', 'Lindsey', 'Bob', 'Stephanie', 'Dana', 'Chad', 'Rob', 'Meagan', 'Rhanh', 'Roy', 'Karen', 'Doug', 'Dawn', 'Shelley', 'Eric', 'Katie', 'Robert', 'Isidro', 'Aaron', 'Rhoda', 'Tom', 'Basil', 'Hank', 'Sonia', 'Chantea', 'Shawn', 'Kitty', 'Amy', 'Larry', 'Tammy', 'Stan', 'Christina', 'Rocky', 'Christine', 'Roger', 'Beverly', 'Kurt', 'Gene', 'Chelsea', 'Dee', 'Haile', 'Chloe', 'Jeff', 'Craig', 'Andy', 'Peter', 'Sharon', 'Richard', 'Jodi', 'Angela', 'Tim', 'Rachia', 'Danielle', 'Linda', 'Wyndell', 'Pam', 'Cheryl', 'Jake', 'Hannah', 'Luke', 'Felicita', 'Virginia', 'Suansee', 'Kay', 'Gerry', 'Lynn', 'Don', 'Daren', 'Marian', 'Mickie', 'Joyce', 'Didi', 'Steve', 'Ryan', 'Greg', 'Cindy', 'Martin', 'Kelly', 'Lisa', 'Joey', 'Billy', 'Gavin', 'Scott', 'Tonita', 'Adam'}
>>> LNAME = tuple({n for n in pivot['contact_lname'] if n.isalpha()})
>>> LNAME
('Hirst', 'Dunbar', 'Paris', 'Barnes', 'Wei', 'Kowal', 'Smith', 'Fuqua', 'Phillips', 'Canady', 'Bellanova', 'Porter', 'Shaw', 'Kathy', 'Cowan', 'Cochran', 'Maxwell', 'Leonard', 'Sellers', 'Hedges', 'Rankins', 'Fisher', 'Jeary', 'Atkins', 'Rimmer', 'Agency', 'McKinnon', 'Leatherberry', 'Palomares', 'Winn', 'Nelson', 'Solis', 'Thomas', 'Maghee', 'Weekley', 'Harkins', 'Sowell', 'Stolt', 'Cartwright', 'Koury', 'Worch', 'Bekele', 'Tan', 'Jackson', 'Christim', 'Howard', 'Steele', 'Brandenburg', 'Denman', 'Anderson', 'Mandel', 'Stenerson', 'Collins', 'Gonsalves', 'Ross', 'Nadolny', 'Merritt', 'Avery', 'Sheffield', 'Bobe', 'Yates', 'Gahimer', 'See', 'Ford', 'Nguyen', 'Reed', 'Rademacher', 'Deane', 'Yelverton', 'Johnson', 'Mullen', 'Galloway', 'Loughridge', 'Wiessner', 'Strobel', 'Green', 'Glover', 'Ivey', 'Epstien', 'Willem', 'Fillingim', 'Kierce', 'Spann', 'Bowen', 'Eubanks', 'Willey', 'Ohman', 'Cornelius', 'Graham', 'Newlin', 'Hadley', 'Finger', 'Graves', 'Messina', 'Carr', 'Bernhardt', 'Fell', 'Ciccone', 'Hermetz', 'Evers', 'Deloney', 'Hollman', 'Snyder', 'Choi', 'Tanner', 'Pitt', 'Armentrout', 'Nager', 'Searcy', 'Neyra', 'Fifer', 'Palaguta', 'Nobles', 'Clark', 'Buckner', 'Howlett', 'Ragsdale', 'Hurst', 'Miller', 'Wade', 'Talamo', 'Oliver', 'Cheng', 'Theriot', 'Cummins', 'Cassy', 'Douglas', 'Dodson', 'Galvan', 'Milligan', 'Murph', 'Shields', 'Williams', 'McDaniel', 'Groce', 'Glumac', 'Murphy', 'Kinderman', 'Stoodt', 'Picou', 'Kepko', 'Mitchell', 'Rodriquez', 'Hackney', 'Stafford', 'Jones', 'Stamitoles', 'Harville', 'Fields', 'Fitzpatrick', 'Beckman', 'Newby', 'Wong', 'Coe', 'Prescott', 'Joiner', 'LeFevre', 'Bond', 'Hornsby', 'Constant', 'Dowler', 'Robinson', 'Matson', 'Paruch', 'Bombard', 'Moran', 'Chen', 'Wheelus', 'Heinold', 'Epstein')
>>> def generate_contact():
	used = set()
	while True:
		name = '{} {} {}'.format(random.choice(TITLE),
					 random.choice(FNAME),
					 random.choice(LNAME))
		if name not in used:
			used.add(name)
			yield name

			
>>> TITLE = tuple({n for n in pivot['contact_title'] if n})
>>> FNANE = tuple({n for n in pivot['contact_fname'] if n.isalpha()})
>>> 
>>> c = generate_contact()
>>> next(c)
Traceback (most recent call last):
  File "<pyshell#52>", line 1, in <module>
    next(c)
  File "<pyshell#47>", line 5, in generate_contact
    random.choice(FNAME),
NameError: global name 'FNAME' is not defined
>>> FNAME = FNANE
>>> next(c)
Traceback (most recent call last):
  File "<pyshell#54>", line 1, in <module>
    next(c)
StopIteration
>>> c = generate_contact()
>>> next(c)
'Mr. Allen Mullen'
>>> next(c)
'Miss Rodney Stoodt'
>>> next(c)
'Dr. Virginia Finger'
>>> next(c)
'Mr. Christine Collins'
>>> next(c)
'Mrs. Frank Groce'
>>> next(c)
'Mrs. Craig Graham'
>>> next(c)
'Dr. Doug Fillingim'
>>> next(c)
'Mrs. Kristi Newlin'
>>> next(c)
'Mrs. Lindsey Ragsdale'
>>> next(c)
'Dr. Jake Deane'
>>> next(c)
'Miss Greg Deloney'
>>> next(c)
'Dr. Charlie Christim'
>>> next(c)
'Miss Dawn Barnes'
>>> next(c)
'Miss Adam Johnson'
>>> next(c)
'Mr. Amy Smith'
>>> next(c)
'Mr. Shawn Fisher'
>>> ================================ RESTART ================================
>>> 
>>> pivot.keys()
dict_keys(['Zip', 'contact_lname', 'Address', 'Telephone', 'Comments (Done?)', 'Contact', 'Arrow', 'contact_fname', 'Calendar', 'Company Name (print your name)', 'contact_title', 'City, State'])
>>> len(set(pivot['Telephone']))
370
>>> import re
>>> help(re.match)
Help on function match in module re:

match(pattern, string, flags=0)
    Try to apply the pattern at the start of the string, returning
    a match object, or None if no match was found.

>>> help(re.search)
Help on function search in module re:

search(pattern, string, flags=0)
    Scan through string looking for a match to the pattern, returning
    a match object, or None if no match was found.

>>> for number in pivot['Telephone']:
	if re.search('\A(17\s*-\s*\d{4}\s*-\s*[1-4]|((\d{3}\s*-\s*){1,2}\d{4})?(\s*[Ee][Xx][Tt]\.?\s*\d{1,7})?)\Z', number) is None:
		print(number)

		
432-????
453-NAVY
475-3853, x120
(954) 735-9600
916-4600 x228
x2647
x2647
x2012
x3140
x2647
x3049
x2832
x3049
617-699-8878???
781-324-2000 x161
???
>>> TELEPHONE_REGEX = r'\A(17\s*-\s*\d{4}\s*-\s*[1-4]|((\d{3}\s*-\s*){1,2}\d{4})?(\s*[Ee][Xx][Tt]\.?\s*\d{1,7})?)\Z'
>>> help(str.strip)
Help on method_descriptor:

strip(...)
    S.strip([chars]) -> str
    
    Return a copy of the string S with leading and trailing
    whitespace removed.
    If chars is given and not None, remove characters in chars instead.

>>> PHONE_TRANS = str.maketrans('ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                            '22233344455566677778889999')
>>> def scrub_telephone_number(row):
	number = row['Telephone'].strip('?')
	if re.search(TELEPHONE_REGEX, number) is None:
		
