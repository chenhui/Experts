//+------------------------------------------------------------------+
//|                                           TestBreakTwentyDay.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Indicator\ChPrice.mqh"
#include "..\..\Include\Stage\Extremum.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


int OnInit()
{

   Highest *highest=new Highest;
   highest.Init(Symbol(),PERIOD_CURRENT,new ChHigh,20);
   Alert(Symbol()," highest : ",highest.ValueOf()," index : ",highest.IndexOf());
   delete highest;
   
   Lowest *lowest=new Lowest;
   lowest.Init(Symbol(),PERIOD_CURRENT,new ChLow,20);
   Alert(Symbol()," lowest : ",lowest.ValueOf()," index : ",lowest.IndexOf());
   delete lowest;

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
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   
}
//+------------------------------------------------------------------+

