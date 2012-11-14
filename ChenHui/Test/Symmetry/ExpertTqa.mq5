//+------------------------------------------------------------------+
//|                                                   TestChPlus.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "..\..\include\Signals\TqaSignal.mqh"
#include "..\..\include\Stoploss\PrimaryStoplossCalculate.mqh"
#include "..\..\include\Symmetry\Symmetry.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ulong MagicNumber=000004;
input int EventTime=10;
input double Lots=0.01;
input int OpenRange=20;
input int CloseRange=10;
input int FastPeriod=25;
input int SlowPeriod=350;
input int PrimaryStoploss=0;


////---------------------------------------------------------------------+


string   symbol;
ENUM_TIMEFRAMES timeFrame;
Parameters parameters;

Symmetry *expert;
ISignal *signal;
TimeSectionChecker *timeChecker;
IStoplosser    *stoplosser;

int OnInit()
{
   EventSetTimer(EventTime);
   symbol=Symbol();
   timeFrame=PERIOD_CURRENT;
   
   parameters.intOne=OpenRange;
   parameters.intTwo=CloseRange;
   parameters.intThree=FastPeriod;
   parameters.intFour=SlowPeriod;   
   
   signal=new TqaSignal;
   signal.Init(symbol,timeFrame,parameters);
   
   timeChecker=new TimeSectionChecker;
   timeChecker.InitOne(AllSection);
   //Section one={TODAY,1,TODAY,2};
   //Section eighteen={TODAY,19,TODAY,20};
   //Section twentytwo={TODAY,22,TODAY,23};
   //timeChecker.InitOne(one);
   //timeChecker.InitTwo(eighteen);
   //timeChecker.InitThree(twentytwo);
   
   stoplosser=new FixPrimaryStoplosser;
   stoplosser.Init(symbol,timeFrame,PrimaryStoploss);
   
   expert=new Symmetry;   
   expert.Init(MagicNumber,symbol,timeFrame,Lots,signal,timeChecker,stoplosser);
   return(0);
}


void OnTimer()
{
   expert.Main();
}


void OnDeinit(const int reason)
{
   EventKillTimer();
   if (expert!=NULL) delete expert;
   if (signal!=NULL) delete signal;
   if (timeChecker!=NULL) delete timeChecker;
      
}

void OnTick()
{
}
