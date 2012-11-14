//+------------------------------------------------------------------+
//|                                           StoplossCalculate.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Trade/orderInfo.mqh>
#include <Trade/Trade.mqh>
#include "../Symbol/ChSymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class StoplossCalculate
{
protected:
   ENUM_TIMEFRAMES timeFrame;
   int   stoplossGap;
   bool  InitStoplossGapAndTimeframe(ENUM_TIMEFRAMES timeFrameOut,int stoplossGapOut);
public:
   void              StoplossCalculate(){};
   void             ~StoplossCalculate(){};
   double virtual Main(){return 0;};
   bool   virtual Init(int indexOut,ENUM_TIMEFRAMES timeFrameOut,int stoplossGapOut){return(false);};
};

//+------------------------------------------------------------------+

bool StoplossCalculate::InitStoplossGapAndTimeframe(ENUM_TIMEFRAMES timeFrameOut,int stoplossGapOut)
{
   this.stoplossGap=stoplossGapOut;
   this.timeFrame=timeFrameOut;
   return (true);
}


class PositionStoplossCalculate:public StoplossCalculate
  {
protected:
   ChSymbolInfo     *symbolInfo;
   CPositionInfo    *positionInfo;

public:
   void              PositionStoplossCalculate();
   void             ~PositionStoplossCalculate();
   double virtual    Main(){return 0;};
   bool virtual      Init(int indexOut,ENUM_TIMEFRAMES timeFrameOut,int stoplossGapOut);
  }
;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PositionStoplossCalculate::PositionStoplossCalculate(void)
  {
   symbolInfo=new ChSymbolInfo;
   positionInfo=new CPositionInfo;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PositionStoplossCalculate::~PositionStoplossCalculate(void)
  {
   delete symbolInfo;
   delete positionInfo;
   symbolInfo=NULL;
   positionInfo=NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  PositionStoplossCalculate::Init(int indexOut,ENUM_TIMEFRAMES timeFrameOut,int stoplossGapOut)
{
   if (!InitStoplossGapAndTimeframe(timeFrameOut,stoplossGapOut))   return false;
   if(!positionInfo.SelectByIndex(indexOut)) return false;
   return(symbolInfo.Init(positionInfo.Symbol()));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
class PositionLongPrimaryStoplossCalculate:public PositionStoplossCalculate
{
public:
   void              PositionLongPrimaryStoplossCalculate(){};
   void             ~PositionLongPrimaryStoplossCalculate(){};
   double virtual    Main();

};

//+------------------------------------------------------------------+
double PositionLongPrimaryStoplossCalculate::Main()
  {
   return(positionInfo.PriceOpen()-stoplossGap*symbolInfo.PointValue()-symbolInfo.SpreadValue());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PositionShortPrimaryStoplossCalculate:public PositionStoplossCalculate
  {
public:
   void              PositionShortPrimaryStoplossCalculate(){};
   void             ~PositionShortPrimaryStoplossCalculate(){};
   double virtual    Main();
  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double PositionShortPrimaryStoplossCalculate::Main()
  {
   return(positionInfo.PriceOpen()+stoplossGap*symbolInfo.PointValue()+symbolInfo.SpreadValue());
  }
//-----------------------------------------------------------------------------------------

class PendingStoplossCalculate:public StoplossCalculate
  {
protected:
   ChSymbolInfo     *symbolInfo;
   COrderInfo       *orderInfo;

public:
   void              PendingStoplossCalculate();
   void             ~PendingStoplossCalculate();
   double virtual    Main(){return 0;};
   bool virtual      Init(int indexOut,ENUM_TIMEFRAMES timeFrameOut,int stoplossGapOut);
  }
;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PendingStoplossCalculate::PendingStoplossCalculate(void)
  {
   symbolInfo=new ChSymbolInfo;
   orderInfo=new COrderInfo;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PendingStoplossCalculate::~PendingStoplossCalculate(void)
  {
   delete symbolInfo;
   delete orderInfo;
   symbolInfo=NULL;
   orderInfo=NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  PendingStoplossCalculate::Init(int indexOut,ENUM_TIMEFRAMES timeFrameOut,int stoplossGapOut)
{
   if(!InitStoplossGapAndTimeframe(timeFrameOut,stoplossGapOut))   return false;
   if(!orderInfo.SelectByIndex(indexOut)) return false;
   return(symbolInfo.Init(orderInfo.Symbol()));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PendingLongPrimaryStoplossCalculate:public PendingStoplossCalculate
  {
public:
   void              PendingLongPrimaryStoplossCalculate(){};
   void             ~PendingLongPrimaryStoplossCalculate(){};
   double virtual    Main();

  };
//+------------------------------------------------------------------+
                                                                
//+------------------------------------------------------------------+
double PendingLongPrimaryStoplossCalculate::Main()
  {
   return(orderInfo.PriceOpen()-stoplossGap*symbolInfo.PointValue()-symbolInfo.SpreadValue());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PendingShortPrimaryStoplossCalculate:public PendingStoplossCalculate
  {
public:
   void              PendingShortPrimaryStoplossCalculate(){};
   void             ~PendingShortPrimaryStoplossCalculate(){};
   double virtual    Main();
  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double PendingShortPrimaryStoplossCalculate::Main()
  {
   return(orderInfo.PriceOpen()+stoplossGap*symbolInfo.PointValue()+symbolInfo.SpreadValue());
  }
//+------------------------------------------------------------------+
