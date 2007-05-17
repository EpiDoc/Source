
def getalltext(elem):
    text = elem.text or ""
    for e in elem:
        text += getalltext(e)
        if e.tail:
            text += e.tail
    return text