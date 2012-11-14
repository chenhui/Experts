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
#include "..\..\Include\Signal\MacdSerialSignal.mqh"

ISerialSignal  *macdSerialPositiveSignal;
ISerialSignal  *macdSerialNegativeSignal;
AllSymbols     *symbols;

int OnInit()
{
   symbols=new AllSymbols;
   macdSerialPositiveSignal=new MacdSerialPositiveSignal;
   macdSerialNegativeSignal=new MacdSerialNegativeSignal;
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   delete macdSerialPositiveSignal;
   delete macdSerialNegativeSignal;
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
      macdSerialPositiveSignal.Init(symbol,PERIOD_M5,serial);
      macdSerialNegativeSignal.Init(symbol,PERIOD_M5,serial);
      if (macdSerialPositiveSignal.Main())  Alert(symbol," :  Macd  of serial ",serial,"  > 0 !!");
      if (macdSerialNegativeSignal.Main()) Alert(symbol," :  Macd  of serial ",serial,"  < 0 !!");
   }
}
//+------------------------------------------------------------------+
