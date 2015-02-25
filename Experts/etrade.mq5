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
int EVENT_ID = 0;     
int FRAME_ID = 0;     
bool IS_ACTIVE = false;

enum {
   CMD_SET_EVENT = 0x01,
   CMD_SET_ACTIVE = 0x04
   };
   

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
            
            uchar p_buffer_recieve_common[1];             
            long tick = 0;
            
            int len_buffer_recieve_common = interprocess_slave_recieve_common(p_buffer_recieve_common, ArraySize(p_buffer_recieve_common), 15000, tick);
            if (len_buffer_recieve_common > 0) 
            {
               openOrder();
               uchar p_buffer_recieve[1];
               int len_buffer_recieve = interprocess_slave_recieve( FRAME_ID, p_buffer_recieve, ArraySize(p_buffer_recieve) );               
               
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
   int i = 0;
   while (i<2)
   {
      i++;
      Sleep(tick); // период ожидания согласно пункта 1 ТЗ      
   }
   // Имитируем получения данных
   ArrayResize(p_buffer, bc_buffer_capacity * 2); 
   ArrayInitialize(p_buffer, 'A');
   return ArraySize(p_buffer);
}

int interprocess_slave_recieve(int p_frame_id, char &p_buffer[],int bc_buffer_capacity)
{
   struct item_format
   {
      short TYPE;// (1: NORM, 2: AGR,  4: TEST)
      int QTY; //  ( -> double  / 1000) 
      int DIV;
      int PROFIT;
   };
   
   struct event_params 
   {
      int EVENT_ID; //идентификатор события
      string SYMBOL;
      short MULT;
      int STOPLOSS;
      int POINTS_BU;
      int NORM_SPREAD;
      int DIV_BU;
      bool IS_REVERSE;
      int ORDER_MAGIC;
      short ITEMS_COUNT;
      item_format ITEMS[3];
   };
      
   event_params eventParams = {1, "test", 3, 50, 20, 35, 15, true, 2, sizeof(event_params), {{1, 30, 20, 5}, {4, 20, 50, 10}, {2, 25, 45, 3}}};
   
   
   
   return 0;
}


void openOrder()
{
}
