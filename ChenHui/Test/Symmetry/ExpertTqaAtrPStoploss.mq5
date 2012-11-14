//+------------------------------------------------------------------+
//|                                                   TestChPlus.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "..\..\Include\Indicator\ChATR.mqh"
#include "..\..\Include\Signals\TqaSignal.mqh"
#include "..\..\Include\Stoploss\PrimaryStoplossCalculate.mqh"
#include "..\..\Include\Symmetry\Symmetry.mqh"


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ulong MagicNumber=000004;
input int EventTime=10;
input double Lots=0.01;
input int NStoploss=2;
input int OpenRange=20;
input int CloseRange=10;
input int FastPeriod=25;
input int SlowPeriod=350;


////-----------------------------------------------------------------------+
//class TqaStoplosser:public IStoplosser
//{
//   private:
//   
//      string symbol;
//      ENUM_TIMEFRAMES timeFrame;
//      int    nStoploss;
//      ChIndicator *atr;
//      ChSymbolInfo *symbolInfo;
//      
//   public:
//      void TqaStoplosser(){};
//      void ~TqaStoplosser();
//      virtual bool  Init(string symbol,ENUM_TIMEFRAMES timeFrame,int nStoploss);
//      virtual double BuyStoploss();
//      virtual double SellStoploss();
//}
//;
//
//bool TqaStoplosser::Init(string symbol,ENUM_TIMEFRAMES timeFrame,int nStoploss)
//{
//   this.symbol=symbol;
//   this.timeFrame=timeFrame;
//   this.nStoploss=nStoploss;
//   atr=new ChATR;
//   symbolInfo=new ChSymbolInfo;
//   return (symbolInfo.Init(symbol) && atr.Create(symbol,timeFrame));
//}
//
//void TqaStoplosser::~TqaStoplosser(void)
//{
//   if (atr!=NULL) delete atr;
//   if (symbolInfo!=NULL) delete symbolInfo;
//}
//
//double TqaStoplosser::BuyStoploss()
//{
//   Alert("ask= ",symbolInfo.Ask()," diff = ",nStoploss*atr.Main(1));
//   return (symbolInfo.Ask()-nStoploss*atr.Main(1));
//}
//
//double TqaStoplosser::SellStoploss()
//{
//   Alert("bid= ",symbolInfo.Bid()," diff = ",nStoploss*atr.Main(1));
//   return (symbolInfo.Bid()+nStoploss*atr.Main(1));
//}
//
////-----------------------------------------------------------------------+


string   symbol;
ENUM_TIMEFRAMES timeFrame;
Parameters parameters;

Symmetry *expert;
ISignal *signal;
TimeSectionChecker *timeChecker;
IStoplosser *stoplosser;


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
   //Section one={TODAY,11,TODAY,17};
   //timeChecker.InitOne(one);
   
   stoplosser=new TqaStoplosser;
   stoplosser.Init(symbol,timeFrame,NStoploss);
   
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
   if (stoplosser!=NULL) delete stoplosser;
      
}

void OnTick()
{
}
