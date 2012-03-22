#ifndef CX_TDMA_DEBUG_H
#define CX_TDMA_DEBUG_H

#ifdef TDMA_PIN_DEBUG_ON
#define TDMA_TOGGLE_PIN(PORT,PIN) PORT ^= PIN
#define TDMA_CLEAR_PIN(PORT,PIN)  PORT &= ~PIN
#define TDMA_SET_PIN(PORT,PIN)    PORT |= PIN

#else
#define TDMA_TOGGLE_PIN(PORT,PIN) 
#define TDMA_CLEAR_PIN(PORT,PIN)  
#define TDMA_SET_PIN(PORT,PIN)    
#endif

#if defined PORT_FS_TIMING && defined PIN_FS_TIMING 
#define FS_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_FS_TIMING, PIN_FS_TIMING)
#define FS_CLEAR_PIN TDMA_CLEAR_PIN(PORT_FS_TIMING, PIN_FS_TIMING)
#define FS_SET_PIN TDMA_SET_PIN(PORT_FS_TIMING, PIN_FS_TIMING)
#else 
#define FS_TOGGLE_PIN 
#define FS_CLEAR_PIN 
#define FS_SET_PIN 
#endif

#if defined PORT_PFS_TIMING && defined PIN_PFS_TIMING 
#define PFS_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_PFS_TIMING, PIN_PFS_TIMING)
#define PFS_CLEAR_PIN TDMA_CLEAR_PIN(PORT_PFS_TIMING, PIN_PFS_TIMING)
#define PFS_SET_PIN TDMA_SET_PIN(PORT_PFS_TIMING, PIN_PFS_TIMING)
#else 
#define PFS_TOGGLE_PIN 
#define PFS_CLEAR_PIN 
#define PFS_SET_PIN 
#endif

#if defined PORT_SC_TIMING && defined PIN_SC_TIMING 
#define SC_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_SC_TIMING, PIN_SC_TIMING)
#define SC_CLEAR_PIN TDMA_CLEAR_PIN(PORT_SC_TIMING, PIN_SC_TIMING)
#define SC_SET_PIN TDMA_SET_PIN(PORT_SC_TIMING, PIN_SC_TIMING)
#else 
#define SC_TOGGLE_PIN 
#define SC_CLEAR_PIN 
#define SC_SET_PIN 
#endif


#if defined PORT_FW_TIMING && defined PIN_FW_TIMING 
#define FW_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_FW_TIMING, PIN_FW_TIMING)
#define FW_CLEAR_PIN TDMA_CLEAR_PIN(PORT_FW_TIMING, PIN_FW_TIMING)
#define FW_SET_PIN TDMA_SET_PIN(PORT_FW_TIMING, PIN_FW_TIMING)
#else 
#define FW_TOGGLE_PIN 
#define FW_CLEAR_PIN 
#define FW_SET_PIN 
#endif

#if defined PORT_SS_TIMING && defined PIN_SS_TIMING 
#define SS_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_SS_TIMING, PIN_SS_TIMING)
#define SS_CLEAR_PIN TDMA_CLEAR_PIN(PORT_SS_TIMING, PIN_SS_TIMING)
#define SS_SET_PIN TDMA_SET_PIN(PORT_SS_TIMING, PIN_SS_TIMING)
#else 
#define SS_TOGGLE_PIN 
#define SS_CLEAR_PIN 
#define SS_SET_PIN 
#endif

#if defined PORT_TX_TIMING && defined PIN_TX_TIMING 
#define TX_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_TX_TIMING, PIN_TX_TIMING)
#define TX_CLEAR_PIN TDMA_CLEAR_PIN(PORT_TX_TIMING, PIN_TX_TIMING)
#define TX_SET_PIN TDMA_SET_PIN(PORT_TX_TIMING, PIN_TX_TIMING)
#else 
#define TX_TOGGLE_PIN 
#define TX_CLEAR_PIN 
#define TX_SET_PIN 
#endif

#if defined PORT_TXCP_TIMING && defined PIN_TXCP_TIMING 
#define TXCP_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_TXCP_TIMING, PIN_TXCP_TIMING)
#define TXCP_CLEAR_PIN TDMA_CLEAR_PIN(PORT_TXCP_TIMING, PIN_TXCP_TIMING)
#define TXCP_SET_PIN TDMA_SET_PIN(PORT_TXCP_TIMING, PIN_TXCP_TIMING)
#else 
#define TXCP_TOGGLE_PIN 
#define TXCP_CLEAR_PIN 
#define TXCP_SET_PIN 
#endif

#if defined PORT_PFS_CYCLE && defined PIN_PFS_CYCLE 
#define PFS_CYCLE_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_PFS_CYCLE, PIN_PFS_CYCLE)
#define PFS_CYCLE_CLEAR_PIN TDMA_CLEAR_PIN(PORT_PFS_CYCLE, PIN_PFS_CYCLE)
#define PFS_CYCLE_SET_PIN TDMA_SET_PIN(PORT_PFS_CYCLE, PIN_PFS_CYCLE)
#else 
#define PFS_CYCLE_TOGGLE_PIN 
#define PFS_CYCLE_CLEAR_PIN 
#define PFS_CYCLE_SET_PIN 
#endif

#if defined PORT_FS_CYCLE && defined PIN_FS_CYCLE 
#define FS_CYCLE_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_FS_CYCLE, PIN_FS_CYCLE)
#define FS_CYCLE_CLEAR_PIN TDMA_CLEAR_PIN(PORT_FS_CYCLE, PIN_FS_CYCLE)
#define FS_CYCLE_SET_PIN TDMA_SET_PIN(PORT_FS_CYCLE, PIN_FS_CYCLE)
#else 
#define FS_CYCLE_TOGGLE_PIN 
#define FS_CYCLE_CLEAR_PIN 
#define FS_CYCLE_SET_PIN 
#endif

#if defined PORT_GP && defined PIN_GP 
#define GP_TOGGLE_PIN TDMA_TOGGLE_PIN(PORT_GP, PIN_GP)
#define GP_CLEAR_PIN TDMA_CLEAR_PIN(PORT_GP, PIN_GP)
#define GP_SET_PIN TDMA_SET_PIN(PORT_GP, PIN_GP)
#else 
#define GP_TOGGLE_PIN 
#define GP_CLEAR_PIN 
#define GP_SET_PIN 
#endif

#ifdef DEBUG_TDMA_SS
#define printf_TDMA_SS(...) printf(__VA_ARGS__)
#else
#define printf_TDMA_SS(...) 
#endif


#endif
