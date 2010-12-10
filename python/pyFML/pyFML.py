#!/usr/bin/python

'''
Created on December 10, 2010

This scripts gets a random set of quotes from http://www.fmylife.com 
and outputs these on standard output. I personally use this as an input
generator for my screensaver, with a fallback to fortune -o for the 
case the I have no internet connection available. 
Depends on urllib and sgmllib.

@author: Elie De Brauwer <elie @ de-brauwer.be>
@license: Simplified BSD
'''
import urllib
import sgmllib

VERSION = "0.1"

class FMyLifeParser(sgmllib.SGMLParser):
    '''
    FMyLifeParser extends the SGMLParser and ascii-fies a fmylife.com page.
    '''

    def __init__(self):
        '''
        Constructor, initialize the parser and state machine.
        '''
        sgmllib.SGMLParser.__init__(self)
        self.in_quote = False 
        self.buff = ""

    def parse(self, page):
        '''
        Parsing of a given webpage.
        '''
        self.feed(page)
        self.close()

    def start_a(self, attributes):
        '''
        Called when an <a> is found, if the calls is an 'fmllink' then we
        are interested in its content. When a new quote is started we 
        output the previous one.
        '''
        try:
            if attributes[1][0] == "class" and attributes[1][1] == "fmllink":
                self.in_quote = True
            elif self.buff != "":
                self.in_quote = False
                print "%s \n" % self.buff
                self.buff = ""
        except IndexError:
            # No quote, ignore
            pass

    def handle_data(self, data):
        '''
        When we are handing a quote, then we concatenate the contents.
        '''
        if self.in_quote:
            self.buff = self.buff + data.strip()

    def end_a(self):
        '''
        Called when a </a> is found.
        '''
        self.in_quote = False


if __name__ == '__main__':
    URL = urllib.urlopen("http://www.fmylife.com/random")
    FMyLifeParser().parse(URL.read())
    URL.close()


