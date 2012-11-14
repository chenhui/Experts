//+------------------------------------------------------------------+
//|                                    GthPrimaryStoplossBuilder.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "../Stoploss/IPrimaryStoplossBuilder.mqh"
#include "./FibonaqPrimaryStoploss.mqh"
#include "../Fibonaq/FibonaqTradeEvent.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class FibonaqPositionLongPrimaryStoplossBuilder:public IPrimaryStoplossBuilder
{

   public:
      void FibonaqPositionLongPrimaryStoplossBuilder(){};
      void ~FibonaqPositionLongPrimaryStoplossBuilder(){};
      virtual IPrimaryStoploss *Create();
      
};

IPrimaryStoploss*  FibonaqPositionLongPrimaryStoplossBuilder::Create(void)
{
   IPrimaryStoploss *stoploss=new FibonaqPositionPrimaryStoploss;
   stoploss.Init(new PositionStoplosser,new PositionLongPrimaryStoplossCalculate,
                 new PositionLongTypeValidater,new FibonaqPositionLongPrimaryStoplossAlert);
   return stoploss;
}


//-----------------------------------------------------------------------

class FibonaqPositionShortPrimaryStoplossBuilder:public IPrimaryStoplossBuilder
{
   public:
      void FibonaqPositionShortPrimaryStoplossBuilder(){};
      void ~FibonaqPositionShortPrimaryStoplossBuilder(){};
      virtual IPrimaryStoploss *Create();
      
};

IPrimaryStoploss*  FibonaqPositionShortPrimaryStoplossBuilder::Create(void)
{
   IPrimaryStoploss *stoploss=new FibonaqPositionPrimaryStoploss;
   stoploss.Init(new PositionStoplosser,new PositionShortPrimaryStoplossCalculate,
                 new PositionShortTypeValidater,new FibonaqPositionShortPrimaryStoplossAlert);
   return stoploss;
}
