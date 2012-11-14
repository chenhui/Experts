//+------------------------------------------------------------------+
//|                                                   PlugSignal.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include "..\..\Include\Indicator\ChPrice.mqh"
#include "..\..\Include\Symmetry\Symmetry.mqh"


class PlusSignalBase:public ISignal
{
   protected:
      ChIndicator       *open;
      ChIndicator       *close;
      ChSymbolInfo      *symbolInfo;
      int   threashold;
      int   plus(int index);
   public:
      void PlusSignalBase(){};
      void ~PlusSignalBase();
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters);
      virtual bool OpenBuyCondition(){return false;};
      bool CloseBuyCondition();
      virtual bool OpenSellCondition(){return false;};
      bool CloseSellCondition();
      
};


void PlusSignalBase::~PlusSignalBase(void)
{
   if (open!=NULL) delete open;
   if (close!=NULL) delete close;
   if (symbolInfo!=NULL) delete symbolInfo;
}

bool PlusSignalBase::Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters)
{
   this.threashold=parameters.intOne;
   open=new ChOpen;
   close=new ChClose;
   symbolInfo=new ChSymbolInfo;
   return (   symbolInfo.Init(symbol)
          &&  open.Create(symbol,timeFrame)
          &&  close.Create(symbol,timeFrame));
}


bool PlusSignalBase::CloseBuyCondition()
{
   return (OpenSellCondition());
}

bool PlusSignalBase::CloseSellCondition()
{
   return (OpenBuyCondition());
}

int PlusSignalBase::plus(int index)
{
   return (close.Main(index)-open.Main(index))/symbolInfo.PointValue();
}

//--------------------------------------------------------------------------------+
class PlusSignal:public PlusSignalBase
{

   public:
      void PlusSignal(){};
      void ~PlusSignal(){};
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters);
      virtual bool OpenBuyCondition();
      virtual bool OpenSellCondition();
      
};


bool PlusSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters)
{
   return PlusSignalBase::Init(symbol,timeFrame,parameters);
}


bool PlusSignal::OpenBuyCondition()
{
   return (plus(1)>=threashold);
}

bool PlusSignal::OpenSellCondition()
{
   return (plus(1)<=-threashold);
}




//--------------------------------------------------------------------------------+

class PlusIntervalSignal:public PlusSignalBase
{
   protected:          
      int   interval;
      bool  BuySignalInCurrent();
      bool  SellSignalInCurrent();
      bool  SellSignalInInterval();
      bool  BuySignalInInterval();
   public:
      void PlusIntervalSignal(){};
      void ~PlusIntervalSignal(){};
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters);
      virtual bool OpenBuyCondition();
      virtual bool OpenSellCondition();
      
};


bool PlusIntervalSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters)
{
   this.interval=parameters.intTwo;
   return PlusSignalBase::Init(symbol,timeFrame,parameters);
}


bool PlusIntervalSignal::OpenBuyCondition()
{
   return ( BuySignalInCurrent() && !SellSignalInInterval());
}

bool PlusIntervalSignal::BuySignalInCurrent(void)
{
   return (plus(1)>=threashold);
}

bool PlusIntervalSignal::BuySignalInInterval(void)
{
   for(int index=2;index<=this.interval;index++)
   {
      if (plus(index)>=threashold) return (true);
   }
   return false; 
}

bool PlusIntervalSignal::OpenSellCondition()
{
   return (SellSignalInCurrent() && !BuySignalInInterval());
}

bool PlusIntervalSignal::SellSignalInCurrent(void)
{
   return (plus(1)<=-threashold);
}

bool PlusIntervalSignal::SellSignalInInterval()
{
   for(int index=2;index<=this.interval;index++)
   {
      if (plus(index)<=-threashold) return (true);
   }
   return false;
}

