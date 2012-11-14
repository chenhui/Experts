//+------------------------------------------------------------------+
//|                                                   TestChPlus.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Indicator\ChEma.mqh"
#include "..\..\Include\Indicator\ChPrice.mqh"
#include "..\..\Include\Indicator\ChTools.mqh"
#include "..\..\Include\Signals\ISignal.mqh"

class TqaSignal:public ISignal
{
   private:

      ChIndicator *close;
      ChEma       *fastEma;
      ChEma       *slowEma;
      Ultra       *ultra;
      int   openRange;
      int   closeRange;
      int   fastPeriod;
      int   slowPeriod;
      
   public:
      void TqaSignal(){};
      void ~TqaSignal();
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters);
      virtual bool OpenBuyCondition();
      virtual bool CloseBuyCondition();
      virtual bool OpenSellCondition();
      virtual bool CloseSellCondition();
      
};


void TqaSignal::~TqaSignal(void)
{
   if (close!=NULL)   delete close;
   if (fastEma!=NULL) delete fastEma;
   if (slowEma!=NULL) delete slowEma;
   if (ultra!=NULL)   delete ultra;
}

bool TqaSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters)
{

   this.openRange=parameters.intOne;
   this.closeRange=parameters.intTwo;
   this.fastPeriod=parameters.intThree;
   this.slowPeriod=parameters.intFour;
   close=new ChClose;
   fastEma=new ChEma;
   slowEma=new ChEma;
   ultra=new Ultra;
   return (   close.Create(symbol,timeFrame)       &&  ultra.Init(symbol,timeFrame)
          &&  fastEma.InitBeforeCreate(fastPeriod) &&  fastEma.Create(symbol,timeFrame)
          &&  slowEma.InitBeforeCreate(slowPeriod) &&  slowEma.Create(symbol,timeFrame)
          );
}


bool TqaSignal::OpenBuyCondition()
{
   return (   fastEma.Main(1)>slowEma.Main(1)
          &&  close.Main(1)>ultra.Max(openRange,2)
          &&  close.Main(2)<=ultra.Max(openRange,2)
          );
}

bool TqaSignal::OpenSellCondition()
{
   return (   fastEma.Main(1)<slowEma.Main(1)
          &&  close.Main(1)<ultra.Min(openRange,2)
          &&  close.Main(2)>=ultra.Min(openRange,2)
          );
}

bool TqaSignal::CloseBuyCondition()
{
   return (    close.Main(1)<ultra.Min(closeRange,2)
          &&   close.Main(2)>=ultra.Min(closeRange,2)
          );
}

bool TqaSignal::CloseSellCondition()
{
   return (    close.Main(1)>ultra.Max(closeRange,2)
          &&   close.Main(2)<=ultra.Max(closeRange,2)
          );
}

