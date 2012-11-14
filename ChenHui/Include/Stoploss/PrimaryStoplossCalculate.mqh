//+------------------------------------------------------------------+
//|                                               FixPrimaryStoplosser.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\Symbol\ChSymbolInfo.mqh"
#include "..\..\Include\Indicator\ChATR.mqh"
#include "..\..\Include\Signals\TqaSignal.mqh"

//-----------------------------------------------------------------------+

class IStoplosser
{     
   public:
      void IStoplosser(){};
      void ~IStoplosser(){};
      virtual bool  Init(string symbol,ENUM_TIMEFRAMES timeFrame,int nStoploss){return (false);};
      virtual double BuyStoploss(){return (0.0);};
      virtual double SellStoploss(){return (0.0);};
}
;



class FixPrimaryStoplosser:public IStoplosser
{
   private:
   
      string symbol;
      ENUM_TIMEFRAMES timeFrame;
      int    nStoploss;
      ChSymbolInfo *symbolInfo;
      
   public:
      void FixPrimaryStoplosser(){};
      void ~FixPrimaryStoplosser();
      virtual bool  Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int nStoplossOut);
      virtual double BuyStoploss();
      virtual double SellStoploss();
}
;

bool FixPrimaryStoplosser::Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int nStoplossOut)
{
   this.symbol=symbolOut;
   this.timeFrame=timeFrameOut;
   this.nStoploss=nStoplossOut;
   symbolInfo=new ChSymbolInfo;
   return (symbolInfo.Init(symbol) );
}

void FixPrimaryStoplosser::~FixPrimaryStoplosser(void)
{
   if (symbolInfo!=NULL) delete symbolInfo;
}

double FixPrimaryStoplosser::BuyStoploss()
{
   if (nStoploss==0)  return 0;
   return (symbolInfo.Ask()-nStoploss*symbolInfo.PointValue()-symbolInfo.SpreadValue());
}

double FixPrimaryStoplosser::SellStoploss()
{
   if (nStoploss==0)  return 0;
   return (symbolInfo.Bid()+nStoploss*symbolInfo.PointValue()+symbolInfo.SpreadValue());
}


////----------------------------------------------------------------------------
////-----------------------------------------------------------------------+
class TqaStoplosser:public IStoplosser
{
   private:
   
      string symbol;
      ENUM_TIMEFRAMES timeFrame;
      int    nStoploss;
      ChIndicator *atr;
      ChSymbolInfo *symbolInfo;
      
   public:
      void TqaStoplosser(){};
      void ~TqaStoplosser();
      virtual bool  Init(string symbol,ENUM_TIMEFRAMES timeFrame,int nStoploss);
      virtual double BuyStoploss();
      virtual double SellStoploss();
}
;

bool TqaStoplosser::Init(string symbol,ENUM_TIMEFRAMES timeFrame,int nStoploss)
{
   this.symbol=symbol;
   this.timeFrame=timeFrame;
   this.nStoploss=nStoploss;
   atr=new ChATR;
   symbolInfo=new ChSymbolInfo;
   return (symbolInfo.Init(symbol) && atr.Create(symbol,timeFrame));
}

void TqaStoplosser::~TqaStoplosser(void)
{
   if (atr!=NULL) delete atr;
   if (symbolInfo!=NULL) delete symbolInfo;
}

double TqaStoplosser::BuyStoploss()
{
   Alert("ask= ",symbolInfo.Ask()," diff = ",nStoploss*atr.Main(1));
   return (symbolInfo.Ask()-nStoploss*atr.Main(1));
}

double TqaStoplosser::SellStoploss()
{
   Alert("bid= ",symbolInfo.Bid()," diff = ",nStoploss*atr.Main(1));
   return (symbolInfo.Bid()+nStoploss*atr.Main(1));
}

//-----------------------------------------------------------------------+
