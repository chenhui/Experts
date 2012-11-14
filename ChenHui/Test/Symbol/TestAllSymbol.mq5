//+------------------------------------------------------------------+
//|                                                TestAllSymbol.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "../../Include/Symbol/AllSymbol.mqh"

AllSymbols *allSymbols;

int OnInit()
{
   EventSetTimer(60);
   Alert("---------------All symbol test-------------------------------");
   allSymbols=new AllSymbols;
   TestAllSymbol();
   TestIsExistSymbol();
   TestIsExistReversedSymbol();
   return(0);
}

void TestAllSymbol()
{
   for(int index=0;index<allSymbols.Total();index++)
   {
      Alert(" Symbol[ ",index," ]= ",allSymbols.At(index));
   }
}

void TestIsExistSymbol()
{
   if (allSymbols.IsExist("EURUSD"))  Alert("Ok!  EURUSD is existed");
   if (allSymbols.IsExist("NZDUSD"))  Alert("Ok!  NZDUSD is existed");
   if (!allSymbols.IsExist("USDEUR")) Alert("Ok!  USDEUR is not existed");
}

void TestIsExistReversedSymbol()
{
   if (allSymbols.IsReversedExist("USDEUR"))  Alert("Ok!  USDEUR reversed is existed");
   if (allSymbols.IsReversedExist("CHFGBP"))  Alert("Ok!  CHFGBP reversed is existed");
   if (!allSymbols.IsReversedExist("NZDCHF")) Alert("Ok!  NZDCHF reversed is not existed");
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
