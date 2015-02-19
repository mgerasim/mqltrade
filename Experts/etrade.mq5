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
               switch (p_buffer[0]) {
                  case 9: // buyNormal
                        openOrder();
                      break;
                  case 8: // sellNorm
                        openOrder();
                      break;
                  case 7: // buyAgr
                        openOrder();
                      break;
                  case 6: // sellAgr
                        openOrder();
                      break;
                  case 5: // buyTest
                        openOrder();
                      break;
                  case 4: // sellTest
                        openOrder();
                      break;
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