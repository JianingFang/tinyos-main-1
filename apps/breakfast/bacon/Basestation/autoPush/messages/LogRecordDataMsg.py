#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'LogRecordDataMsg'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 102

# The Active Message type associated with this message.
AM_TYPE = 224

class LogRecordDataMsg(tinyos.message.Message.Message):
    # Create a new LogRecordDataMsg of size 102.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=102):
        tinyos.message.Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
        self.amTypeSet(AM_TYPE)
    
    # Get AM_TYPE
    def get_amType(cls):
        return AM_TYPE
    
    get_amType = classmethod(get_amType)
    
    #
    # Return a String representation of this message. Includes the
    # message type name and the non-indexed field values.
    #
    def __str__(self):
        s = "Message <LogRecordDataMsg> \n"
        try:
            s += "  [length=0x%x]\n" % (self.get_length())
        except:
            pass
        try:
            s += "  [data=";
            for i in range(0, 96):
                s += "0x%x " % (self.getElement_data(i) & 0xff)
            s += "]\n";
        except:
            pass
        try:
            s += "  [nextCookie=0x%x]\n" % (self.get_nextCookie())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: length
    #   Field type: int
    #   Offset (bits): 0
    #   Size (bits): 16
    #

    #
    # Return whether the field 'length' is signed (False).
    #
    def isSigned_length(self):
        return False
    
    #
    # Return whether the field 'length' is an array (False).
    #
    def isArray_length(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'length'
    #
    def offset_length(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'length'
    #
    def offsetBits_length(self):
        return 0
    
    #
    # Return the value (as a int) of the field 'length'
    #
    def get_length(self):
        return self.getUIntElement(self.offsetBits_length(), 16, 1)
    
    #
    # Set the value of the field 'length'
    #
    def set_length(self, value):
        self.setUIntElement(self.offsetBits_length(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'length'
    #
    def size_length(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'length'
    #
    def sizeBits_length(self):
        return 16
    
    #
    # Accessor methods for field: data
    #   Field type: short[]
    #   Offset (bits): 16
    #   Size of each element (bits): 8
    #

    #
    # Return whether the field 'data' is signed (False).
    #
    def isSigned_data(self):
        return False
    
    #
    # Return whether the field 'data' is an array (True).
    #
    def isArray_data(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'data'
    #
    def offset_data(self, index1):
        offset = 16
        if index1 < 0 or index1 >= 96:
            raise IndexError
        offset += 0 + index1 * 8
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'data'
    #
    def offsetBits_data(self, index1):
        offset = 16
        if index1 < 0 or index1 >= 96:
            raise IndexError
        offset += 0 + index1 * 8
        return offset
    
    #
    # Return the entire array 'data' as a short[]
    #
    def get_data(self):
        tmp = [None]*96
        for index0 in range (0, self.numElements_data(0)):
                tmp[index0] = self.getElement_data(index0)
        return tmp
    
    #
    # Set the contents of the array 'data' from the given short[]
    #
    def set_data(self, value):
        for index0 in range(0, len(value)):
            self.setElement_data(index0, value[index0])

    #
    # Return an element (as a short) of the array 'data'
    #
    def getElement_data(self, index1):
        return self.getUIntElement(self.offsetBits_data(index1), 8, 1)
    
    #
    # Set an element of the array 'data'
    #
    def setElement_data(self, index1, value):
        self.setUIntElement(self.offsetBits_data(index1), 8, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'data'
    #
    def totalSize_data(self):
        return (768 / 8)
    
    #
    # Return the total size, in bits, of the array 'data'
    #
    def totalSizeBits_data(self):
        return 768
    
    #
    # Return the size, in bytes, of each element of the array 'data'
    #
    def elementSize_data(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'data'
    #
    def elementSizeBits_data(self):
        return 8
    
    #
    # Return the number of dimensions in the array 'data'
    #
    def numDimensions_data(self):
        return 1
    
    #
    # Return the number of elements in the array 'data'
    #
    def numElements_data():
        return 96
    
    #
    # Return the number of elements in the array 'data'
    # for the given dimension.
    #
    def numElements_data(self, dimension):
        array_dims = [ 96,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
    #
    # Fill in the array 'data' with a String
    #
    def setString_data(self, s):
         l = len(s)
         for i in range(0, l):
             self.setElement_data(i, ord(s[i]));
         self.setElement_data(l, 0) #null terminate
    
    #
    # Read the array 'data' as a String
    #
    def getString_data(self):
        carr = "";
        for i in range(0, 4000):
            if self.getElement_data(i) == chr(0):
                break
            carr += self.getElement_data(i)
        return carr
    
    #
    # Accessor methods for field: nextCookie
    #   Field type: long
    #   Offset (bits): 784
    #   Size (bits): 32
    #

    #
    # Return whether the field 'nextCookie' is signed (False).
    #
    def isSigned_nextCookie(self):
        return False
    
    #
    # Return whether the field 'nextCookie' is an array (False).
    #
    def isArray_nextCookie(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'nextCookie'
    #
    def offset_nextCookie(self):
        return (784 / 8)
    
    #
    # Return the offset (in bits) of the field 'nextCookie'
    #
    def offsetBits_nextCookie(self):
        return 784
    
    #
    # Return the value (as a long) of the field 'nextCookie'
    #
    def get_nextCookie(self):
        return self.getUIntElement(self.offsetBits_nextCookie(), 32, 1)
    
    #
    # Set the value of the field 'nextCookie'
    #
    def set_nextCookie(self, value):
        self.setUIntElement(self.offsetBits_nextCookie(), 32, value, 1)
    
    #
    # Return the size, in bytes, of the field 'nextCookie'
    #
    def size_nextCookie(self):
        return (32 / 8)
    
    #
    # Return the size, in bits, of the field 'nextCookie'
    #
    def sizeBits_nextCookie(self):
        return 32
    