import Tkinter
from Tkinter import *

import tools.cx.constants as constants
import tools.cx.CXController as CXController
from tools.dashboard.DatabaseQuery import DatabaseQuery
import tools.cx.DumpCSV as DumpCSV

from threading import Thread


def getDisplayVal(rootStr, channel):
    return "%s (c. %u)"%(rootStr, channel)

class ControlFrame(Frame):

    DEFAULT_TYPE_STRING = "All Types"
    ROUTERS_STR = "Routers"
    SUBNETWORK_STR = "Manual Subnetwork"
    GLOBAL_STR = "Global"
    DEFAULT_DOWNLOAD_TARGET = (getDisplayVal(SUBNETWORK_STR, 
      constants.CHANNEL_SUBNETWORK_DEFAULT), 
      constants.NS_SUBNETWORK, 
      constants.CHANNEL_SUBNETWORK_DEFAULT)    
    DEFAULT_SITE_STRING = "All Sites"
    SPACING = 10
    DEFAULT_DATA_DIR = "data"
    MASTER_ID=21

    def __init__(self, parent, hub, dbFile, **args):
        Frame.__init__(self, parent, **args)
        
        self.db = DatabaseQuery(dbFile)
        self.dbFile = dbFile
        self.hub = hub
        self.channels = [0, 31, 63, 95, 159, 191, 223]
        
        self.initUI()


    def initUI(self):

        #
        #
        #
        self.allFrame = Frame(self, padx=self.SPACING)
        
        self.allLabel = Label(self.allFrame, text="All: ")
        self.allLabel.grid(column=0, row=0)
        
        self.allTypeVar = StringVar()        
        self.allTypeVar.set(self.DEFAULT_TYPE_STRING)
        self.allTypeOption = OptionMenu(self.allFrame, self.allTypeVar, [self.DEFAULT_TYPE_STRING])
        self.allTypeOption.config(state=DISABLED)
        self.allTypeOption.config(width=len(self.DEFAULT_TYPE_STRING))
        self.allTypeOption.grid(column=1, row=0)
        
        self.allButton = Button(self.allFrame, text="Select", command=self.selectAll)
        self.allButton.grid(column=2, row=0)
        
        self.allFrame.grid(column=0, row=0)


        #
        #
        #
        self.siteFrame = Frame(self, padx=self.SPACING)
        
        self.siteLabel = Label(self.siteFrame, text="Site: ")
        self.siteLabel.grid(column=0, row=0)
        
        self.siteSiteVar = StringVar()        
        self.siteSiteVar.set(self.DEFAULT_SITE_STRING)
        self.siteSiteOption = OptionMenu(self.siteFrame, self.siteSiteVar, [self.DEFAULT_SITE_STRING])
        self.siteSiteOption.config(state=DISABLED)
        self.siteSiteOption.config(width=len(self.DEFAULT_SITE_STRING))
        self.siteSiteOption.grid(column=1, row=0)

        self.siteTypeVar = StringVar()        
        self.siteTypeVar.set(self.DEFAULT_TYPE_STRING)
        self.siteTypeOption = OptionMenu(self.siteFrame, self.siteTypeVar, [self.DEFAULT_TYPE_STRING])
        self.siteTypeOption.config(state=DISABLED)
        self.siteTypeOption.config(width=len(self.DEFAULT_TYPE_STRING))
        self.siteTypeOption.grid(column=2, row=0)

        self.siteButton = Button(self.siteFrame, text="Select", command=self.selectSite)
        self.siteButton.grid(column=3, row=0)

        self.siteFrame.grid(column=1, row=0)
        
        #
        #
        #
        self.commitFrame = Frame(self, padx=self.SPACING)
        self.commitButton = Button(self.commitFrame, text="Commit Changes", command=self.commitChanges)
        self.commitButton.grid(column=0, row=0)
        self.commitFrame.grid(column=2, row=0)
        
        #
        self.downloadFrame = Frame(self, padx=self.SPACING)
        self.downloadLabel = Label(self.downloadFrame,
          text="Download From:")
        self.downloadLabel.grid(column=0, row=0)

        self.downloadVar = StringVar()
        self.downloadOption = OptionMenu(self.downloadFrame,
          self.downloadVar, [])
        self.updateDownloadOptions({})
        self.selectDownloadTarget(self.DEFAULT_DOWNLOAD_TARGET)
        self.downloadOption.grid(column=1, row=0)

        self.downloadButton = Button(self.downloadFrame, text="Download", command=self.download)
        self.downloadButton.grid(column=2, row=0)
        self.downloadFrame.grid(column=3, row=0)
        #self.refreshButton = Button(self, text="Refresh", command=self.refresh)
        #self.refreshButton.grid(column=2, row=0)

        
   
    def addDownloadOption(self, menu, rootStr, networkSegment, channel):
        displayVal = getDisplayVal(rootStr, channel)
        menu.add_command(label=displayVal,
          command = lambda target=(displayVal, networkSegment, channel):
            self.selectDownloadTarget(target))
        
    def updateDownloadOptions(self, siteChannels):
        menu = self.downloadOption["menu"]
        menu.delete(0, "end")
        self.addDownloadOption(menu, self.ROUTERS_STR, 
          constants.NS_ROUTER, 
          constants.CHANNEL_ROUTER)
        self.addDownloadOption(menu, self.GLOBAL_STR,
          constants.NS_GLOBAL, 
          constants.CHANNEL_GLOBAL)
        for channel in sorted(siteChannels):
            self.addDownloadOption(menu, 
              siteChannels[channel], 
              constants.NS_SUBNETWORK,
              channel)
        for channel in self.channels:
            self.addDownloadOption(menu, self.SUBNETWORK_STR,
              constants.NS_SUBNETWORK, 
              channel)

    def updateSites(self, sites):
        """ Populates drop-down menu with available sites.
            Called from redrawAllNodes in NodeFrame.
        """
        #
        # populate "Site" menu
        #
        menu = self.siteSiteOption["menu"]
        menu.delete(0, "end")
        
        menu.add_command(label=self.DEFAULT_SITE_STRING, command=lambda site=self.DEFAULT_SITE_STRING: self.selectSiteSite(site))
        
        for site in sorted(sites.keys()):
            if site != 0:
                menu.add_command(label=site, command=lambda site=site: self.selectSiteSite(site))
                if self.siteSiteVar.get() == self.DEFAULT_SITE_STRING:
                    self.siteSiteOption.config(state=NORMAL)
    

    def updateTypes(self, types):
        """ Populates drop-down menu with available sensor types.
            Called from redrawAllNodes in NodeFrame.
        """
        
        #
        # populate "All" menu
        #
        menu = self.allTypeOption["menu"]
        menu.delete(0, "end")
        
        menu.add_command(label=self.DEFAULT_TYPE_STRING, command=lambda key=self.DEFAULT_TYPE_STRING: self.selectAllType(key))
        
        for key in sorted(types.keys()):
            if key != 0:
                #menu.add_command(label=key, command=Tkinter._setit(self.allTypeVar, key))
                menu.add_command(label=key, command=lambda key=key: self.selectAllType(key))
                if self.allTypeVar.get() == self.DEFAULT_TYPE_STRING:
                    #self.allTypeVar.set(key)
                    self.allTypeOption.config(state=NORMAL)

        #
        # populate "Site" menu
        #
        menu = self.siteTypeOption["menu"]
        menu.delete(0, "end")
        
        menu.add_command(label=self.DEFAULT_TYPE_STRING, command=lambda key=self.DEFAULT_TYPE_STRING: self.selectSiteType(key))
        
        for key in sorted(types.keys()):
            if key != 0:
                menu.add_command(label=key, command=lambda key=key: self.selectSiteType(key))
                if self.siteTypeVar.get() == self.DEFAULT_TYPE_STRING:
                    self.siteTypeOption.config(state=NORMAL)


    def selectAllType(self, type):
        """ Select all nodes with the specified sensor type attached.
        """        
        self.allTypeVar.set(type)


    def selectAll(self):
        self.hub.display.updateSite("All Sites")
        self.hub.display.updateType(self.allTypeVar.get())
        self.hub.display.redrawAll()
        self.hub.node.redrawAllNodes()


    def selectSiteSite(self, site):
        """ Select all nodes within the specified site.
        """        
        self.siteSiteVar.set(site)

    def selectSiteType(self, type):
        """ Select nodes with the specified sensor type attached in specific site.
        """        
        self.siteTypeVar.set(type)

    def selectSite(self):
        self.hub.display.updateSite(self.siteSiteVar.get())
        self.hub.display.updateType(self.siteTypeVar.get())
        self.hub.display.redrawAll()        
        self.hub.node.redrawAllNodes()

    def selectDownloadTarget(self, t):
        (displayVal, networkSegment, target) = t
        print "SDT:", t
        self.downloadVar.set(displayVal)
        self.networkSegment = networkSegment
        self.downloadChannel = target
    
    def downloadRunner(self):
        #OK, this is kind of ugly: since the global/router channels
        # are fixed, and the channel which is actually used will be
        # read based on the network segment, we don't cause problems
        # by setting this value. Either it will be used (if we're
        # doing a single-patch download) or it will be ignored for
        # globalChannel or routerChannel (depending on the type of
        # download we are doing).
        configMap= {'subNetworkChannel':self.downloadChannel}
        #TODO: pull these settings from somewhere...?
        CXController.download('serial@/dev/ttyUSB0:115200',
          self.MASTER_ID,
          self.networkSegment, configMap, 
          refCallBack=self.refCallBack,
          finishedCallBack=self.downloadFinished )

    def download(self):
        print "Download: %u %u"%(self.networkSegment, self.downloadChannel)
        self.downloadButton.config(text="DOWNLOADING", bg="red",
          state=DISABLED)
        self.downloadThread = Thread(target=self.downloadRunner,
          name="downloadThread")
        self.downloadThread.daemon = True
        self.downloadThread.start()

        

    def downloadFinished(self):
        self.downloadButton.config(text="Download", bg="gray",
          state=NORMAL)
        #TODO: where does this come from?
        masterId=self.MASTER_ID
        (masterId, contacted, found) = self.db.getLastDownloadResults(masterId)
        self.hub.status.addMessage("Download finished: %u/%u identified nodes contacted\n"%(contacted, found))
        self.hub.node.loadSettings()
        self.hub.node.redrawAllNodes()
        self.csvThread = Thread(target=self.csvRunner,
          name="csvThread")
        self.csvThread.daemon = True
        self.csvThread.start()


    def csvRunner(self):
        self.hub.status.addMessage("Processing data to CSV files\n")
        DumpCSV.dumpCSV(self.dbFile, self.DEFAULT_DATA_DIR)
        self.hub.status.addMessage("CSV files ready (under %s)\n"%
          self.DEFAULT_DATA_DIR )

    def refCallBack(self, node):
        self.hub.status.addMessage("Contacted %u.\n"%(node))
    
    def commitChanges(self):
        print "Commit Changes"


    def refresh(self):
        self.hub.node.initUI()
    
    
    
