#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'PrintfMsg'
# message type.
#

from tinyos.message.Message import Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 28

# The Active Message type associated with this message.
AM_TYPE = 100

class PrintfMsg(Message):
    # Create a new PrintfMsg of size 28.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=28):
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
        s = "Message <PrintfMsg> \n"
        try:
            s += "  [buffer=";
            for i in range(0, 28):
                s += "0x%x " % (self.getElement_buffer(i) & 0xff)
            s += "]\n";
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: buffer
    #   Field type: short[]
    #   Offset (bits): 0
    #   Size of each element (bits): 8
    #

    #
    # Return whether the field 'buffer' is signed (False).
    #
    def isSigned_buffer(self):
        return False
    
    #
    # Return whether the field 'buffer' is an array (True).
    #
    def isArray_buffer(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'buffer'
    #
    def offset_buffer(self, index1):
        offset = 0
        if index1 < 0 or index1 >= 28:
            raise IndexError
        offset += 0 + index1 * 8
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'buffer'
    #
    def offsetBits_buffer(self, index1):
        offset = 0
        if index1 < 0 or index1 >= 28:
            raise IndexError
        offset += 0 + index1 * 8
        return offset
    
    #
    # Return the entire array 'buffer' as a short[]
    #
    def get_buffer(self):
        tmp = [None]*28
        for index0 in range (0, self.numElements_buffer(0)):
                tmp[index0] = self.getElement_buffer(index0)
        return tmp
    
    #
    # Set the contents of the array 'buffer' from the given short[]
    #
    def set_buffer(self, value):
        for index0 in range(0, len(value)):
            self.setElement_buffer(index0, value[index0])

    #
    # Return an element (as a short) of the array 'buffer'
    #
    def getElement_buffer(self, index1):
        return self.getUIntElement(self.offsetBits_buffer(index1), 8, 1)
    
    #
    # Set an element of the array 'buffer'
    #
    def setElement_buffer(self, index1, value):
        self.setUIntElement(self.offsetBits_buffer(index1), 8, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'buffer'
    #
    def totalSize_buffer(self):
        return (224 / 8)
    
    #
    # Return the total size, in bits, of the array 'buffer'
    #
    def totalSizeBits_buffer(self):
        return 224
    
    #
    # Return the size, in bytes, of each element of the array 'buffer'
    #
    def elementSize_buffer(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'buffer'
    #
    def elementSizeBits_buffer(self):
        return 8
    
    #
    # Return the number of dimensions in the array 'buffer'
    #
    def numDimensions_buffer(self):
        return 1
    
    #
    # Return the number of elements in the array 'buffer'
    #
    def numElements_buffer():
        return 28
    
    #
    # Return the number of elements in the array 'buffer'
    # for the given dimension.
    #
    def numElements_buffer(self, dimension):
        array_dims = [ 28,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
    #
    # Fill in the array 'buffer' with a String
    #
    def setString_buffer(self, s):
         l = len(s)
         for i in range(0, l):
             self.setElement_buffer(i, ord(s[i]));
         self.setElement_buffer(l, 0) #null terminate
    
    #
    # Read the array 'buffer' as a String
    #
    def getString_buffer(self):
        carr = "";
        for i in range(0, 4000):
            if self.getElement_buffer(i) == chr(0):
                break
            carr += self.getElement_buffer(i)
        return carr
    
