
def normalizetext(source):
    return u' '.join(source.replace(u'\n', u' ').strip().split()).strip()