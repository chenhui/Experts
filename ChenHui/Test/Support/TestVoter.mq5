//+------------------------------------------------------------------+
//|                                    TestMultipleSymbolConfirm.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include "../../Include/Support/Voter.mqh"
#include "../../Include/Support/Support.mqh"
#include "../../Include/Support/EmaSupport.mqh"


AllSymbols  *allSymbols;

Voter *voter;

ISupport     *allSupport;
ISupport     *longSupport;
ISupport     *shortSupport;



int OnInit()
{
   string symbol="EURUSD";

   voter=new Voter;
     
   allSupport=new Support;
   allSupport.Init(symbol,PERIOD_M5);
   voter.With(allSupport);
   Alert(symbol," have ",voter.Numbers()," relation symbol");

   
   
   longSupport=new LongEmaSupport;
   longSupport.Init(symbol,PERIOD_M5);
   voter.With(longSupport);
   Alert(symbol," have ",voter.Numbers()," long support");
   
   
   
   shortSupport=new ShortEmaSupport;
   shortSupport.Init(symbol,PERIOD_M5);
   voter.With(shortSupport);
   Alert(symbol," have ",voter.Numbers()," short support");
   return (0);
}



void OnDeinit(const int reason)
{
   delete allSymbols;
   delete allSupport;
   delete longSupport;
   delete shortSupport;
   delete voter;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{

}
