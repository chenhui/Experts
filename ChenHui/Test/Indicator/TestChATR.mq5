//+------------------------------------------------------------------+
//|                                                    TestChRsi.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "..\..\include\Indicator\ChATR.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   ChATR  *atr;
   atr=new ChATR;
   string symbol=Symbol();
   atr.Create(symbol,PERIOD_D1);
   Alert("----------------    Start Test   ",symbol,"   ATR----------------------");
   for(int index=100;index>=0;index--)
   {
      Alert("ATR[ ",index,"  ] = ",atr.Main(index));
   }
   Alert("-------------------------  End  Test Macd------------------------- -");
   delete atr;
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
