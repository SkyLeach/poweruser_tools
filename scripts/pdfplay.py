#!python
import pprint
from PyPDF2 import PdfFileReader

fn = "C:/Users/mattg/AppData/Local/Temp/Howto-do-stuff-in-FatDog.pdf"

def getDocInfo():
    with open(fn, "rb") as pdfile:
        inputPdf = PdfFileReader(pdfile)
        docInfo = inputPdf.getDocumentInfo()
        pprint.pprint(docInfo)
        print(docInfo)
        print(repr(docInfo))
        pprint.pprint(docInfo.author)
        pprint.pprint(docInfo.creator)
        pprint.pprint(docInfo.producer)
        pprint.pprint(docInfo.title)
        pprint.pprint(docInfo.subject)

if __name__ == "__main__":
    getDocInfo()
