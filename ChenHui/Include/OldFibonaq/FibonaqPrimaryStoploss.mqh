//+------------------------------------------------------------------+
//|                                                  GthStoploss.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "../Stoploss/Stoplosser.mqh"
#include "../Stoploss/StoplossCalculate.mqh"
#include "../Stoploss/IPrimaryStoploss.mqh"
#include "../Stoploss/ITypeValidater.mqh"
#include "../Stoploss/ICommentValidater.mqh"
#include "../Fibonaq/FibonaqTradeEvent.mqh"

class FibonaqPositionPrimaryStoploss:public PrimaryStoploss
{
   protected:
      CPositionInfo *positionInfo;
      bool  virtual IsSelectValid(int index);  
      int   virtual Count();   
      bool  virtual InitAlert(int index);
   public:
      void FibonaqPositionPrimaryStoploss();
      void ~FibonaqPositionPrimaryStoploss();
};

void FibonaqPositionPrimaryStoploss::FibonaqPositionPrimaryStoploss(void)
{
   positionInfo=new CPositionInfo;
}

void FibonaqPositionPrimaryStoploss::~FibonaqPositionPrimaryStoploss(void)
{
   if (positionInfo!=NULL)  delete positionInfo;
   positionInfo=NULL;
}

int FibonaqPositionPrimaryStoploss::Count()
{
   return (PositionsTotal());
}

bool FibonaqPositionPrimaryStoploss::IsSelectValid(int index)
{
   return (positionInfo.SelectByIndex(index) && (positionInfo.StopLoss()<minZero) );
}

bool FibonaqPositionPrimaryStoploss::InitAlert(int index)
{
   if (!positionInfo.SelectByIndex(index))  return (false);
   return (alert.Init(positionInfo.Symbol()));
}

//------------------------------------------------------------------------
