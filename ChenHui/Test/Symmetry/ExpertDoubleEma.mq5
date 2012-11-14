//+------------------------------------------------------------------+
//|                                                   TestChPlus.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Indicator\ChEma.mqh"
#include "..\..\Include\Symmetry\Symmetry.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ulong MagicNumber=000003;
input int EventTime=10;
input double Lots=0.01;
input int FastPeriod=100;
input int SlowPeriod=350;
input int PrimaryStoploss=0;


//-------------------------------------------------------------------+

class DoubleEmaSignal:public ISignal
{
   private:
      ChEma             *fastEma;
      ChEma             *slowEma;
   public:
      void DoubleEmaSignal(){};
      void ~DoubleEmaSignal();
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters);
      virtual bool OpenBuyCondition();
      virtual bool CloseBuyCondition();
      virtual bool OpenSellCondition();
      virtual bool CloseSellCondition();
         
};


void DoubleEmaSignal::~DoubleEmaSignal(void)
{
   if (fastEma!=NULL)  delete fastEma;
   if (slowEma!=NULL) delete slowEma; 


}

bool DoubleEmaSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters)
{
   fastEma=new ChEma;
   slowEma=new ChEma;
   return  (   fastEma.InitBeforeCreate(parameters.intOne) && fastEma.Create(symbol,timeFrame)
               && slowEma.InitBeforeCreate(parameters.intTwo) && slowEma.Create(symbol,timeFrame)
            );
}


bool DoubleEmaSignal::OpenBuyCondition()
{
   return (    fastEma.Main(1)>slowEma.Main(1) 
            && fastEma.Main(2)<slowEma.Main(2));
}

bool DoubleEmaSignal::OpenSellCondition()
{
   return (    fastEma.Main(1)<slowEma.Main(1) 
            && fastEma.Main(2)>slowEma.Main(2));
}

bool DoubleEmaSignal::CloseBuyCondition()
{
   return (OpenSellCondition());
}

bool DoubleEmaSignal::CloseSellCondition()
{
   return (OpenBuyCondition());
}

//------------------------------------Process programing----------------------------------------------//

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
   parameters.intOne=FastPeriod;
   parameters.intTwo=SlowPeriod; 
   
   signal=new DoubleEmaSignal;
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
   if (timeChecker!=NULL ) delete timeChecker;
   if (stoplosser!=NULL)   delete stoplosser;
      
}

void OnTick()
{
}

