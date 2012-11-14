//+------------------------------------------------------------------+
//|                                        TestFibonaqOpenSignal.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "../../include/Fibonaq/FibonaqOpenSignal.mqh"
#include "../../include/Fibonaq/FibonaqSignalEvent.mqh"
#include "../../include/Symbol/AllSymbol.mqh"


int OnInit()
{
   TestFibonaqSignalEventAndOpenSignal();
   return(0);
}

void TestFibonaqSignalEventAndOpenSignal()
{
   Alert("<<<<<<<<<<<<<<<<<<<<< Test is started !  >>>>>>>>>>>>>>>>>>>");
   
   AllSymbols  *allSymbols;
   allSymbols=new AllSymbols;
   for(int index=0;index< allSymbols.Total();index++) 
   {
      ENUM_TIMEFRAMES  timeFrame=PERIOD_M5;
      string symbol=allSymbols.At(index);       
      
      TestFibonaqSignalEvent(new FibonaqSignalEvent,symbol,timeFrame);      
      
      TestFibonaqOpenSignal(new FibonaqOpenLongSignalInUpActiveWave,symbol,timeFrame,"long","up active wave");
      TestFibonaqOpenSignal(new FibonaqOpenShortSignalInUpActiveWave,symbol,timeFrame,"short","up active wave");   
      TestFibonaqOpenSignal(new FibonaqOpenLongSignalInDownActiveWave,symbol,timeFrame,"long","down active wave");
      TestFibonaqOpenSignal(new FibonaqOpenShortSignalInDownActiveWave,symbol,timeFrame,"short","down active wave");         
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

void TestFibonaqOpenSignal(ISignal *openSignal,string symbol,ENUM_TIMEFRAMES timeFrame,string longOrShort,string upOrDownActiveWave)
{
   openSignal.Init(symbol,timeFrame);
   if (openSignal.Main())  Alert(symbol,"  has open ",longOrShort," signal in ",upOrDownActiveWave," by Fibonaq !  ");
   //else Alert(symbol,"  has not open ",longOrShort," signal in ",upOrDownActiveWave," by Fibonaq ! ");   
   delete openSignal;
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
