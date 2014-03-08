import markov_encryption as me
import pickle
import pickletools
import bz2
import builtins
import codecs
import locale
import io

DATA_FILE = 'security.dat'
with builtins.open(DATA_FILE, 'rb') as file:
    KEY, PRIMER = pickle.loads(bz2.decompress(file.read()))
KEY, PRIMER = me.Key(KEY), me.Primer(PRIMER)

def replace_key_primer(force=False):
    global KEY, PRIMER
    assert force, 'Do not run this unless you know what you are doing!'
    KEY = me.Key.new(range(1 << 8), 1 << 10)
    PRIMER = me.Primer.new(KEY)
    data = pickle.dumps((KEY.data, PRIMER.data), pickle.HIGHEST_PROTOCOL)
    with builtins.open(DATA_FILE, 'wb') as file:
        file.write(bz2.compress(pickletools.optimize(data)))

def secure(path, force=False):
    assert force, 'Do not run this unless you know what you are doing!'
    engine = me.Encrypter(KEY, PRIMER)
    with builtins.open(path, 'rb') as file:
        data = engine.process(file.read())
    with builtins.open(path, 'wb') as file:
        file.write(data)

def open(path, *, encoding=None, errors=None, newline=''):
    if encoding is None:
        encoding = locale.getpreferredencoding()
    if errors is None:
        errors = 'strict'
    engine = me.Decrypter(KEY, PRIMER)
    with builtins.open(path, 'rb') as file:
        file = io.BytesIO(engine.process(file.read()))
    return codecs.lookup(encoding).streamreader(file, errors)
