//+------------------------------------------------------------------+
//|                                                   TestChPlus.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\Include\Symmetry\ExpertPluss.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ulong MagicNumber=000001;
input int EventTime=100;
input double Lots=0.01;
input int Threashold=34;
input int Interval=0;
input int PrimaryStoploss=0;


ExperPlusWithTimeSection *expert;


int OnInit()
{
   EventSetTimer(EventTime);
   
   string symbol=Symbol();
   ENUM_TIMEFRAMES timeFrame=PERIOD_CURRENT;
   expert=new ExperPlusWithTimeSection;
   expert.Init(MagicNumber,symbol,timeFrame,Lots,Threashold,Interval,PrimaryStoploss);
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
      
}

void OnTick()
{

}