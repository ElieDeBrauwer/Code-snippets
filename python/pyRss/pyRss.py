#!/usr/bin/env python 

'''
Created on May 26, 2010

Displays the last number of entries of a given rss feed. 
Depends on the html2text, feedparser, option parser and logging 
Python modules. 

@author: Elie De Brauwer <elie @ de-brauwer.be>
@license: Simplified BSD
'''

import feedparser
import sys
import logging
from html2text import html2text
from optparse import OptionParser

VERSION = "0.1"

class RssReader:
    
    def __init__(self, url):
        '''
        Constructor
        '''
        self.d = feedparser.parse(url)
        if self.d['feed'] == {} or self.d['bozo'] == 1:
            logging.error("Error parsing feed.")
            if self.d['bozo'] == 1:
                logging.error("Error %s" % self.d['bozo_exception'])
                
    def dumpFeedInfo(self):
        """
        Dump general feed information.
        """
        
        print "Title: %s " % self.d.feed.title 
        print "Last build date: %s" % self.d.feed.lastbuilddate 
        print "Link: %s" % self.d.feed.links[0].href
        
    def dumpEntries(self):
        """
        Dump all entries
        """
        
        num = len(self.d.entries)
        for i in range(num):
            print "Dump entry %d" % i
            self.displayEntry(i)
            print "\n"
            
    def displayEntry(self, num):
        """
        Display a certain entry.
        """

        if num < len(self.d.entries):
            print "%s by %s on %s " % \
                                    (self.d.entries[num].title,
                                     self.d.entries[num].author,
                                     self.d.entries[num].updated)
            print "Link: %s" % self.d.entries[num].link
            print "%s" % html2text(self.d.entries[num].summary)
        

def main(argv):
    usage = "usage: %prog [options]"
    version = "%sprog %s" % ('%', VERSION)
    parser = OptionParser(usage, version=version)
    parser.add_option("-f", "--feed", dest="feed_url",
                      default='http://rss.slashdot.org/Slashdot/slashdot',
                      help="the feed to get [default: %default]")
    parser.add_option("-n", "--num", type="int", dest="num_entries",
                      default=5,
                      help="the number of entries to show [default %default]")
    parser.add_option("-l", "--log-level", dest="log_level",
                      default='INFO',
                      help="the log-level of the logger [default %default]",
                      choices=["DEBUG", "INFO", "WARNING", "CRITICAL", 
                               "ERROR"])
    (options, args) = parser.parse_args(argv)
    
    logging.basicConfig(level=getattr(logging, options.log_level),
                        format='%(asctime)s %(levelname)-8s %(message)s',
                        datefmt='%m-%d %H:%M:%S')

    logging.debug("Application starting")
    logging.debug("Arguments:")
    logging.debug("   feed: %s" % options.feed_url)
    logging.debug("   num: %d" % options.num_entries)
    
    reader = RssReader(options.feed_url)
    
    for i in range(options.num_entries):
        reader.displayEntry(i)
    
if __name__ == '__main__':
    main(sys.argv[1:])
