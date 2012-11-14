//+------------------------------------------------------------------+
//|                                                   TestChPlus.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Indicator\ChCamarillaPivot.mqh"
#include "..\..\Include\Signals\CamarillaSignal.mqh"
#include "..\..\Include\Symmetry\Symmetry.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ulong MagicNumber=000034;
input int EventTime=100;
input double Lots=0.01;
input int PrimaryStoploss=0;

//-------------------------------------------------------------------+

string   symbol;
ENUM_TIMEFRAMES timeFrame;
Parameters parameters;

SymmetryInDay *expert3;
ISignal *signal3;
TimeSectionChecker *timeChecker;
TimeSectionChecker *cleanTimeChecker;
IStoplosser *stoplosser;

SymmetryInDay *expert4;
ISignal  *signal4;

int OnInit()
{
   EventSetTimer(EventTime);
   symbol=Symbol();
   timeFrame=PERIOD_CURRENT;
   
   signal3=new Camarilla3Signal;
   signal3.Init(symbol,timeFrame,parameters);  
   
   timeChecker=new TimeSectionChecker;
   timeChecker.InitOne(AllSection); 
   
   cleanTimeChecker=new TimeSectionChecker;
   cleanTimeChecker.InitOne(NullSection);
   
   stoplosser=new FixPrimaryStoplosser;
   stoplosser.Init(symbol,timeFrame,PrimaryStoploss);
     
   expert3=new SymmetryInDay;
   expert3.Init(MagicNumber,symbol,timeFrame,Lots,signal3,timeChecker,cleanTimeChecker,stoplosser);
   
   signal4=new Camarilla4Signal;
   signal4.Init(symbol,timeFrame,parameters);
   
   expert4=new SymmetryInDay;
   expert4.Init(MagicNumber,symbol,timeFrame,Lots,signal4,timeChecker,cleanTimeChecker,stoplosser);
   return(0);
}



void OnTimer()
{
   expert3.Main();
   expert4.Main();
}


void OnDeinit(const int reason)
{
   EventKillTimer();
   if (expert3!=NULL) delete expert3;
   if (signal3!=NULL) delete signal3;
   if (expert4!=NULL) delete expert4;
   if (signal4!=NULL) delete signal4;
   if (timeChecker!=NULL ) delete timeChecker;
   if (stoplosser!=NULL)   delete stoplosser;
      
}

void OnTick()
{
}

