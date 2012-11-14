//+------------------------------------------------------------------+
//|                                                ExpertPlus.mq5 |
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
#include "..\..\Include\Symmetry\ExpertGth.mqh"
#include "..\..\Include\BEPoint\BePoint.mqh"
#include "..\..\Include\Stoploss\Trail.mqh"
#include "..\..\Include\Money\ChMoney.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ulong MagicNumber=000001;
input int EventTime=100;
input int PrimaryStoploss=30;
input int EmaStoploss=30;
input int FixMarginLevel=10;


ExpertGth     *expert;
ChMoney        *money;

BePoint    *buyBePoint;
BePoint    *sellBePoint;

ITrail     *buyTrail;
ITrail     *sellTrail;
string      symbol;
ENUM_TIMEFRAMES timeFrame;

int OnInit()
{
   symbol=Symbol();
   timeFrame=PERIOD_CURRENT;
   EventSetTimer(EventTime);
   
   money=new ChMoney;
   money.Init(symbol);
   
   buyBePoint=new BuyBePoint();
   buyBePoint.Init(MagicNumber,symbol);
   
   sellBePoint=new SellBePoint();
   sellBePoint.Init(MagicNumber,symbol);
   
   buyTrail=new BuyEmaTrail();
   buyTrail.Init(MagicNumber,symbol,timeFrame,EmaStoploss);
   
   sellTrail=new SellEmaTrail();
   sellTrail.Init(MagicNumber,symbol,timeFrame,EmaStoploss);
   return(0);
}

void OnTimer()
{
   expert=new ExpertGth;
   expert.Init(MagicNumber,symbol,PERIOD_CURRENT,money.GetLotsWith(FixMarginLevel),PrimaryStoploss);
   expert.Main();
   if (expert!=NULL) delete expert;
   
   buyBePoint.Main();
   sellBePoint.Main();
   
   buyTrail.Main();
   sellTrail.Main();
}


void OnDeinit(const int reason)
{
   EventKillTimer();
   if (money!=NULL)  delete money;
   if (expert!=NULL) delete expert;
   if (buyBePoint!=NULL) delete buyBePoint;
   if (sellBePoint!=NULL) delete sellBePoint;
   if (buyTrail!=NULL)  delete buyTrail;
   if (sellTrail!=NULL) delete sellTrail;
}

void OnTick()
{

}
