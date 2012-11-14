//+------------------------------------------------------------------+
//|                                                TestGthOpener.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\include\BollingerUltraDepart\BollingerUltraDepartOpenSignal.mqh"
#include "..\..\include\Symbol\AllSymbol.mqh"


int OnInit()
{
   return(0);
}


void OnTick()
{
   TestOpenSignal(); 
}

void TestOpenSignal()
{
   AllSymbols *allSymbols=new AllSymbols;
   for(int index=0;index<allSymbols.Total();index++)
   {
      string symbol=allSymbols.At(index);
      ENUM_TIMEFRAMES  timeFrame=PERIOD_M5;
      DoBollingerUltraDepart(new BollingerUltraDepartOpenLongSignal,symbol,timeFrame);
      DoBollingerUltraDepart(new BollingerUltraDepartOpenShortSignal,symbol,timeFrame);
   } 
   delete allSymbols;  
  
}

void DoBollingerUltraDepart(ISignal *signal,string symbol,ENUM_TIMEFRAMES timeFrame)
{
   signal.Init(symbol,timeFrame);
   signal.Main();
   if (signal!=NULL) {delete  signal; signal=NULL;}
}

void OnDeinit(const int reason)
{
}
