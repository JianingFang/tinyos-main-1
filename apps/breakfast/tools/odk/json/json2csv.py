#!/usr/bin/env python

import csv
import json
from pprint import pprint

class json2csv(object):
    
    def __init__(self):
        pass
    
    
    def readJSON(self, filename):
        # read json file    
        with open(filename) as file:
            data = json.load(file)
        
        return data

    
    def expand(self, data):
        meta = []
        
        meta.append(data['start'])
        meta.append(data['end'])
        meta.append(data['deployment_user'])
        meta.append(data['deployment_notes'])
        
        output = []
        
        # get node layer
        nodes = data['node']
        
        # for each node in layer
        for node in nodes:
            
            nodeInfo = []
            
            # append barcode
            if node['node_barcode_manual'] is not None:        
                nodeInfo.append(node['node_barcode_manual'])
            else:
                nodeInfo.append(node['node_barcode_scanner'])
            
            nodeInfo.append(node['node_gps:Latitude'])
            nodeInfo.append(node['node_gps:Longitude'])
            nodeInfo.append(node['node_gps:Altitude'])
            nodeInfo.append(node['node_gps:Accuracy'])
            nodeInfo.append(node['node_notes'])
            
            # get multiplexer layer
            multiplexers = node['multiplexer']
            
            for multiplexer in multiplexers:
                
                multiInfo = []
                
                if multiplexer['multiplexer_barcode_manual'] is not None:
                    multiInfo.append(multiplexer['multiplexer_barcode_manual'])
                else:
                    multiInfo.append(multiplexer['multiplexer_barcode_scanner'])
                    
                
                multiInfo.append(multiplexer['multiplexer_gps:Latitude'])
                multiInfo.append(multiplexer['multiplexer_gps:Longitude'])
                multiInfo.append(multiplexer['multiplexer_gps:Altitude'])
                multiInfo.append(multiplexer['multiplexer_gps:Accuracy'])
                multiInfo.append(multiplexer['multiplexer_notes'])
                
                for i in range(1,9):
                    scanner = "multiplexer_channel%d_barcode_scanner" % i
                    manual = "multiplexer_channel%d_barcode_manual" % i
                    notes = "multiplexer_channel%d_notes" % i
                    
                    if multiplexer[manual] is not None:
                        multiInfo.append(multiplexer[manual])
                    else:
                        multiInfo.append(multiplexer[scanner])
                    
                    multiInfo.append(multiplexer[notes])
                        
                    
                output.append(nodeInfo + multiInfo)
            
        return [meta, output]


    def writeCSV(self, filename, meta, data):
        
        header = []
        header.append("node_barcode, node_latitude, node_longitude, node_altitude, node_accuracy, node_notes")
        header.append("mult_barcode, mult_latitude, mult_longitude, mult_altitude, mult_accuracy, mult_notes")
        header.append("cha1_barcode, cha1_notes")
        header.append("cha2_barcode, cha2_notes")
        header.append("cha3_barcode, cha3_notes")
        header.append("cha4_barcode, cha4_notes")
        header.append("cha5_barcode, cha5_notes")
        header.append("cha6_barcode, cha6_notes")
        header.append("cha7_barcode, cha7_notes")
        header.append("cha8_barcode, cha8_notes")
        
        with open(filename, 'wb') as csvfile:
            csvfile.write("# start, end, user, notes\n")
            csvfile.write("# " + ", ".join(meta) + "\n")
            csvfile.write("# " + ", ".join(header) + "\n")
            
            writer = csv.writer(csvfile, delimiter=',')
                
            for row in data:
                writer.writerow(row)


if __name__ == '__main__':

    import sys

    if len(sys.argv) > 1:
        j2c = json2csv()
        
        for file in sys.argv[1:]:  
            
            if file.endswith('json'): 
                output = file.replace('json', 'csv')
            else:
                output = file + '.csv'
            
            # read json file into json object
            input = j2c.readJSON(file)
            
            # expand json object to fully populated 2D matrix (stored as list-of-lists)
            [meta, data] = j2c.expand(input)
            
            # write to CSV file
            j2c.writeCSV(output, meta, data)
            
    else:
        print "usage: %s <json file 1> ... <json file n>" % sys.argv[0]
        