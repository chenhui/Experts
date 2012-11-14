//+------------------------------------------------------------------+
//|                                                  TestChPivot.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "../../Include/Indicator/ChPivot.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

ChCamarillaPivot  *chCamarilla;

int OnInit()
{
   EventSetTimer(60);
   chCamarilla=new ChCamarillaPivot;
   chCamarilla.Init("EURUSD",PERIOD_D1);
   Alert(" Pivot = ",chCamarilla.Pivot(),
         " L1 = ",chCamarilla.L1(),
         " L2 = ",chCamarilla.L2(),
         " L3 = ",chCamarilla.L3(),
         " L4 = ",chCamarilla.L4());
   Alert(" L5 = ",chCamarilla.L5(),
         " H1 = ",chCamarilla.H1(),
         " H2 = ",chCamarilla.H2(),
         " H3 = ",chCamarilla.H3(),
         " H4 = ",chCamarilla.H4(),
         " H5 = ",chCamarilla.H5());
      
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   
}
//+------------------------------------------------------------------+
