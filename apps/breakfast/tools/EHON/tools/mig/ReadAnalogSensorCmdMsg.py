#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'ReadAnalogSensorCmdMsg'
# message type.
#

from tinyos.message.Message import Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 14

# The Active Message type associated with this message.
AM_TYPE = 176

class ReadAnalogSensorCmdMsg(Message):
    # Create a new ReadAnalogSensorCmdMsg of size 14.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=14):
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
        s = "Message <ReadAnalogSensorCmdMsg> \n"
        try:
            s += "  [delayMS=0x%x]\n" % (self.get_delayMS())
        except:
            pass
        try:
            s += "  [samplePeriod=0x%x]\n" % (self.get_samplePeriod())
        except:
            pass
        try:
            s += "  [inch=0x%x]\n" % (self.get_inch())
        except:
            pass
        try:
            s += "  [sref=0x%x]\n" % (self.get_sref())
        except:
            pass
        try:
            s += "  [ref2_5v=0x%x]\n" % (self.get_ref2_5v())
        except:
            pass
        try:
            s += "  [adc12ssel=0x%x]\n" % (self.get_adc12ssel())
        except:
            pass
        try:
            s += "  [adc12div=0x%x]\n" % (self.get_adc12div())
        except:
            pass
        try:
            s += "  [sht=0x%x]\n" % (self.get_sht())
        except:
            pass
        try:
            s += "  [sampcon_ssel=0x%x]\n" % (self.get_sampcon_ssel())
        except:
            pass
        try:
            s += "  [sampcon_id=0x%x]\n" % (self.get_sampcon_id())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: delayMS
    #   Field type: long
    #   Offset (bits): 0
    #   Size (bits): 32
    #

    #
    # Return whether the field 'delayMS' is signed (False).
    #
    def isSigned_delayMS(self):
        return False
    
    #
    # Return whether the field 'delayMS' is an array (False).
    #
    def isArray_delayMS(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'delayMS'
    #
    def offset_delayMS(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'delayMS'
    #
    def offsetBits_delayMS(self):
        return 0
    
    #
    # Return the value (as a long) of the field 'delayMS'
    #
    def get_delayMS(self):
        return self.getUIntElement(self.offsetBits_delayMS(), 32, 1)
    
    #
    # Set the value of the field 'delayMS'
    #
    def set_delayMS(self, value):
        self.setUIntElement(self.offsetBits_delayMS(), 32, value, 1)
    
    #
    # Return the size, in bytes, of the field 'delayMS'
    #
    def size_delayMS(self):
        return (32 / 8)
    
    #
    # Return the size, in bits, of the field 'delayMS'
    #
    def sizeBits_delayMS(self):
        return 32
    
    #
    # Accessor methods for field: samplePeriod
    #   Field type: int
    #   Offset (bits): 32
    #   Size (bits): 16
    #

    #
    # Return whether the field 'samplePeriod' is signed (False).
    #
    def isSigned_samplePeriod(self):
        return False
    
    #
    # Return whether the field 'samplePeriod' is an array (False).
    #
    def isArray_samplePeriod(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'samplePeriod'
    #
    def offset_samplePeriod(self):
        return (32 / 8)
    
    #
    # Return the offset (in bits) of the field 'samplePeriod'
    #
    def offsetBits_samplePeriod(self):
        return 32
    
    #
    # Return the value (as a int) of the field 'samplePeriod'
    #
    def get_samplePeriod(self):
        return self.getUIntElement(self.offsetBits_samplePeriod(), 16, 1)
    
    #
    # Set the value of the field 'samplePeriod'
    #
    def set_samplePeriod(self, value):
        self.setUIntElement(self.offsetBits_samplePeriod(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'samplePeriod'
    #
    def size_samplePeriod(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'samplePeriod'
    #
    def sizeBits_samplePeriod(self):
        return 16
    
    #
    # Accessor methods for field: inch
    #   Field type: short
    #   Offset (bits): 48
    #   Size (bits): 8
    #

    #
    # Return whether the field 'inch' is signed (False).
    #
    def isSigned_inch(self):
        return False
    
    #
    # Return whether the field 'inch' is an array (False).
    #
    def isArray_inch(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'inch'
    #
    def offset_inch(self):
        return (48 / 8)
    
    #
    # Return the offset (in bits) of the field 'inch'
    #
    def offsetBits_inch(self):
        return 48
    
    #
    # Return the value (as a short) of the field 'inch'
    #
    def get_inch(self):
        return self.getUIntElement(self.offsetBits_inch(), 8, 1)
    
    #
    # Set the value of the field 'inch'
    #
    def set_inch(self, value):
        self.setUIntElement(self.offsetBits_inch(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'inch'
    #
    def size_inch(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'inch'
    #
    def sizeBits_inch(self):
        return 8
    
    #
    # Accessor methods for field: sref
    #   Field type: short
    #   Offset (bits): 56
    #   Size (bits): 8
    #

    #
    # Return whether the field 'sref' is signed (False).
    #
    def isSigned_sref(self):
        return False
    
    #
    # Return whether the field 'sref' is an array (False).
    #
    def isArray_sref(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'sref'
    #
    def offset_sref(self):
        return (56 / 8)
    
    #
    # Return the offset (in bits) of the field 'sref'
    #
    def offsetBits_sref(self):
        return 56
    
    #
    # Return the value (as a short) of the field 'sref'
    #
    def get_sref(self):
        return self.getUIntElement(self.offsetBits_sref(), 8, 1)
    
    #
    # Set the value of the field 'sref'
    #
    def set_sref(self, value):
        self.setUIntElement(self.offsetBits_sref(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'sref'
    #
    def size_sref(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'sref'
    #
    def sizeBits_sref(self):
        return 8
    
    #
    # Accessor methods for field: ref2_5v
    #   Field type: short
    #   Offset (bits): 64
    #   Size (bits): 8
    #

    #
    # Return whether the field 'ref2_5v' is signed (False).
    #
    def isSigned_ref2_5v(self):
        return False
    
    #
    # Return whether the field 'ref2_5v' is an array (False).
    #
    def isArray_ref2_5v(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'ref2_5v'
    #
    def offset_ref2_5v(self):
        return (64 / 8)
    
    #
    # Return the offset (in bits) of the field 'ref2_5v'
    #
    def offsetBits_ref2_5v(self):
        return 64
    
    #
    # Return the value (as a short) of the field 'ref2_5v'
    #
    def get_ref2_5v(self):
        return self.getUIntElement(self.offsetBits_ref2_5v(), 8, 1)
    
    #
    # Set the value of the field 'ref2_5v'
    #
    def set_ref2_5v(self, value):
        self.setUIntElement(self.offsetBits_ref2_5v(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'ref2_5v'
    #
    def size_ref2_5v(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'ref2_5v'
    #
    def sizeBits_ref2_5v(self):
        return 8
    
    #
    # Accessor methods for field: adc12ssel
    #   Field type: short
    #   Offset (bits): 72
    #   Size (bits): 8
    #

    #
    # Return whether the field 'adc12ssel' is signed (False).
    #
    def isSigned_adc12ssel(self):
        return False
    
    #
    # Return whether the field 'adc12ssel' is an array (False).
    #
    def isArray_adc12ssel(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'adc12ssel'
    #
    def offset_adc12ssel(self):
        return (72 / 8)
    
    #
    # Return the offset (in bits) of the field 'adc12ssel'
    #
    def offsetBits_adc12ssel(self):
        return 72
    
    #
    # Return the value (as a short) of the field 'adc12ssel'
    #
    def get_adc12ssel(self):
        return self.getUIntElement(self.offsetBits_adc12ssel(), 8, 1)
    
    #
    # Set the value of the field 'adc12ssel'
    #
    def set_adc12ssel(self, value):
        self.setUIntElement(self.offsetBits_adc12ssel(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'adc12ssel'
    #
    def size_adc12ssel(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'adc12ssel'
    #
    def sizeBits_adc12ssel(self):
        return 8
    
    #
    # Accessor methods for field: adc12div
    #   Field type: short
    #   Offset (bits): 80
    #   Size (bits): 8
    #

    #
    # Return whether the field 'adc12div' is signed (False).
    #
    def isSigned_adc12div(self):
        return False
    
    #
    # Return whether the field 'adc12div' is an array (False).
    #
    def isArray_adc12div(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'adc12div'
    #
    def offset_adc12div(self):
        return (80 / 8)
    
    #
    # Return the offset (in bits) of the field 'adc12div'
    #
    def offsetBits_adc12div(self):
        return 80
    
    #
    # Return the value (as a short) of the field 'adc12div'
    #
    def get_adc12div(self):
        return self.getUIntElement(self.offsetBits_adc12div(), 8, 1)
    
    #
    # Set the value of the field 'adc12div'
    #
    def set_adc12div(self, value):
        self.setUIntElement(self.offsetBits_adc12div(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'adc12div'
    #
    def size_adc12div(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'adc12div'
    #
    def sizeBits_adc12div(self):
        return 8
    
    #
    # Accessor methods for field: sht
    #   Field type: short
    #   Offset (bits): 88
    #   Size (bits): 8
    #

    #
    # Return whether the field 'sht' is signed (False).
    #
    def isSigned_sht(self):
        return False
    
    #
    # Return whether the field 'sht' is an array (False).
    #
    def isArray_sht(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'sht'
    #
    def offset_sht(self):
        return (88 / 8)
    
    #
    # Return the offset (in bits) of the field 'sht'
    #
    def offsetBits_sht(self):
        return 88
    
    #
    # Return the value (as a short) of the field 'sht'
    #
    def get_sht(self):
        return self.getUIntElement(self.offsetBits_sht(), 8, 1)
    
    #
    # Set the value of the field 'sht'
    #
    def set_sht(self, value):
        self.setUIntElement(self.offsetBits_sht(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'sht'
    #
    def size_sht(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'sht'
    #
    def sizeBits_sht(self):
        return 8
    
    #
    # Accessor methods for field: sampcon_ssel
    #   Field type: short
    #   Offset (bits): 96
    #   Size (bits): 8
    #

    #
    # Return whether the field 'sampcon_ssel' is signed (False).
    #
    def isSigned_sampcon_ssel(self):
        return False
    
    #
    # Return whether the field 'sampcon_ssel' is an array (False).
    #
    def isArray_sampcon_ssel(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'sampcon_ssel'
    #
    def offset_sampcon_ssel(self):
        return (96 / 8)
    
    #
    # Return the offset (in bits) of the field 'sampcon_ssel'
    #
    def offsetBits_sampcon_ssel(self):
        return 96
    
    #
    # Return the value (as a short) of the field 'sampcon_ssel'
    #
    def get_sampcon_ssel(self):
        return self.getUIntElement(self.offsetBits_sampcon_ssel(), 8, 1)
    
    #
    # Set the value of the field 'sampcon_ssel'
    #
    def set_sampcon_ssel(self, value):
        self.setUIntElement(self.offsetBits_sampcon_ssel(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'sampcon_ssel'
    #
    def size_sampcon_ssel(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'sampcon_ssel'
    #
    def sizeBits_sampcon_ssel(self):
        return 8
    
    #
    # Accessor methods for field: sampcon_id
    #   Field type: short
    #   Offset (bits): 104
    #   Size (bits): 8
    #

    #
    # Return whether the field 'sampcon_id' is signed (False).
    #
    def isSigned_sampcon_id(self):
        return False
    
    #
    # Return whether the field 'sampcon_id' is an array (False).
    #
    def isArray_sampcon_id(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'sampcon_id'
    #
    def offset_sampcon_id(self):
        return (104 / 8)
    
    #
    # Return the offset (in bits) of the field 'sampcon_id'
    #
    def offsetBits_sampcon_id(self):
        return 104
    
    #
    # Return the value (as a short) of the field 'sampcon_id'
    #
    def get_sampcon_id(self):
        return self.getUIntElement(self.offsetBits_sampcon_id(), 8, 1)
    
    #
    # Set the value of the field 'sampcon_id'
    #
    def set_sampcon_id(self, value):
        self.setUIntElement(self.offsetBits_sampcon_id(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'sampcon_id'
    #
    def size_sampcon_id(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'sampcon_id'
    #
    def sizeBits_sampcon_id(self):
        return 8
    