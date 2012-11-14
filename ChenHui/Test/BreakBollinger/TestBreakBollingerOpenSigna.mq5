//+------------------------------------------------------------------+
//|                                  TestBreakBollingerOpenSigna.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "../../include/BreakBollinger/BreakBollingerOpenSignal.mqh"
#include "../../include/signal/ISignal.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
AllSymbols *symbols;
ISignal *openLongSignal;
ISignal *openShortSignal;


int OnInit()
{
   symbols=new AllSymbols;
   openLongSignal=new BreakBollingerOpenLongSignal;
   openShortSignal=new BreakBollingerOpenShortSignal;

   return(0);
}

void OnTick()
{
   CheckAllOpenLongSignal(PERIOD_M5);
   CheckAllOpenShortSignal(PERIOD_M5);
}

void CheckAllOpenLongSignal(ENUM_TIMEFRAMES timeFrame)
{
   CheckAllOpenSignal(openLongSignal,"long",timeFrame);
}

void CheckAllOpenShortSignal(ENUM_TIMEFRAMES timeFrame)
{
   CheckAllOpenSignal(openShortSignal,"short",timeFrame);
}

void CheckAllOpenSignal(ISignal *openSignal,string direction,ENUM_TIMEFRAMES timeFrame)
{
   for (int i=0;i<symbols.Total();i++)
   {
      string symbol=symbols.At(i);
      openSignal.Init(symbol,timeFrame);
      if (openSignal.Main())  Alert(i," : ",symbol ," : is open " ,direction," signal by breakbollinger in  ",timeFrame);
   }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(symbols!=NULL) delete symbols; symbols=NULL;   
   if(openLongSignal!=NULL) delete openLongSignal; openLongSignal=NULL;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
