//+------------------------------------------------------------------+
//|                                      TestActiveWaveOfNearest.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\include\Fibonaq\ActiveWaveOfNearest.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

NearestActiveWave *activeWave;
int OnInit()
{
   EventSetTimer(60);
   activeWave=new NearestActiveWave;
   activeWave.Init(Symbol(),PERIOD_CURRENT,10);
   activeWave.Refresh();      
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   if (activeWave!=NULL) delete activeWave;
      
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
//---
   
  }
//+------------------------------------------------------------------+
