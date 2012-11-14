//+------------------------------------------------------------------+
//|                                     NewExperPlusIntervalFive.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "..\..\Include\Symmetry\ExpertPluss.mqh"

input ulong MagicNumber=000001;
input int EventTime=100;
input double Lots=1;
input int Threashold=34;
input int Interval=5;
input int PrimaryStoploss=0;


ExpertPlusWithInterval  *expert;


int OnInit()
{
   EventSetTimer(EventTime);  
   
   expert=new ExpertPlusWithInterval;
   expert.Init(MagicNumber,Symbol(),PERIOD_CURRENT,Lots,Threashold,Interval,PrimaryStoploss);

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