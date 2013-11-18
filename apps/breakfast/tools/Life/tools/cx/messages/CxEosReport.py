#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'CxEosReport'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 3

# The Active Message type associated with this message.
AM_TYPE = 215

class CxEosReport(tinyos.message.Message.Message):
    # Create a new CxEosReport of size 3.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=3):
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
        s = "Message <CxEosReport> \n"
        try:
            s += "  [owner=0x%x]\n" % (self.get_owner())
        except:
            pass
        try:
            s += "  [status=0x%x]\n" % (self.get_status())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: owner
    #   Field type: int
    #   Offset (bits): 0
    #   Size (bits): 16
    #

    #
    # Return whether the field 'owner' is signed (False).
    #
    def isSigned_owner(self):
        return False
    
    #
    # Return whether the field 'owner' is an array (False).
    #
    def isArray_owner(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'owner'
    #
    def offset_owner(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'owner'
    #
    def offsetBits_owner(self):
        return 0
    
    #
    # Return the value (as a int) of the field 'owner'
    #
    def get_owner(self):
        return self.getUIntElement(self.offsetBits_owner(), 16, 1)
    
    #
    # Set the value of the field 'owner'
    #
    def set_owner(self, value):
        self.setUIntElement(self.offsetBits_owner(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'owner'
    #
    def size_owner(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'owner'
    #
    def sizeBits_owner(self):
        return 16
    
    #
    # Accessor methods for field: status
    #   Field type: short
    #   Offset (bits): 16
    #   Size (bits): 8
    #

    #
    # Return whether the field 'status' is signed (False).
    #
    def isSigned_status(self):
        return False
    
    #
    # Return whether the field 'status' is an array (False).
    #
    def isArray_status(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'status'
    #
    def offset_status(self):
        return (16 / 8)
    
    #
    # Return the offset (in bits) of the field 'status'
    #
    def offsetBits_status(self):
        return 16
    
    #
    # Return the value (as a short) of the field 'status'
    #
    def get_status(self):
        return self.getUIntElement(self.offsetBits_status(), 8, 1)
    
    #
    # Set the value of the field 'status'
    #
    def set_status(self, value):
        self.setUIntElement(self.offsetBits_status(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'status'
    #
    def size_status(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'status'
    #
    def sizeBits_status(self):
        return 8
    
