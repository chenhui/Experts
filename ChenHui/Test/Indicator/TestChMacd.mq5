//+------------------------------------------------------------------+
//|                                                    TestChRsi.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "..\..\include\Indicator\ChMacd.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   ChMacd  *macd;
   macd=new ChMacd;
   string symbol=Symbol();
   macd.Create(symbol,PERIOD_CURRENT);
   Alert("----------------Start Test   ",symbol,"   Macd----------------------");
   for(int index=100;index>=0;index--)
   {
      Alert("MACD[ ",index,"  ] = ",macd.Main(index));
   }
   Alert("----------------End  Test Macd-------------------");
   delete macd;
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
