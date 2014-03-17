import bisect
import csv
import functools
import glob
import itertools
import random

################################################################################

class WeightedStrings:

    def __init__(self, data):
        if not isinstance(data, dict):
            raise TypeError('Data must be of type dict!')
        data, keys, values = data.copy(), [], []
        for key, value in sorted(data.items()):
            if not isinstance(key, str):
                raise TypeError('Keys must be of type str!')
            if not isinstance(value, int):
                raise TypeError('Values must be of type int!')
            keys.append(key)
            values.append(value)
        self.__data, self.__keys, self.__values, self.__hash = \
            data, tuple(keys), tuple(values), None

    def __contains__(self, item):
        return item in self.__data

    def __eq__(self, other):
        return self.keys == other.keys and self.values == other.values

    def __getitem__(self, key):
        return self.__data[key]

    def __hash__(self):
        if self.__hash is None:
            self.__hash = hash(self.keys) ^ hash(self.values)
        return self.__hash

    def __iter__(self):
        return iter(self.keys)

    def __len__(self):
        return len(self.__data)

    def __ne__(self, other):
        return self.keys != other.keys or self.values != other.values

    def __repr__(self):
        return '{!s}({!r})'.format(self.__class__.__name__, self.__data)

    def get(self, key, default=None):
        return self.__data.get(key, default)

    @property
    def keys(self):
        return self.__keys

    @property
    def values(self):
        return self.__values

    @property
    def items(self):
        return zip(self.keys, self.values)

################################################################################

class WeightedRandom:

    def __init__(self, data):
        self.__data = data
        self.__total = tuple(itertools.accumulate(data.values))
        self.__range = functools.partial(random.SystemRandom().randrange,
                                         self.__total[-1])

    def __iter__(self):
        return self

    def __next__(self):
        return self.__data.keys[bisect.bisect(self.__total, self.__range())]

################################################################################

class WeightedNames:

    def __init__(self, pattern, name, weight):
        data = {}
        for path in glob.iglob(pattern):
            with open(path, newline='') as file:
                for row in csv.DictReader(file, dialect='excel-tab'):
                    data[row[name]] = int(row[weight].replace(',', ''))
        self.__iter = iter(WeightedRandom(WeightedStrings(data)))

    def __iter__(self):
        return self

    def __next__(self):
        return next(self.__iter).capitalize()
