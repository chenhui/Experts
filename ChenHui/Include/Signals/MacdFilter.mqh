//+------------------------------------------------------------------+
//|                                                   MacdFilter.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "../Indicator/ChMacd.mqh"
#include "./ISignal.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MacdFilter:public ISignal
{

   private:
   
      ChIndicator *macd;
      ISignal *signal;
      
   public:
   
      MacdFilter()
      {
         signal=NULL;
         macd=NULL;
      };
      
      ~MacdFilter()
      {
         if (signal!=NULL) delete signal;
         if (macd!=NULL) delete macd;
      };
      
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters)
      {
         macd=new ChMacd;
         return macd.Create(symbol,timeFrame);
      };
      
      virtual void Input(ISignal *signalOut){this.signal=signalOut;};
      
      virtual bool OpenBuyCondition()
      {
         return (IsSupportBuy() && signal.OpenBuyCondition());
      };
      
      virtual bool CloseBuyCondition()
      {
         return (IsSupportSell() && signal.CloseBuyCondition());
      };
      
      virtual bool OpenSellCondition()
      {
         return (IsSupportSell() && signal.OpenSellCondition());
      };
      
      virtual bool CloseSellCondition()
      {
         return (IsSupportBuy() && signal.CloseSellCondition());
      };
      
      
      bool IsSupportBuy()
      {
         return (macd.Main(1)>0);
      };
      
      bool IsSupportSell()
      {
         return (macd.Main(1)<0);
      }
};

//+------------------------------------------------------------------+
