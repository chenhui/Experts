//+------------------------------------------------------------------+
//|                                                      ISignal.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct Parameters
{
   int intOne;
   int intTwo;
   int intThree;
   int intFour;
   double doubleOne;
   double doubleTwo;
   double doubleThree;
   Parameters(){intOne=0;intTwo=0;intThree=0;doubleOne=0.0;doubleTwo=0.0;doubleThree=0.0;};
   
};

class ISignal
{
   public:
      void ISignal(){};
      void ~ISignal(){};
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters){return (false);};
      virtual void Input(ISignal *signal){};
      virtual bool OpenBuyCondition(){return (false);};
      virtual bool CloseBuyCondition(){return (false);};
      virtual bool OpenSellCondition(){return (false);};
      virtual bool CloseSellCondition(){return (false);};
      
};