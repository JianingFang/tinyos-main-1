/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author Jonathan Hui <jhui@archrock.com>
 * @version $Revision: 1.9 $ $Date: 2009-12-23 02:28:47 $
 */

#include <Stm25p.h>

module Stm25pLogP {
  
  provides interface Init;
  provides interface LogRead as Read[ uint8_t id ];
  provides interface LogWrite as Write[ uint8_t id ];
  
  uses interface Stm25pSector as Sector[ uint8_t id ];
  uses interface Resource as ClientResource[ uint8_t id ];
  uses interface Get<bool> as Circular[ uint8_t id ];
  provides interface Stm25pVolume as Volume[uint8_t id];
  uses interface Leds;

  //for informing other code when an append is completed (indicates
  //  how much data was appended)
  provides interface Notify<uint8_t>[uint8_t id];
}

implementation {

  stm25p_addr_t write_addrs[NUM_VOLUMES];

  #ifndef SINGLE_RECORD_READ
  #define SINGLE_RECORD_READ 0
  #endif

  #if SINGLE_RECORD_READ == 1
  #warning "Using single-record log read"
  #endif

  enum {
    NUM_LOGS = uniqueCount( "Stm25p.Log" ),
    BLOCK_SIZE = 4096,
    BLOCK_SIZE_LOG2 = 12,
    BLOCK_MASK = BLOCK_SIZE - 1,
    BLOCKS_PER_SECTOR = STM25P_SECTOR_SIZE / BLOCK_SIZE,
    MAX_RECORD_SIZE = 254,
    INVALID_HEADER = 0xff,
  };
  
  typedef enum {
    S_IDLE,
    S_READ,
    S_SEEK,
    S_ERASE,
    S_APPEND,
    S_SYNC,
  } stm25p_log_req_t;

  typedef struct stm25p_log_state_t {
    storage_cookie_t cookie;
    void* buf;
    uint8_t len;
    uint8_t m_len;
    bool m_records_lost;
    stm25p_log_req_t req;
  } stm25p_log_state_t;

  typedef struct stm25p_log_info_t {
    stm25p_addr_t read_addr;
    stm25p_addr_t remaining;
  } stm25p_log_info_t;
  
  stm25p_log_state_t m_log_state[ NUM_LOGS ];
  stm25p_log_state_t m_req;
  stm25p_log_info_t m_log_info[ NUM_LOGS ];
  stm25p_addr_t m_addr;
  uint8_t m_header;
  stm25p_addr_t m_blockAddr;
  stm25p_addr_t m_stashedReadAddr;
  stm25p_addr_t m_nextReadAddr;

  typedef enum {
    S_SEARCH_BLOCKS = 0,
    S_SEARCH_RECORDS = 1,
    S_SEARCH_SEEK = 2,
    S_HEADER = 3,
    S_DATA = 4,
    S_CHECK_BLOCK_WI = 5,
    S_SEARCH_SEEK_BLOCK = 6,
    S_BLOCK_HEADER = 7,
    S_BLOCK_HEADER_RECOVER = 8,
  } stm25p_log_rw_state_t;

  stm25p_log_rw_state_t m_rw_state;

  error_t newRequest( uint8_t client );
  void continueReadOp( uint8_t client );
  void continueAppendOp( uint8_t client );
  void signalDone( uint8_t id, error_t error );
  
  command error_t Init.init() {
    int i;
    for ( i = 0; i < NUM_LOGS; i++ ) {
      stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[i]()];
      m_log_info[ i ].read_addr = STM25P_INVALID_ADDRESS;
      *write_addr = 0;
    }
    return SUCCESS;
  }
  
  command error_t Read.read[ uint8_t id ]( void* buf, storage_len_t len ) {
    m_req.req = S_READ;
    m_req.buf = buf;
    m_req.len = len;
    m_req.m_len = len;
    
    return newRequest( id );
  }

  command error_t Read.seek[ uint8_t id ]( storage_addr_t cookie ) {
    stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[id]()];
    if ( cookie > *write_addr){
      return FAIL;
    }
    
    m_req.req = S_SEEK;
    m_req.cookie = cookie;
    return newRequest( id );
    
  }
  
  command storage_cookie_t Read.currentOffset[ uint8_t id ]() {
    return m_log_info[ id ].read_addr;
  }
  
  command storage_cookie_t Read.getSize[ uint8_t id ]() {
    return ( (storage_len_t)call Sector.getNumSectors[ id ]()
      << STM25P_SECTOR_SIZE_LOG2 );
  }
  
  command storage_cookie_t Write.currentOffset[ uint8_t id ]() {
    stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[id]()];
    return *write_addr;
  }
  
  command error_t Write.erase[ uint8_t id ]() {
    m_req.req = S_ERASE;
    return newRequest( id );
  }
  
  command error_t Write.append[ uint8_t id ]( void* buf, storage_len_t len ) {
    stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[id]()];
    uint16_t bytes_written = (uint16_t)(*write_addr) % BLOCK_SIZE;
    uint16_t bytes_left = BLOCK_SIZE - bytes_written;
    
    // don't allow appends larger than maximum record size
    if ( len > MAX_RECORD_SIZE ){
      return EINVAL;
    }
    
    // move to next block if current block doesn't have enough space
    if ( sizeof( m_header ) + len > bytes_left ){
      *write_addr += bytes_left;
    }
    
    // if log is not circular, make sure it doesn't grow too large
    if ( !call Circular.get[ id ]() &&
       ( (uint8_t)(*write_addr >> STM25P_SECTOR_SIZE_LOG2) >=
         call Sector.getNumSectors[ id ]() ) ){
      return ESIZE;
    }
    
    m_req.m_records_lost = FALSE;
    m_req.req = S_APPEND;
    m_req.buf = buf;
    m_req.len = len;

    return newRequest( id );

  }
  
  command error_t Write.sync[ uint8_t id ]() {
    m_req.req = S_SYNC;
    return newRequest( id );
  }
  
  error_t newRequest( uint8_t client ) {
    
    if ( m_log_state[ client ].req != S_IDLE ){
      return FAIL;
    }
    
    call ClientResource.request[ client ]();
    m_log_state[ client ] = m_req;
    
    return SUCCESS;
    
  }
  
  uint8_t calcSector( uint8_t client, stm25p_addr_t addr ) {
    uint8_t sector = call Sector.getNumSectors[ client ]();
    return (uint8_t)(( addr >> STM25P_SECTOR_SIZE_LOG2 ) % sector);
  }

  stm25p_addr_t calcAddr( uint8_t client, stm25p_addr_t addr  ) {
    stm25p_addr_t result = calcSector( client, addr );
    result <<= STM25P_SECTOR_SIZE_LOG2;
    result |= addr & STM25P_SECTOR_MASK;
    return result;
  }

  event void ClientResource.granted[ uint8_t id ]() {

    // log never used, need to find start and end of log
    if ( m_log_info[ id ].read_addr == STM25P_INVALID_ADDRESS &&
       m_log_state[ id ].req != S_ERASE ) {
      stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[id]()];
      //this could be improved slightly: a newly-initialized log
      //  client should always have to find start of log for read, but
      //  may not have to find end of log (if another client on the
      //  same volume has already done that search).
      //The search logic assumes that write_addr starts at 0, so we
      //  enforce that here. This will result in some duplicated
      //  effort, though it makes the logic simpler and reduces the
      //  amount of state that has to be tracked.
      *write_addr = 0;
      m_rw_state = S_SEARCH_BLOCKS;
      call Sector.read[ id ]( 0, (uint8_t*)&m_addr, sizeof( m_addr ) );
    } else {
    // start and end of log known, do the requested operation
      switch( m_log_state[ id ].req ) {
        case S_READ:
          //remaining=0: state is read_header. !=0 : read data
          m_rw_state = (m_log_info[ id ].remaining) ? S_DATA : S_HEADER;
          continueReadOp( id );
          break;

        case S_SEEK:
        {
          // make sure the cookie is still within the range of valid data
          stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[id]()];
          uint8_t numSectors = call Sector.getNumSectors[ id ]();
          uint8_t readSector = 
            (m_log_state[ id ].cookie >> STM25P_SECTOR_SIZE_LOG2);
          uint8_t writeSector =
            ((*write_addr-1)>>STM25P_SECTOR_SIZE_LOG2)+1;
          // if cookie is overwritten, advance to beginning of log
          if ( (writeSector - readSector) > numSectors ) {
            m_log_state[ id ].cookie = 
              (storage_cookie_t)(writeSector-numSectors)
              <<STM25P_SECTOR_SIZE_LOG2;
          }
          m_stashedReadAddr = m_log_info[ id ].read_addr;
          m_log_info[ id ].read_addr = m_log_state[ id ].cookie & ~BLOCK_MASK;
          m_log_info[ id ].remaining = 0;
          m_rw_state = S_SEARCH_SEEK;
          if (SINGLE_RECORD_READ){
            //validate block address before we go any further
            m_rw_state = S_SEARCH_SEEK_BLOCK;
            call Sector.read[id](calcAddr(id, m_log_info[id].read_addr), 
              (uint8_t*)&m_blockAddr, sizeof(m_blockAddr));
          } else{
            if ( m_log_info[ id ].read_addr != m_log_state[ id ].cookie ) {
              m_log_info[ id ].read_addr += sizeof( m_addr );
              call Sector.read[ id ]( 
                calcAddr( id, m_log_info[ id ].read_addr ), 
                &m_header, sizeof( m_header ) );
            }else{
              signalDone( id, SUCCESS );
            }
          }
        }
        break;
      case S_ERASE:
        call Sector.erase[ id ]( 0, call Sector.getNumSectors[ id ]() );
        break;
      case S_APPEND:
        m_rw_state = S_HEADER;
        continueAppendOp( id );
        break;
      case S_SYNC:
        signalDone( id, SUCCESS );
        break;
      case S_IDLE:
        break;
      }
    }
  }

  void continueReadOp( uint8_t client ) {
    
    stm25p_addr_t read_addr = m_log_info[ client ].read_addr;
    stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[client]()];
    uint8_t* buf;
    uint8_t len;
    error_t error;

    uint8_t m_len = m_log_state[ client ].m_len;
    //TODO: is this causing wrap behavior? incrementing read_addr
    //  before checking for completion?
    //  What is *write_addr when the log is wrapped? It must be that
    //  write_addr is ending up at some wonky value.

    // if on block boundary
    //at block boundary: advance read_addr to first record start

    //TODO: at block boundary: read block header and verify that it
    //  matches what we expect.
    if ( !((uint16_t)read_addr & BLOCK_MASK ) ){
      m_rw_state = S_BLOCK_HEADER;
//      read_addr += sizeof( m_addr );
    }

    // check if all done
    if ( m_len == 0 || read_addr >= *write_addr ) {
      signalDone( client, SUCCESS );
      return;
    }

    if ( m_rw_state == S_DATA ) {
      // if header is invalid, move to next block
      if ( m_header == INVALID_HEADER ) {
        m_rw_state = S_HEADER;
        read_addr += BLOCK_SIZE;
        read_addr &= ~BLOCK_MASK;
        buf = &m_header;
        len = sizeof( m_header );
      } else {
        if (SINGLE_RECORD_READ){
          if (m_log_info[client].remaining > m_log_state[client].len){
            //Not enough space for record, we're done.
            //Note that we explicitly check for this in
            //Sector.readDone and shouldn't reach this point. If we
            //have reached this point, read_addr is not pointing at a
            //record header. While this should still work OK, calling
            //currentOffset right now would give a result that is 1+
            //the correct/unambiguous cookie value. Since we require
            //that cookie 
            signalDone(client, FAIL);
            return;
          } else{
            //it fits, I sits.
            // m_len is the remaining data to read,
            // m_log_info[client].len is the filled part of the buffer
            len = m_log_info[client].remaining;
            //read into client buffer
            buf = m_log_state[client].buf;
          }
        }else{
          //read into &(buffer + requested len - read-so-far)
          buf = m_log_state[ client ].buf + m_log_state[ client ].len - m_len;
          // truncate if record is shorter than requested length
          if ( m_log_info[ client ].remaining < m_len ){
            len = m_log_info[ client ].remaining;
          }else{
            len = m_len;
          }
        }
      }
    }else if (m_rw_state == S_HEADER){
      //S_HEADER behavior if not S_DATA.
      buf = &m_header;
      len = sizeof( m_header );
    }else if (m_rw_state == S_BLOCK_HEADER){
      buf = (uint8_t*)&m_blockAddr;
      len = sizeof(m_blockAddr);
    }else{
      printf("'comment2':'ERR: cro %x',\r\n", m_rw_state);
      signalDone(client, FAIL);
      return;
    }
    
    m_log_info[ client ].read_addr = read_addr;
    error = call Sector.read[ client ]( calcAddr( client, read_addr ), buf, len );
  }
  
  void checkBlockForWriteInit(uint8_t id, stm25p_addr_t addr){
    m_rw_state = S_CHECK_BLOCK_WI;
    call Sector.read[id]( calcAddr(id, addr), (uint8_t*)&m_addr,
      sizeof(m_addr));
  }

  //This verifies that a logical address is consistent with its
  //  physical address. 
  //e.g. if we read an addr = 0 anywhere but the 0th block, it's
  //  invalid. 
  //  If we get 2147483648 at phy addr 274432, it's invalid.
  bool validateAddress(uint8_t client, stm25p_addr_t phyAddr, 
      stm25p_addr_t logicalAddr){
    return (logicalAddr == STM25P_INVALID_ADDRESS || calcAddr(client, logicalAddr) == phyAddr);
  }
  
  event void Sector.readDone[ uint8_t id ]( stm25p_addr_t addr, uint8_t* buf,
                                  stm25p_len_t len, error_t error ) {
 
    stm25p_log_info_t* log_info = &m_log_info[ id ];
    stm25p_addr_t *write_addr = &write_addrs[signal Volume.getVolumeId[id]()];

    uint8_t m_len = m_log_state[ id ].m_len;


    // searching for the first and last log blocks
    switch( m_rw_state ) {
      case S_SEARCH_BLOCKS: 
        {
          uint16_t block = addr >> BLOCK_SIZE_LOG2;
          printf("'comment3':'SB p %lu l %lu',\r\n", addr, m_addr);
          //TODO: verify checksum of addr for added safety
          // (increment addr by block size and skip it if bad) 

          // record potential starting and ending addresses
          if ( m_addr != STM25P_INVALID_ADDRESS 
              && validateAddress(id, addr, m_addr)) {
            if ( m_addr < log_info->read_addr ){
              log_info->read_addr = m_addr;
            }
            if ( m_addr > *write_addr ){
              *write_addr = m_addr;
              printf("'comment4':'wa= %lu',\r\n", m_addr);
            }
          }
          // move on to next log block (check header of block)
          if (++block < (call Sector.getNumSectors[ id ]()*BLOCKS_PER_SECTOR)) {
            addr += BLOCK_SIZE;
            call Sector.read[ id ]( addr, 
              (uint8_t*)&m_addr, 
              sizeof( m_addr ) );
          } else if ( log_info->read_addr == STM25P_INVALID_ADDRESS ) {
            // if log is empty, continue operation
            log_info->read_addr = 0;
            *write_addr = 0;
            signal ClientResource.granted[ id ]();
          } else {
          // search for last record
            *write_addr += sizeof( m_addr );
            m_rw_state = S_SEARCH_RECORDS;
            call Sector.read[ id ]( 
              calcAddr(id, *write_addr), 
              &m_header, 
              sizeof( m_header ) );
          }
        }
        break;
  
      case S_SEARCH_RECORDS: 
        {
          // searching for the last log record to write
          uint16_t cur_block = *write_addr >> BLOCK_SIZE_LOG2;
          uint16_t new_block = ( *write_addr + sizeof( m_header ) + m_header ) >> BLOCK_SIZE_LOG2;
          // if header is valid and is on same block, move to next record
          if (cur_block != new_block && (m_header != INVALID_HEADER)){
//          if (cur_block != new_block){
            //this should not happen, and probably indicates some
            //corruption of an earlier record (incorrect len field
            //most likely) that broke record alignment. 
            // If it does, then we just skip ahead to the next block.
            *write_addr += BLOCK_SIZE;
            *write_addr &= ~BLOCK_MASK;
            checkBlockForWriteInit(id, *write_addr);

          }else if ( m_header != INVALID_HEADER ) {
            *write_addr += sizeof( m_header ) + m_header;
            call Sector.read[ id ]( 
              calcAddr( id, *write_addr ), 
              &m_header, 
              sizeof( m_header ) );
          } else {
          // found last record
            signal ClientResource.granted[ id ]();
          }
        }
        break;

      case S_SEARCH_SEEK_BLOCK:
        //Verify that not only is address valid (at expected physical
        //position) but that it also matches the expected logical
        //address
        if (validateAddress(id, addr, m_blockAddr) 
            && (m_blockAddr == log_info->read_addr)){
          //Cool. let's keep going.
          m_rw_state = S_SEARCH_SEEK;
          //advance to first record header on this block
          log_info->read_addr += sizeof(m_addr);
          //if we aren't there yet, then we need to read the first
          //record header and proceed from there.
          if ( log_info->read_addr < m_log_state[ id ].cookie ) {
            call Sector.read[ id ]( 
              calcAddr( id, log_info->read_addr ), 
              &m_header, sizeof( m_header ) );
          }else{
            signalDone( id, SUCCESS );
          }
        } else {
          printf("'comment11':'BAD SEEK got %lu at p %lu looking for %lu',\r\n",
            m_blockAddr, addr, log_info->read_addr);
          //indicate that seek broke down. This happens if we try to
          //seek to an address that is on a bad block. If this occurs,
          //restore the last read_addr (which was presumably not
          //invalid)
          log_info->read_addr = m_stashedReadAddr;
          signalDone(id, FAIL);
        }
        break;

      case S_SEARCH_SEEK:
        {
          stm25p_addr_t s_block = log_info->read_addr >> BLOCK_SIZE_LOG2;
          stm25p_addr_t e_block = (log_info->read_addr+m_header) >> BLOCK_SIZE_LOG2;
          // searching for last log record to read
          //stash log_info->read_addr before advancing
          storage_addr_t last_read_addr = log_info->read_addr;

          //advances read_addr to next record start 
          // (+=header len + header val)
          log_info->read_addr += sizeof( m_header ) + m_header;
          //record spans a block: step to start of next.
          if (e_block != s_block){
            log_info->read_addr += BLOCK_SIZE;
            log_info->read_addr &= ~BLOCK_MASK;
          }

          // if not yet at cookie, keep searching
          if ( log_info->read_addr < m_log_state[ id ].cookie ) {
            call Sector.read[ id ]( 
              calcAddr(id, log_info->read_addr), 
              &m_header, 
              sizeof( m_header ) );
          } else {
            // at or passed cookie, stop        
            if (SINGLE_RECORD_READ){
              if (e_block != s_block){
                //We passed it, but only because of a block-spanning
                //record. ok to stop here, we'll correct for the block
                //header below.
              } else if ( log_info->read_addr > m_log_state[ id ].cookie ) {
                //backtrack to start of record. remaining=0 means "this
                //pointing at a header"
                log_info->remaining = 0;
                log_info->read_addr = last_read_addr;
              }

              //if we are now pointing at a block header, advance
              //it to the next record header to disambiguate
              //TODO: should validate this block header before
              // completing
              if ( (log_info->read_addr & BLOCK_MASK) < sizeof(m_addr)){
                log_info->read_addr =
                  (log_info->read_addr & ~BLOCK_MASK) + sizeof(m_addr);
              }else{
                //already pointing at a record header
              }
            } else{
              log_info->remaining = log_info->read_addr - m_log_state[ id ].cookie;
              log_info->read_addr = m_log_state[ id ].cookie;
            }
            signalDone( id, error );
          }
        }
        break;

      case S_BLOCK_HEADER:
        //check that this is a valid block header and that it matches
        //the expected logical address
        if (validateAddress(id, addr, m_blockAddr) 
            && (m_blockAddr == log_info->read_addr)){
          printf("'comment6':'BH %lu OK @ p %lu r %lu',\r\n", 
            m_blockAddr, addr, log_info->read_addr);
          log_info->read_addr += sizeof(m_blockAddr);
          m_rw_state = S_HEADER;
          continueReadOp(id);
        }else{
          //hit a bad block header. Our goal is to see if there is
          //some good block header having higher value than the
          //current read address
          m_rw_state = S_BLOCK_HEADER_RECOVER;
          m_nextReadAddr = STM25P_INVALID_ADDRESS;
          printf("'comment5':'BH %lu BAD @ p %lu r %lu',\r\n", 
            m_blockAddr, addr, log_info->read_addr);
          call Sector.read[id](0, (uint8_t*)&m_blockAddr, sizeof(m_blockAddr));
        }
        break;

      case S_BLOCK_HEADER_RECOVER:
        {
          uint16_t block = addr >> BLOCK_SIZE_LOG2;
          if (m_blockAddr != STM25P_INVALID_ADDRESS 
              && validateAddress(id, addr, m_blockAddr) 
              && m_blockAddr > log_info->read_addr 
              && m_blockAddr < m_nextReadAddr){
            printf("'comment7':'BHR nra %lu -> %lu @ %lu'\r\n",
              m_nextReadAddr, m_blockAddr, addr);
            m_nextReadAddr = m_blockAddr;
          }
          if (++block < (call Sector.getNumSectors[ id ]()*BLOCKS_PER_SECTOR)) {
            addr += BLOCK_SIZE; 
            call Sector.read[ id ]( addr, 
              (uint8_t*)&m_blockAddr,
              sizeof(m_blockAddr));
          }else{
            printf("'comment8':'BHR end nra %lu wa %lu',\r\n",
              m_nextReadAddr, *write_addr);
            if (m_nextReadAddr > *write_addr){
              m_nextReadAddr = *write_addr;
              m_rw_state = S_HEADER;
              printf("'comment9':'resume header',\r\n");
            }else{
              log_info->read_addr = m_nextReadAddr;
              m_rw_state = S_BLOCK_HEADER;
              printf("'comment10':'resume block header',\r\n");
            }
            continueReadOp(id);
          }
        }
        break;

      case S_HEADER:
        {
          stm25p_addr_t s_block = log_info->read_addr >> BLOCK_SIZE_LOG2;
          stm25p_addr_t e_block = (log_info->read_addr+m_header) >> BLOCK_SIZE_LOG2;

          // if header is invalid, or record is block-spanning, move
          // to next block and continue searching
          if ( m_header == INVALID_HEADER || m_header == 0 || (s_block != e_block)) {
            log_info->read_addr += BLOCK_SIZE;
            log_info->read_addr &= ~BLOCK_MASK;
          } else {
            //remaining = remaining in this record
            log_info->read_addr += sizeof( m_header );
            log_info->remaining = m_header;
            m_rw_state = S_DATA;
            if (SINGLE_RECORD_READ){
              //check for fit
              if (log_info->remaining > m_log_state[id].len){
                //doesn't fit: go back to header, signal done
                log_info->read_addr -= sizeof(m_header);
                log_info->remaining = 0;
                signalDone(id, ESIZE);
                return;
              }
            }
          }
          continueReadOp( id );
        }
        break;

      case S_DATA:
        {
          log_info->read_addr += len;
          log_info->remaining -= len;
          //m_len is the number of bytes requested but not yet read
          m_len -= len;

          m_log_state[ id ].m_len = m_len;
          
          if (SINGLE_RECORD_READ){
            //single-record read: stop here.
            signalDone(id, error);
          }else{
            m_rw_state = S_HEADER;
            continueReadOp( id );
          }
          break;
        }
      case S_CHECK_BLOCK_WI:
        {
          if (m_addr == STM25P_INVALID_ADDRESS){
            //OK, this is a fine place to set the initial write-addr.
            signal ClientResource.granted[ id ]();
          }else{
            //check the next block.
            *write_addr += BLOCK_SIZE;
            *write_addr &= ~BLOCK_MASK;
            checkBlockForWriteInit(id, *write_addr);
          }
          break;
        }
    }
  }

  void continueAppendOp( uint8_t client ) {
    
    stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[client]()];
    void* buf;
    uint8_t len;
    //so if this is interrupted between the record-header being
    //written and the data being written, the data will be lost but
    //the log structure will remain intact.

    
    if ( !(uint16_t)*write_addr ) {
      // This is a hack. It assumes sectors are 0x10000 large      
      // and erases AHEAD on 0xFFFF-0x10000 boundaries
      m_log_state[ client ].m_records_lost = TRUE;
      call Sector.erase[ client ]( calcSector( client, *write_addr ), 1 );
    } else {
      //start of new block? write write_addr into block header
      if ( !((uint16_t)*write_addr & BLOCK_MASK) ) {
        //TODO: add checksum here.
        buf = write_addr;
        len = sizeof( m_addr );
      } else if ( m_rw_state == S_HEADER ) {
        //need to write header (len)? do so.
        buf = &m_log_state[ client ].len;
        len = sizeof( m_log_state[ client ].len );
      } else {
        //write actual data
        buf = m_log_state[ client ].buf;
        len = m_log_state[ client ].len;
      }
      call Sector.write[ client ]( calcAddr( client, *write_addr ), buf, len );
    }
  }

  event void Sector.eraseDone[ uint8_t id ]( uint8_t sector, 
                                   uint8_t num_sectors,
                                   error_t error ) {
    stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[id]()];
    if ( m_log_state[ id ].req == S_ERASE ) {
      m_log_info[ id ].read_addr = 0;
      *write_addr = 0;
      signalDone( id, error );
    } else {
      // advance read pointer if write pointer has gone too far ahead
      // (the log could have cycled around)
      stm25p_addr_t volume_size = 
      STM25P_SECTOR_SIZE * ( call Sector.getNumSectors[ id ]() - 1 );
      if ( *write_addr > volume_size ) {
      stm25p_addr_t read_addr = *write_addr - volume_size;
      if ( m_log_info[ id ].read_addr < read_addr )
        m_log_info[ id ].read_addr = read_addr;
      }
      m_addr = *write_addr;
      call Sector.write[ id ]( calcAddr( id, m_addr ), (uint8_t*)&m_addr, 
                        sizeof( m_addr ) );
    }
  }

  event void Sector.writeDone[ uint8_t id ]( storage_addr_t addr, 
                                   uint8_t* buf, 
                                   storage_len_t len, 
                                   error_t error ) {
    //unclear how this ensures writes don't span block boundaries.
    //maybe that's done by Sector?
    stm25p_addr_t* write_addr = &write_addrs[signal Volume.getVolumeId[id]()];
    *write_addr += len;
    if ( m_rw_state == S_HEADER ) {
      if ( len == sizeof( m_header ) ){
        m_rw_state = S_DATA;
      }
      continueAppendOp( id );
    } else {
      signalDone( id, error );
    }
  }
  
  void signalDone( uint8_t id, error_t error ) {
    
    stm25p_log_req_t req = m_log_state[ id ].req;
    void* buf = m_log_state[ id ].buf;
    storage_len_t len = m_log_state[ id ].len;

    uint8_t m_len = m_log_state[ id ].m_len;
    bool m_records_lost = m_log_state[ id ].m_records_lost;

    call ClientResource.release[ id ]();
    m_log_state[ id ].req = S_IDLE;
    switch( req ) {
      case S_IDLE:
        break;
      case S_READ:
        signal Read.readDone[ id ]( buf, len - m_len, error );
        break;
      case S_SEEK:
        signal Read.seekDone[ id ]( error );
        break;
      case S_ERASE:
        signal Write.eraseDone[ id ]( error );
        break;
      case S_APPEND:
        signal Notify.notify[id](len);
        signal Write.appendDone[ id ]( buf, len, m_records_lost, error );
        break;
      case S_SYNC:
        signal Write.syncDone[ id ]( error );
        break;
    }
  }

  event void Sector.computeCrcDone[ uint8_t id ]( stm25p_addr_t addr, stm25p_len_t len, uint16_t crc, error_t error ) {}
  
  default event void Read.readDone[ uint8_t id ]( void* data, storage_len_t len, error_t error ) {}
  default event void Read.seekDone[ uint8_t id ]( error_t error ) {}
  default event void Write.eraseDone[ uint8_t id ]( error_t error ) {}
  default event void Write.appendDone[ uint8_t id ]( void* data, storage_len_t len, bool recordsLost, error_t error ) {}
  default event void Write.syncDone[ uint8_t id ]( error_t error ) {}

  default command storage_addr_t Sector.getPhysicalAddress[ uint8_t id ]( storage_addr_t addr ) { return 0xffffffff; }
  default command uint8_t Sector.getNumSectors[ uint8_t id ]() { return 0; }
  default command error_t Sector.read[ uint8_t id ]( storage_addr_t addr, uint8_t* buf, storage_len_t len ) { return FAIL; }
  default command error_t Sector.write[ uint8_t id ]( storage_addr_t addr, uint8_t* buf, storage_len_t len ) { return FAIL; }
  default command error_t Sector.erase[ uint8_t id ]( uint8_t sector, uint8_t num_sectors ) { return FAIL; }
  default command error_t Sector.computeCrc[ uint8_t id ]( uint16_t crc, storage_addr_t addr, storage_len_t len ) { return FAIL; }
  default async command error_t ClientResource.request[ uint8_t id ]() { return FAIL; }
  default async command error_t ClientResource.release[ uint8_t id ]() { return FAIL; }
  default command bool Circular.get[ uint8_t id ]() { return FALSE; }
  
  default async event volume_id_t Volume.getVolumeId[uint8_t id](){
    return 0xFF;
  }

  default event void Notify.notify[uint8_t id](uint8_t val){}
  command error_t Notify.enable[uint8_t id](){ return SUCCESS;}
  command error_t Notify.disable[uint8_t id](){ return FAIL;}
}
