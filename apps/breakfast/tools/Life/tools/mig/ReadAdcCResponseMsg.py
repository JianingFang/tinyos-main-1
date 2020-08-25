#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'ReadAdcCResponseMsg'
# message type.
#

from tinyos.message.Message import Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 25

# The Active Message type associated with this message.
AM_TYPE = 179

class ReadAdcCResponseMsg(Message):
    # Create a new ReadAdcCResponseMsg of size 25.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=25):
        Message.__init__(self, data, addr, gid, base_offset, data_length)
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
        s = "Message <ReadAdcCResponseMsg> \n"
        try:
            s += "  [error=0x%x]\n" % (self.get_error())
        except:
            pass
        try:
            s += "  [adc=";
            for i in range(0, 24):
                s += "0x%x " % (self.getElement_adc(i) & 0xff)
            s += "]\n";
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: error
    #   Field type: short
    #   Offset (bits): 0
    #   Size (bits): 8
    #

    #
    # Return whether the field 'error' is signed (False).
    #
    def isSigned_error(self):
        return False
    
    #
    # Return whether the field 'error' is an array (False).
    #
    def isArray_error(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'error'
    #
    def offset_error(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'error'
    #
    def offsetBits_error(self):
        return 0
    
    #
    # Return the value (as a short) of the field 'error'
    #
    def get_error(self):
        return self.getUIntElement(self.offsetBits_error(), 8, 1)
    
    #
    # Set the value of the field 'error'
    #
    def set_error(self, value):
        self.setUIntElement(self.offsetBits_error(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'error'
    #
    def size_error(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'error'
    #
    def sizeBits_error(self):
        return 8
    
    #
    # Accessor methods for field: adc
    #   Field type: short[]
    #   Offset (bits): 8
    #   Size of each element (bits): 8
    #

    #
    # Return whether the field 'adc' is signed (False).
    #
    def isSigned_adc(self):
        return False
    
    #
    # Return whether the field 'adc' is an array (True).
    #
    def isArray_adc(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'adc'
    #
    def offset_adc(self, index1):
        offset = 8
        if index1 < 0 or index1 >= 24:
            raise IndexError
        offset += 0 + index1 * 8
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'adc'
    #
    def offsetBits_adc(self, index1):
        offset = 8
        if index1 < 0 or index1 >= 24:
            raise IndexError
        offset += 0 + index1 * 8
        return offset
    
    #
    # Return the entire array 'adc' as a short[]
    #
    def get_adc(self):
        tmp = [None]*24
        for index0 in range (0, self.numElements_adc(0)):
                tmp[index0] = self.getElement_adc(index0)
        return tmp
    
    #
    # Set the contents of the array 'adc' from the given short[]
    #
    def set_adc(self, value):
        for index0 in range(0, len(value)):
            self.setElement_adc(index0, value[index0])

    #
    # Return an element (as a short) of the array 'adc'
    #
    def getElement_adc(self, index1):
        return self.getUIntElement(self.offsetBits_adc(index1), 8, 1)
    
    #
    # Set an element of the array 'adc'
    #
    def setElement_adc(self, index1, value):
        self.setUIntElement(self.offsetBits_adc(index1), 8, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'adc'
    #
    def totalSize_adc(self):
        return (192 / 8)
    
    #
    # Return the total size, in bits, of the array 'adc'
    #
    def totalSizeBits_adc(self):
        return 192
    
    #
    # Return the size, in bytes, of each element of the array 'adc'
    #
    def elementSize_adc(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'adc'
    #
    def elementSizeBits_adc(self):
        return 8
    
    #
    # Return the number of dimensions in the array 'adc'
    #
    def numDimensions_adc(self):
        return 1
    
    #
    # Return the number of elements in the array 'adc'
    #
    def numElements_adc():
        return 24
    
    #
    # Return the number of elements in the array 'adc'
    # for the given dimension.
    #
    def numElements_adc(self, dimension):
        array_dims = [ 24,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
    #
    # Fill in the array 'adc' with a String
    #
    def setString_adc(self, s):
         l = len(s)
         for i in range(0, l):
             self.setElement_adc(i, ord(s[i]));
         self.setElement_adc(l, 0) #null terminate
    
    #
    # Read the array 'adc' as a String
    #
    def getString_adc(self):
        carr = "";
        for i in range(0, 4000):
            if self.getElement_adc(i) == chr(0):
                break
            carr += self.getElement_adc(i)
        return carr
    
