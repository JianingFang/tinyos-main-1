#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'SerialPacket'
# message type.
#

import tools.tinyos.Message as Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 7

# The Active Message type associated with this message.
AM_TYPE = -1

class SerialPacket(Message.Message):
    # Create a new SerialPacket of size 7.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=7):
        Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
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
        s = "Message <SerialPacket> \n"
        try:
            s += "  [header.dest=0x%x]\n" % (self.get_header_dest())
        except:
            pass
        try:
            s += "  [header.src=0x%x]\n" % (self.get_header_src())
        except:
            pass
        try:
            s += "  [header.length=0x%x]\n" % (self.get_header_length())
        except:
            pass
        try:
            s += "  [header.group=0x%x]\n" % (self.get_header_group())
        except:
            pass
        try:
            s += "  [header.type=0x%x]\n" % (self.get_header_type())
        except:
            pass
        try:
            pass
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: header.dest
    #   Field type: int
    #   Offset (bits): 0
    #   Size (bits): 16
    #

    #
    # Return whether the field 'header.dest' is signed (False).
    #
    def isSigned_header_dest(self):
        return False
    
    #
    # Return whether the field 'header.dest' is an array (False).
    #
    def isArray_header_dest(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'header.dest'
    #
    def offset_header_dest(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'header.dest'
    #
    def offsetBits_header_dest(self):
        return 0
    
    #
    # Return the value (as a int) of the field 'header.dest'
    #
    def get_header_dest(self):
        return self.getUIntElement(self.offsetBits_header_dest(), 16, 1)
    
    #
    # Set the value of the field 'header.dest'
    #
    def set_header_dest(self, value):
        self.setUIntElement(self.offsetBits_header_dest(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'header.dest'
    #
    def size_header_dest(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'header.dest'
    #
    def sizeBits_header_dest(self):
        return 16
    
    #
    # Accessor methods for field: header.src
    #   Field type: int
    #   Offset (bits): 16
    #   Size (bits): 16
    #

    #
    # Return whether the field 'header.src' is signed (False).
    #
    def isSigned_header_src(self):
        return False
    
    #
    # Return whether the field 'header.src' is an array (False).
    #
    def isArray_header_src(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'header.src'
    #
    def offset_header_src(self):
        return (16 / 8)
    
    #
    # Return the offset (in bits) of the field 'header.src'
    #
    def offsetBits_header_src(self):
        return 16
    
    #
    # Return the value (as a int) of the field 'header.src'
    #
    def get_header_src(self):
        return self.getUIntElement(self.offsetBits_header_src(), 16, 1)
    
    #
    # Set the value of the field 'header.src'
    #
    def set_header_src(self, value):
        self.setUIntElement(self.offsetBits_header_src(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'header.src'
    #
    def size_header_src(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'header.src'
    #
    def sizeBits_header_src(self):
        return 16
    
    #
    # Accessor methods for field: header.length
    #   Field type: short
    #   Offset (bits): 32
    #   Size (bits): 8
    #

    #
    # Return whether the field 'header.length' is signed (False).
    #
    def isSigned_header_length(self):
        return False
    
    #
    # Return whether the field 'header.length' is an array (False).
    #
    def isArray_header_length(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'header.length'
    #
    def offset_header_length(self):
        return (32 / 8)
    
    #
    # Return the offset (in bits) of the field 'header.length'
    #
    def offsetBits_header_length(self):
        return 32
    
    #
    # Return the value (as a short) of the field 'header.length'
    #
    def get_header_length(self):
        return self.getUIntElement(self.offsetBits_header_length(), 8, 1)
    
    #
    # Set the value of the field 'header.length'
    #
    def set_header_length(self, value):
        self.setUIntElement(self.offsetBits_header_length(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'header.length'
    #
    def size_header_length(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'header.length'
    #
    def sizeBits_header_length(self):
        return 8
    
    #
    # Accessor methods for field: header.group
    #   Field type: short
    #   Offset (bits): 40
    #   Size (bits): 8
    #

    #
    # Return whether the field 'header.group' is signed (False).
    #
    def isSigned_header_group(self):
        return False
    
    #
    # Return whether the field 'header.group' is an array (False).
    #
    def isArray_header_group(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'header.group'
    #
    def offset_header_group(self):
        return (40 / 8)
    
    #
    # Return the offset (in bits) of the field 'header.group'
    #
    def offsetBits_header_group(self):
        return 40
    
    #
    # Return the value (as a short) of the field 'header.group'
    #
    def get_header_group(self):
        return self.getUIntElement(self.offsetBits_header_group(), 8, 1)
    
    #
    # Set the value of the field 'header.group'
    #
    def set_header_group(self, value):
        self.setUIntElement(self.offsetBits_header_group(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'header.group'
    #
    def size_header_group(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'header.group'
    #
    def sizeBits_header_group(self):
        return 8
    
    #
    # Accessor methods for field: header.type
    #   Field type: short
    #   Offset (bits): 48
    #   Size (bits): 8
    #

    #
    # Return whether the field 'header.type' is signed (False).
    #
    def isSigned_header_type(self):
        return False
    
    #
    # Return whether the field 'header.type' is an array (False).
    #
    def isArray_header_type(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'header.type'
    #
    def offset_header_type(self):
        return (48 / 8)
    
    #
    # Return the offset (in bits) of the field 'header.type'
    #
    def offsetBits_header_type(self):
        return 48
    
    #
    # Return the value (as a short) of the field 'header.type'
    #
    def get_header_type(self):
        return self.getUIntElement(self.offsetBits_header_type(), 8, 1)
    
    #
    # Set the value of the field 'header.type'
    #
    def set_header_type(self, value):
        self.setUIntElement(self.offsetBits_header_type(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'header.type'
    #
    def size_header_type(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'header.type'
    #
    def sizeBits_header_type(self):
        return 8
    
    #
    # Accessor methods for field: data
    #   Field type: short[]
    #   Offset (bits): 56
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
        offset = 56
        if index1 < 0:
            raise IndexError
        offset += 0 + index1 * 8
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'data'
    #
    def offsetBits_data(self, index1):
        offset = 56
        if index1 < 0:
            raise IndexError
        offset += 0 + index1 * 8
        return offset
    
    #
    # Return the entire array 'data' as a short[]
    #
    def get_data(self):
        raise IndexError
    
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
    # for the given dimension.
    #
    def numElements_data(self, dimension):
        array_dims = [ 0,  ]
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
    