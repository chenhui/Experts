//+------------------------------------------------------------------+
//|                                                    TestChRsi.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "..\..\include\Indicator\ChRsi.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   ChRsi  *rsi;
   rsi=new ChRsi;
   string symbol=Symbol();
   rsi.Create(symbol,PERIOD_CURRENT);
   Alert("----------------Start Test   ",symbol,"   Rsi----------------------");
   for(int index=100;index>=0;index--)
   {
      Alert("RSI[ ",index,"  ] = ",rsi.Main(index));
   }
   Alert("----------------End  Test Rsi-------------------");
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
