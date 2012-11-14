//+------------------------------------------------------------------+
//|                                                    TestChRsi.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "..\..\include\Indicator\ChEma.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
ChEma *ema;
int OnInit()
{
   ema=new ChEma;
   ema.InitBeforeCreate(100);
   string symbol=Symbol();
   ema.Create(symbol,PERIOD_CURRENT);
   Alert("----------------Start Test   ",symbol,"   Macd----------------------");
   for(int index=100;index>=0;index--)
   {
      Alert("EMA[ ",index,"  ] = ",ema.Main(index));
   }
   Alert("----------------End  Test Macd-------------------");
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   delete ema;   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   
}
//+------------------------------------------------------------------+
