#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'ReadIvCmdMsg'
# message type.
#

from apps.breakfast.tools.Life.tools import Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 0

# The Active Message type associated with this message.
AM_TYPE = 128

class ReadIvCmdMsg(Message):
    # Create a new ReadIvCmdMsg of size 0.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=0):
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
        s = "Message <ReadIvCmdMsg> \n"
        try:
            pass
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: dummy
    #   Field type: short[]
    #   Offset (bits): 0
    #   Size of each element (bits): 8
    #

    #
    # Return whether the field 'dummy' is signed (False).
    #
    def isSigned_dummy(self):
        return False
    
    #
    # Return whether the field 'dummy' is an array (True).
    #
    def isArray_dummy(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'dummy'
    #
    def offset_dummy(self, index1):
        offset = 0
        if index1 < 0:
            raise IndexError
        offset += 0 + index1 * 8
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'dummy'
    #
    def offsetBits_dummy(self, index1):
        offset = 0
        if index1 < 0:
            raise IndexError
        offset += 0 + index1 * 8
        return offset
    
    #
    # Return the entire array 'dummy' as a short[]
    #
    def get_dummy(self):
        raise IndexError
    
    #
    # Set the contents of the array 'dummy' from the given short[]
    #
    def set_dummy(self, value):
        for index0 in range(0, len(value)):
            self.setElement_dummy(index0, value[index0])

    #
    # Return an element (as a short) of the array 'dummy'
    #
    def getElement_dummy(self, index1):
        return self.getUIntElement(self.offsetBits_dummy(index1), 8, 1)
    
    #
    # Set an element of the array 'dummy'
    #
    def setElement_dummy(self, index1, value):
        self.setUIntElement(self.offsetBits_dummy(index1), 8, value, 1)
    
    #
    # Return the size, in bytes, of each element of the array 'dummy'
    #
    def elementSize_dummy(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'dummy'
    #
    def elementSizeBits_dummy(self):
        return 8
    
    #
    # Return the number of dimensions in the array 'dummy'
    #
    def numDimensions_dummy(self):
        return 1
    
    #
    # Return the number of elements in the array 'dummy'
    # for the given dimension.
    #
    def numElements_dummy(self, dimension):
        array_dims = [ 0,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
    #
    # Fill in the array 'dummy' with a String
    #
    def setString_dummy(self, s):
         l = len(s)
         for i in range(0, l):
             self.setElement_dummy(i, ord(s[i]));
         self.setElement_dummy(l, 0) #null terminate
    
    #
    # Read the array 'dummy' as a String
    #
    def getString_dummy(self):
        carr = "";
        for i in range(0, 4000):
            if self.getElement_dummy(i) == chr(0):
                break
            carr += self.getElement_dummy(i)
        return carr
    
