//+------------------------------------------------------------------+
//|                                                TestGthOpener.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "../../include/Fibonaq/FibonaqExpert.mqh"
#include <Strings\String.mqh>
#include "../../include/Fibonaq/FibonaqSignalEvent.mqh"



//-----------------------------------------------------------------------
input int      MagicNumber=28888;
input string   Comment="FibonaqM5";
input ENUM_TIMEFRAMES  TimeFrame=PERIOD_M5;
input int      PrmryStoploss=50;
input double   Lots=0.01;
input int      StartDay=TODAY;
input int      StartHour=16;
input int      EndDay=TOMORROW;
input int      EndHour=3;

FibonaqExpert *expert;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
   
   Alert("Time is ",TimeCurrent(),"   Fibonaq expert is started ! ");
   ShowTradeTimeSection();
   
   expert=new FibonaqExpert;
   expert.Init(MagicNumber,Comment,TimeFrame,PrmryStoploss,Lots,StartDay,StartHour,EndDay,EndHour);
   return(0);
}

void ShowTradeTimeSection()
{
   TimeSection *timeSection;   
   timeSection=new TimeSection;
   timeSection.Init(StartDay,StartHour,EndDay,EndHour);
   Alert("Trade Start time is ",timeSection.StartTimeOfOrder()," , Trade end time is ",timeSection.EndTimeOfOrder());
   delete timeSection;

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   delete expert;
   expert=NULL;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   
   ShowFibonaqSignalEventAndOpenSignal();
   Alert("Time is ",TimeCurrent()," Start one loop  !");
   expert.AllMain();
   Alert("Time is ",TimeCurrent()," end one loop  !");
}


void ShowFibonaqSignalEventAndOpenSignal()
{
   Alert("<<<<<<<<<<<<<<<<<<<<< Test is started !  >>>>>>>>>>>>>>>>>>>");
   
   AllSymbols  *allSymbols;
   allSymbols=new AllSymbols;
   for(int index=0;index< allSymbols.Total();index++)
   {
      ENUM_TIMEFRAMES  timeFrame=PERIOD_M5;
      string symbol=allSymbols.At(index);       
      
      ShowFibonaqSignalEvent(new FibonaqSignalEvent,symbol,timeFrame);      
      
      ShowFibonaqOpenSignal(new FibonaqOpenLongSignalInUpActiveWave,symbol,timeFrame,"long","up active wave");
      ShowFibonaqOpenSignal(new FibonaqOpenShortSignalInUpActiveWave,symbol,timeFrame,"short","up active wave");   
      ShowFibonaqOpenSignal(new FibonaqOpenLongSignalInDownActiveWave,symbol,timeFrame,"long","down active wave");
      ShowFibonaqOpenSignal(new FibonaqOpenShortSignalInDownActiveWave,symbol,timeFrame,"short","down active wave");         
   }

   delete allSymbols;
   Alert("<<<<<<<<<<<<<<<<<<<<  Test is ended ! >>>>>>>>>>>>>>>>>>>>>>");
}

void ShowFibonaqSignalEvent(FibonaqSignalEvent *signalEvent,string symbol,ENUM_TIMEFRAMES timeFrame)
{
      signalEvent.Init(symbol,timeFrame);
      signalEvent.Main();
      delete signalEvent;  
}

void ShowFibonaqOpenSignal(IOpenSignal *openSignal,string symbol,ENUM_TIMEFRAMES timeFrame,string longOrShort,string upOrDownActiveWave)
{
   openSignal.Init(symbol,timeFrame);
   if (openSignal.Main())  Alert(symbol,"  has open ",longOrShort," signal in ",upOrDownActiveWave," by Fibonaq !  ");
   delete openSignal;
}

