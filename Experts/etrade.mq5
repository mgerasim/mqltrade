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
bool IS_ACTIVE = false;

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
   int FRAME_ID;     
   frameIdStr = ChartGetString(ChartID(),CHART_COMMENT);
   FRAME_ID = StringToInteger(frameIdStr);
   if ( FRAME_ID > 0 ) {
      while(!IsStopped()) {
         if (EVENT_ID > 0 && IS_ACTIVE == true) 
         {
            Print("получаем данные");
            int len = interprocess_slave_recieve_common();
            if (len > 0) 
            {               
               openOrder();
            }
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

int interprocess_slave_recieve_common()
{
   return 0;
}

int interprocess_slave_recieve(int FRAME_ID, char &p_buffer[],int bc_buffer_capacity)
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