//+------------------------------------------------------------------+
//|                                            TestKSerialSignal.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "..\..\Include\Signal\KSerialSignal.mqh"

ISerialSignal  *kLongSignal;
ISerialSignal  *kShortSignal;
AllSymbols     *symbols;

int OnInit()
{
   symbols=new AllSymbols;
   kLongSignal=new KSerialLongSignal;
   kShortSignal=new KSerialShortSignal;
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   delete kLongSignal;
   delete kShortSignal;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   for(int i=0;i<symbols.Total();i++)
   {
      int serial=4;
      string symbol=symbols.At(i);
      kLongSignal.Init(symbol,PERIOD_M5,serial);
      kShortSignal.Init(symbol,PERIOD_M5,serial);
      if (kLongSignal.Main())  Alert(symbol," :  is serial 4 long !!");
      if (kShortSignal.Main()) Alert(symbol," :  is serial 4 short !!");
   }
}
//+------------------------------------------------------------------+
