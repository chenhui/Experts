//+------------------------------------------------------------------+
//|                               ExpertPlusWithFixedMarginLevel.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                   TestChPlus.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\Include\Symmetry\ExpertPluss.mqh"
#include "..\..\Include\Stoploss\PrimaryStoplossCalculate.mqh"
#include "..\..\Include\Money\ChMoney.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ulong MagicNumber=000001;
input int EventTime=100;
input int Threashold=34;
input int PrimaryStoploss=37;
input int FixMarginLevel=10;

ExpertPlus     *expert;
ChMoney        *money;

string symbol;
ENUM_TIMEFRAMES timeFrame;

int OnInit()
{
   symbol=Symbol();
   timeFrame=PERIOD_CURRENT;
   
   EventSetTimer(EventTime);
   money=new ChMoney;
   money.Init(symbol);
   
   return(0);
}

void OnTimer()
{
   expert=new ExpertPlus;
   expert.Init(MagicNumber,symbol,timeFrame,money.GetLotsWith(FixMarginLevel),Threashold,PrimaryStoploss);
   expert.Main();
   if (expert!=NULL) delete expert;
}


void OnDeinit(const int reason)
{
   EventKillTimer();
   if (money!=NULL) delete money;      
}

void OnTick()
{

}
