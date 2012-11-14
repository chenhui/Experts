//+------------------------------------------------------------------+
//|                                                   TestChPlus.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Indicator\ChMacd.mqh"
#include "..\..\Include\Trade\ChSymmetryTrade.mqh"
#include "..\..\Include\Symmetry\Symmetry.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ulong MagicNumber=000002;
input int EventTime=3600;
input double Lots=0.01;
input double Threashold=0;
input int   PrimaryStoploss=0;
input int   FastEma=12;
input int   SlowEma=26;
//-------------------------------------------------------------------+

class MacdSignal:public ISignal
{
   private:
      ChMacd       *macd;
      int   threashold;
      double   Macd(int index);
   public:
      void MacdSignal(){};
      void ~MacdSignal();
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters);
      virtual bool OpenBuyCondition();
      virtual bool CloseBuyCondition();
      virtual bool OpenSellCondition();
      virtual bool CloseSellCondition();
      
};


void MacdSignal::~MacdSignal(void)
{
   if (macd!=NULL) delete macd;

}

bool MacdSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters)
{
   this.threashold=parameters.intOne;
   macd=new ChMacd;
   macd.InitBeforeCreate(parameters.intTwo,parameters.intThree);
   return (  macd.Create(symbol,timeFrame));
}


bool MacdSignal::OpenBuyCondition()
{
   return (Macd(2)<threashold) && (Macd(1)>threashold);
}

bool MacdSignal::CloseBuyCondition()
{
   return (Macd(1)<Macd(2));
}

bool MacdSignal::OpenSellCondition()
{
   return (Macd(2)>threashold) && (Macd(1)<threashold);
}

bool MacdSignal::CloseSellCondition()
{
   return (Macd(1)>Macd(2));
}

double MacdSignal::Macd(int index)
{ 
   return (macd.Main(index));
}

//---------------------------------------------------------------------+

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
   parameters.intOne=Threashold; 
   parameters.intTwo=FastEma;
   parameters.intThree=SlowEma;
   
   signal=new MacdSignal; 
   signal.Init(symbol,timeFrame,parameters);  
        
   timeChecker=new TimeSectionChecker;
   timeChecker.InitOne(AllSection);
     
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
   if (stoplosser!=NULL)  delete stoplosser;
      
}

void OnTick()
{
}
