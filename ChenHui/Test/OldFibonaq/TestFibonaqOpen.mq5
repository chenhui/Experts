//+------------------------------------------------------------------+
//|                                                TestGthOpener.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "../../include/Fibonaq/FibonaqOpen.mqh"

AllSymbols  *allSymbols;

int OnInit()
{
   allSymbols=new AllSymbols;
   Alert("<<<<<<<<<<< Time is ",TimeCurrent()," Test is started ");
   TestFibonaqOpenSignal();
   TestOpen();
   Alert(" Time is ",TimeCurrent()," Test is end >>>>>>>> ");  
   return(0);
}


void TestFibonaqOpenSignal()
{
   //Alert("<<<<<<<<<<<<<<<<<<<<< Test is started !  >>>>>>>>>>>>>>>>>>>");
   
   for(int index=0;index< allSymbols.Total();index++)
   {
      ENUM_TIMEFRAMES  timeFrame=PERIOD_M5;
      string symbol=allSymbols.At(index);            
      
      TestFibonaqOpenSignal(new FibonaqOpenLongSignalInUpActiveWave,symbol,timeFrame,"long","up active wave");
      TestFibonaqOpenSignal(new FibonaqOpenShortSignalInUpActiveWave,symbol,timeFrame,"short","up active wave");   
      TestFibonaqOpenSignal(new FibonaqOpenLongSignalInDownActiveWave,symbol,timeFrame,"long","down active wave");
      TestFibonaqOpenSignal(new FibonaqOpenShortSignalInDownActiveWave,symbol,timeFrame,"short","down active wave");         
   }

//   Alert("<<<<<<<<<<<<<<<<<<<<  Test is ended ! >>>>>>>>>>>>>>>>>>>>>>");
}

void TestFibonaqOpenSignal(ISignal *openSignal,string symbol,ENUM_TIMEFRAMES timeFrame,string longOrShort,string upOrDownActiveWave)
{
   openSignal.Init(symbol,timeFrame);
   if (openSignal.Main())  Alert(symbol,"  has open ",longOrShort," signal in ",upOrDownActiveWave," by Fibonaq !  ");
   delete openSignal;
}


void TestOpen()
{
   for(int index=0;index<allSymbols.Total();index++)
   {     
      string symbol=allSymbols.At(index);
      Do(symbol,new FibonaqOpenLongPositionInUpActiveWave);
      Do(symbol,new FibonaqOpenShortPositionInUpActiveWave);
      Do(symbol,new FibonaqOpenLongPositionInDownActiveWave);
      Do(symbol,new FibonaqOpenShortPositionInDownActiveWave);
   }
}


void  Do(string symbol,IOpen *fibonaqOpen)
{
   fibonaqOpen.Init(111111,"Fibonaq",PERIOD_M5,0.01,0);
   fibonaqOpen.Main(symbol); 
   delete fibonaqOpen;
}

void OnTick()
{
}

void OnDeinit(const int reason)
{
   delete allSymbols;
}
