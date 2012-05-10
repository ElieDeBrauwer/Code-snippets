#!/usr/bin/env python 
'''
Created on May 10, 2012

This script echo's the most recent public paste on pastebin.com

@author: Elie De Brauwer <elie @ de-brauwer.be>
@license: Simplified BSD
'''

import urllib
import sgmllib


class PasteBinArchiveParser(sgmllib.SGMLParser):
    '''
    PasteBinArchiveParse is able to give you the most recent
    public paste on pastebin.
    '''
    
    def __init__(self):
        '''
        Constructor, initialize the parser and state machine.
        '''
        sgmllib.SGMLParser.__init__(self)
        self.result = ""
        self.done = False
        self.first_td = False

    def parse(self, page):
        '''
        Parsing of a given webpage.
        @return The URL as a string.
        '''
        self.result = ""
        self.done = False
        self.first_td = False
        self.feed(page)
        self.close()
        if self.done:
            return "http://www.pastebin.com/raw.php?i=" + self.result[1:]

        raise Exception("Failed to obtain most recent entry from archive")



    def start_td(self, attributes):
        '''
        Called when an <td> is found, the first td contains an a href which
        contains the info we're interested in.
        '''

        if not self.done and not self.first_td:
            self.first_td = True

    def start_a(self, attributes):
        '''
        Called when an <a> is found, if this ancher is in the first td 
        then we hit the jackpot.
        '''

        if not self.done and self.first_td:
            self.result = attributes[0][1]
            self.done = True 

if __name__ == '__main__':
    URL = urllib.urlopen("http://www.pastebin.com/archive")
    LAST_URL =  PasteBinArchiveParser().parse(URL.read())
    URL.close()

    #print "Source: %s" % last_paste_url
    URL = urllib.urlopen(LAST_URL)
    print "%s" % URL.read()
    URL.close()
