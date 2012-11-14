//+------------------------------------------------------------------+
//|                                                 BalanceTrail.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "../Stoploss/StoplossCalculate.mqh"
#include "../Indicator/ChIndicator.mqh"
#include "../Indicator/ChEma.mqh"

class BuyFixTrailStoplossCalculate:public PositionStoplossCalculate
  {
public:
   void              BuyFixTrailStoplossCalculate(){};
   void             ~BuyFixTrailStoplossCalculate(){};
   double virtual    Main();

  };

//+------------------------------------------------------------------+
double BuyFixTrailStoplossCalculate::Main()
  {
   return(positionInfo.PriceCurrent()-stoplossGap*symbolInfo.PointValue()-symbolInfo.SpreadValue());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SellFixTrailStoplossCalculate:public PositionStoplossCalculate
  {
public:
   void              SellFixTrailStoplossCalculate(){};
   void             ~SellFixTrailStoplossCalculate(){};
   double virtual    Main();
  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SellFixTrailStoplossCalculate::Main()
  {
   return(positionInfo.PriceCurrent()+stoplossGap*symbolInfo.PointValue()+symbolInfo.SpreadValue());
  }


class EmaTrailStoplossCalculate:public PositionStoplossCalculate
{
   protected:
      ChIndicator *ema;
      bool  InitEma();
      double virtual Calculate(){return (0);};
   public:
      void EmaTrailStoplossCalculate();
      void ~EmaTrailStoplossCalculate();
      double  Main();
      
};

void EmaTrailStoplossCalculate::EmaTrailStoplossCalculate(void)
{
   ema=new ChEma;
}

void EmaTrailStoplossCalculate::~EmaTrailStoplossCalculate(void)
{
   delete ema;
   ema=NULL;
}


double EmaTrailStoplossCalculate::Main(void)
{
   InitEma();
   return Calculate();
}

bool EmaTrailStoplossCalculate::InitEma()
{
   return (ema.Create(positionInfo.Symbol(),timeFrame));
}

//------------------------------------------------------------------------------

class BuyEmaTrailStoplossCalculate:public EmaTrailStoplossCalculate
{
   protected:
      double virtual Calculate();
   public:
      void BuyEmaTrailStoplossCalculate();
      void ~BuyEmaTrailStoplossCalculate();
   
};

void BuyEmaTrailStoplossCalculate::BuyEmaTrailStoplossCalculate(void){};
void BuyEmaTrailStoplossCalculate::~BuyEmaTrailStoplossCalculate(void){};

double BuyEmaTrailStoplossCalculate::Calculate(void)
{
   double emaTrailStoploss=ema.Main()-symbolInfo.SpreadValue()-stoplossGap*symbolInfo.PointValue();
   return MathRound(emaTrailStoploss/symbolInfo.PointValue())*symbolInfo.PointValue();
}

//---------------------------------------------------------------------------

class SellEmaTrailStoplossCalculate:public EmaTrailStoplossCalculate
{
   protected:
      double virtual Calculate();
   public:
      void SellEmaTrailStoplossCalculate();
      void ~SellEmaTrailStoplossCalculate();
};

void SellEmaTrailStoplossCalculate::SellEmaTrailStoplossCalculate(void){};
void SellEmaTrailStoplossCalculate::~SellEmaTrailStoplossCalculate(void){};

double SellEmaTrailStoplossCalculate::Calculate(void)
{
   double emaTrailStoploss=ema.Main()+symbolInfo.SpreadValue()+stoplossGap*symbolInfo.PointValue();
   return MathRound(emaTrailStoploss/symbolInfo.PointValue())*symbolInfo.PointValue();
                
}