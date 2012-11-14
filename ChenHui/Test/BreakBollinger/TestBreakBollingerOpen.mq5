//+------------------------------------------------------------------+
//|                                                TestGthOpener.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "../../include/BreakBollinger/BreakBollingerOpen.mqh"

AllSymbols  *allSymbols;

int OnInit()
{
   allSymbols=new AllSymbols;
   Alert("<<<<<<<<<<< Time is ",TimeCurrent()," Test is started "); 
   return(0);
}

void OnTick()
{
   TestOpenSignal();
   //TestOpen();
}


void TestOpenSignal()
{
   //Alert("<<<<<<<<<<<<<<<<<<<<< Test is started !  >>>>>>>>>>>>>>>>>>>");
   
   for(int index=0;index< allSymbols.Total();index++)
   {
      ENUM_TIMEFRAMES  timeFrame=PERIOD_M5;
      string symbol=allSymbols.At(index); 
      TestOpenSignal(new BreakBollingerOpenLongSignalInM5AndM30,symbol,timeFrame,"long","down in M5 and M30");
      TestOpenSignal(new BreakBollingerOpenShortSignalInM5AndM30,symbol,timeFrame,"short","up in M5 and M30");         
      TestOpenSignal(new BreakBollingerOpenLongSignalInM1AndM5AndM30,symbol,timeFrame,"long","down in M1 and M5 and M30");
      TestOpenSignal(new BreakBollingerOpenShortSignalInM1AndM5AndM30,symbol,timeFrame,"short","up in M1 and M5 and M30"); 
       
   }

//   Alert("<<<<<<<<<<<<<<<<<<<<  Test is ended ! >>>>>>>>>>>>>>>>>>>>>>");
}

void TestOpenSignal(ISignal *openSignal,string symbol,ENUM_TIMEFRAMES timeFrame,string longOrShort,string upOrDown)
{
   openSignal.Init(symbol,timeFrame);
   if (openSignal.Main())  Alert(symbol," !!!  has open ",longOrShort," signal in ",upOrDown," by BreakBollinger !  ");
   delete openSignal;
}


void TestOpen()
{
   for(int index=0;index<allSymbols.Total();index++)
   {     
      string symbol=allSymbols.At(index);
      Do(symbol,new BreakBollingerOpenLongPositionInM1AndM5AndM30);
      Do(symbol,new BreakBollingerOpenShortPositionInM1AndM5AndM30);

   }
}


void  Do(string symbol,IOpen *open)
{
   open.Init(111111,"BreakBollinger",PERIOD_M5,0.1,0);
   open.Main(symbol); 
   delete open;
}



void OnDeinit(const int reason)
{
   delete allSymbols;
}
