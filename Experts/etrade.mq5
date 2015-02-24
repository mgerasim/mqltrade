//+------------------------------------------------------------------+
//|                                                       etarde.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include "C:\Program Files\MetaTrader 5\MQL5\Experts\buf.mqh";

int EVENT_ID = 0;
int FRAME_ID = 0;     
int CLIENT_ID = 0;
bool IS_ACTIVE = false;
int isActiveTrade;
enum {
   CMD_SET_EVENT = 0x01,
   CMD_SET_ACTIVE = 0x04
   };
   
 /*Параметры команды SET_EVENT*/
int stageId_ ;
int stageTime_;
uchar symbol_;               
int pointsBU_;
int divBU_;

int OnInit()
  {
//--- create timer
   EventSetMillisecondTimer(500);
   
      
//---
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{  
   string frameIdStr;       
   frameIdStr = ChartGetString(ChartID(),CHART_COMMENT);
   FRAME_ID = StringToInteger(frameIdStr);
   if ( FRAME_ID > 0 ) {
      while(!IsStopped()) {
         if (EVENT_ID > 0 && IS_ACTIVE == true) 
         {
            Print("получаем данные");
            
            uchar p_buffer[1];             
            long tick = 0;
            
            int len = interprocess_slave_recieve_common(p_buffer, ArraySize(p_buffer), 15000, tick);
            if (len > 0) 
            {
               openOrder();
               
               int type;
               int in_buf_size;
               int last_size;
               uchar in_buf_last[];
               
               ArrayResize(in_buf_, 0, 1000); 
               in_len_ = interprocess_slave_recieve(CLIENT_ID, p_buffer, ArraySize(p_buffer));
               if(in_len_ > 0){
                  in_buf_next_packet_ind_ = 0;
                  ArrayResize(in_buf_, in_len_ + in_buf_size, 1000);
                  ArrayCopy(
                     in_buf_,             
                     p_buffer,        
                     in_buf_size,         
                     0,    
                     in_len_  
                  );
                  in_len_ += in_buf_size;
                  while (nextPacket()){
                     type = (int)readByte();
                     switch (type) {
                        case CMD_SET_EVENT:
                           stageId_ = readInt();
                           stageTime_ = readInt();
                           symbol_ = readString(readShort());
                           symbolMult_ = readShort();
                           readInt();
                           pointsBU_ = readInt() * symbolMult_;
                           readInt();
                           divBU_ = readInt() * symbolMult_;
                           readByte();
                           updateMagic(readInt());
             
                           sendToChart(/*tradeChart_*/0, /*EVENT_STAGE*/0, getPacket()); 
               
                           initOrders();
                           setRefreshOrder(symbol_);
                        break;
                        
                        case CMD_SET_ACTIVE:
                           isActiveTrade = readByte() > 0 ? true : false;
                           sendToChart(/*tradeChart*/0, /*EVENT_ACTIVE_TRADE*/0, isActiveTrade ? 1 : 0);
                           setRefreshOrder(symbol_);
                        break;
                     }
                  }   
                  last_size = in_len_ - in_buf_next_packet_ind_;
                  ArrayResize(in_buf_last, last_size, 1000);
                  ArrayCopy(
                           in_buf_last,
                           in_buf_,    
                           0,         
                           in_buf_next_packet_ind_,         
                           last_size    
                  );
                  ArrayResize(in_buf_, last_size, 1000);
                  ArrayCopy(
                     in_buf_,   
                     in_buf_last
                  );                                 
               }
             }             
         }  
         else
         {
            Sleep(500);
         }       
      }      
   }   
}
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+

int interprocess_slave_recieve_common(char &p_buffer[], int bc_buffer_capacity, int t, int tick)
{
   return 0;
}

int interprocess_slave_recieve(int p_frame_id, char &p_buffer[],int bc_buffer_capacity)
{
   return 0;
}

bool isStopped()
{
   
   return false;
}

void openOrder()
{
}

void updateMagic(int p)
{
}

void sendToChart(int tradeChart, int event_id, int p)
{
}

void initOrders()
{
}

void setRefreshOrder(uchar symbol_)
{
}