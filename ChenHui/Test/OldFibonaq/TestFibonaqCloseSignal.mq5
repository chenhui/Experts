//+------------------------------------------------------------------+
//|                                        TestFibonaqCloseSignal.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "../../include/Fibonaq/FibonaqCloseSignal.mqh"
#include "../../include/Fibonaq/FibonaqSignalEvent.mqh"
#include "../../include/Symbol/AllSymbol.mqh"


int OnInit()
{
   TestFibonaqSignalEventAndCloseSignal();
   return(0);
}

void TestFibonaqSignalEventAndCloseSignal()
{
   Alert("<<<<<<<<<<<<<<<<<<<<< Test is started !  >>>>>>>>>>>>>>>>>>>");
   
   AllSymbols  *allSymbols;
   allSymbols=new AllSymbols;
   for(int index=0;index< allSymbols.Total();index++)
   {
      ENUM_TIMEFRAMES  timeFrame=PERIOD_M5;
      string symbol=allSymbols.At(index);       
      
      TestFibonaqSignalEvent(new FibonaqSignalEvent,symbol,timeFrame);      
      
      TestFibonaqCloseSignal(new FibonaqCloseLongSignalInUpActiveWave,symbol,timeFrame,"long","up active wave");
      TestFibonaqCloseSignal(new FibonaqCloseShortSignalInUpActiveWave,symbol,timeFrame,"short","up active wave");   
      TestFibonaqCloseSignal(new FibonaqCloseLongSignalInDownActiveWave,symbol,timeFrame,"long","down active wave");
      TestFibonaqCloseSignal(new FibonaqCloseShortSignalInDownActiveWave,symbol,timeFrame,"short","down active wave");         
   }

   delete allSymbols;
   Alert("<<<<<<<<<<<<<<<<<<<<  Test is ended ! >>>>>>>>>>>>>>>>>>>>>>");
}

void TestFibonaqSignalEvent(FibonaqSignalEvent *signalEvent,string symbol,ENUM_TIMEFRAMES timeFrame)
{
      signalEvent.Init(symbol,timeFrame);
      signalEvent.Main();
      delete signalEvent;  
}

void TestFibonaqCloseSignal(ICloseSignal *closeSignal,string symbol,ENUM_TIMEFRAMES timeFrame,string longOrShort,string upOrDownActiveWave)
{
   closeSignal.Init(symbol,timeFrame);
   if (closeSignal.Main())  Alert(symbol,"  has close ",longOrShort," signal in ",upOrDownActiveWave," by Fibonaq !  ");
   delete closeSignal;
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
