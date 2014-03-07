import builtins
import bz2
import io
import markov_encryption as me
import pickle

KEY, PRIMER = pickle.loads(bz2.decompress(open('security.dat', 'rb').read()))
KEY, PRIMER = me.Key(KEY), me.Primer(PRIMER)

def open(file, *, newline=''):
    with builtins.open(file, 'rb') as file:
        data = file.read()
    return io.StringIO(me.decrypt_bytes(data, KEY, PRIMER)[0].decode())
