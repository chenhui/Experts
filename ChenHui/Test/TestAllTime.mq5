//+------------------------------------------------------------------+
//|                                                  TestAllTime.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      Alert("TimeCurrent= ",TimeCurrent(),
            "  TimeGMT= ", TimeGMT(),
            "  TimeLocal= ",TimeLocal(),
            "  TimeGMTOffset= ",TimeGMTOffset());
  }
//+------------------------------------------------------------------+
