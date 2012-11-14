//+------------------------------------------------------------------+
//|                                                TestGthOpener.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "../../Include/Symbol/AllSymbol.mqh"
#include "../../Include/Support/Support.mqh"
#include "../../Include/Support/AllMacdSupport.mqh"
#include "../../include/Symbol/AllSymbol.mqh"
#include "../../include/Support/Voter.mqh"
#include "../../include/Indicator/ChPrice.mqh"
#include "../../include/Support/Recorder.mqh"


Recorder *recorder;

AllSymbols *allSymbols;

ISupport     *allSupport;
ISupport     *longSupport;
ISupport     *shortSupport;

Voter        *voter;


int OnInit()
{
   EventSetTimer(60);
   allSymbols=new AllSymbols;
   InitVoteSupport();  
   return(0);
}


void InitVoteSupport()
{
   voter=new Voter;
   allSupport=new Support;
   longSupport=new LongAllMacdSupport;
   shortSupport=new ShortAllMacdSupport;
   RecordAllSupport();
}

void OnTick()
{
}


void OnTimer()
{
   //Alert("-------------------- Time :  ",TimeCurrent(),"  -----------------------");
   RecordAllSupport();
}

void RecordAllSupport()
{
   for(int index=0;index<allSymbols.Total();index++)
   {
      Record(allSymbols.At(index));
   }
}

void Record(string symbol)
{
      recorder=new Recorder;
      recorder.Init(symbol);
      recorder.WriteWith(NumbersOf(voter,allSupport,symbol),
                         NumbersOf(voter,longSupport,symbol),
                         NumbersOf(voter,shortSupport,symbol));
      delete recorder;   
   
}


int NumbersOf(Voter *vote,ISupport *support,string symbol)
{
      support.Init(symbol,PERIOD_M5);
      vote.With(support);
      return vote.Numbers();
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   if (voter!=NULL) {delete voter;voter=NULL;}
   if (allSupport!=NULL){delete allSupport;allSupport=NULL;}
   if (longSupport!=NULL){delete longSupport;longSupport=NULL;}
   if (shortSupport!=NULL){delete shortSupport;shortSupport=NULL;}
}

