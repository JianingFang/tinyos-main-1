#!/usr/bin/env python

from Tkinter import *
import tkMessageBox

#from toaster.MenuFrame import MenuFrame
#from toaster.BaconFrame import BaconFrame
#from toaster.ToastFrame import ToastFrame
#from toaster.GraphFrame import GraphFrame
#from toaster.AdcFrame import AdcFrame
#from dashboard.Handler import Handler
#from dashboard.ScrolledList import ScrolledList

from tools.SimPy.SimPlot import SimPlot 
from tools.dashboard.ScrollFrame import ScrollFrame
from tools.dashboard.ControlFrame import ControlFrame
from tools.dashboard.DisplayFrame import DisplayFrame
from tools.dashboard.Hub import Hub

def selectall(event):
    event.widget.select_range(0, END)

def quit(key=None):
    root.quit()

def xscrollSet(lo, hi):
    if float(lo) <= 0.0 and float(hi) >= 1.0:
        # grid_remove is currently missing from Tkinter!
        xscrollbar.tk.call("grid", "remove", xscrollbar)
        xscrollOn = False
    else:
        xscrollbar.grid()
        xscrollOn = True
    xscrollbar.set(lo, hi)        
    
def yscrollSet(lo, hi):
    if float(lo) <= 0.0 and float(hi) >= 1.0:
        # grid_remove is currently missing from Tkinter!
        yscrollbar.tk.call("grid", "remove", yscrollbar)
        yscrollOn = False
    else:
        yscrollbar.grid()
        yscrollOn = True
    yscrollbar.set(lo, hi)        

def updateCanvas(event):        
    canvas.configure(scrollregion=canvas.bbox("all"))


#
#
#
simplot = SimPlot()
root = simplot.root

hub = Hub()    

WIDTH = 1280
HEIGHT = 630
MAIN = WIDTH * 2/3

root.geometry(str(WIDTH) + "x" + str(HEIGHT))
root.title("Dashboard")
root.bind_class("Entry","<Control-a>", selectall)
root.bind("<Alt-F4>", quit)
root.bind('<Control-c>', quit)
root.protocol("WM_DELETE_WINDOW", quit)

#
# scroll bars
#
xscrollOn = False
yscrollOn = False

xscrollbar = Scrollbar(root, orient=HORIZONTAL)
xscrollbar.grid(column=0, row=1, sticky=E+W)
yscrollbar = Scrollbar(root)
yscrollbar.grid(column=1, row=0, sticky=N+S)

canvas = Canvas(root, yscrollcommand=yscrollSet, xscrollcommand=xscrollSet)
canvas.grid(row=0, column=0, sticky=N+S+E+W)

yscrollbar.config(command=canvas.yview)
xscrollbar.config(command=canvas.xview)

# make the canvas expandable
root.grid_rowconfigure(0, weight=1)
root.grid_columnconfigure(0, weight=1)

rootFrame = Frame(canvas)
rootFrame.rowconfigure(1, weight=1)
rootFrame.columnconfigure(1, weight=1)
canvas.create_window(0, 0, anchor=NW, window=rootFrame)

rootFrame.bind("<Configure>", updateCanvas)

#
# Frames on top of canvas
#
topFrame = ControlFrame(rootFrame, hub, width=WIDTH-4, height=40, bd=1, relief=SUNKEN)
topFrame.grid_propagate(False)
topFrame.grid(column=1, row=1, columnspan=2)
hub.addControlFrame(topFrame)

scrollFrame = ScrollFrame(rootFrame, hub, width=MAIN-4, height=500, bd=1, relief=SUNKEN)
scrollFrame.grid_propagate(False)
scrollFrame.grid(column=1, row=2)
hub.addNodeFrame(scrollFrame.frame)

displayFrame = DisplayFrame(rootFrame, hub, width=WIDTH-MAIN-4, height=500, bd=1, relief=SUNKEN)
displayFrame.grid_propagate(False)
displayFrame.grid(column=2, row=2)
hub.addDisplayFrame(displayFrame)

statusFrame = Frame(rootFrame, width=WIDTH-4, height=40, bd=1, relief=SUNKEN)
statusFrame.grid_propagate(False)
statusFrame.grid(column=1, row=3, columnspan=2)
hub.addStatusFrame(statusFrame)

#
#
#
try:
    root.mainloop()
except KeyboardInterrupt:
    pass
