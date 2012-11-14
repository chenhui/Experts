//+------------------------------------------------------------------+
//|                                               BreakBollinger.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include  "..\..\Include\Indicator\ChBollinger.mqh"
#include  "..\..\Include\Indicator\ChPrice.mqh"

class BreakBollinger
{
   private:
      string            symbol;
      ENUM_TIMEFRAMES   timeFrame;
      ChBollinger       *bollinger;
      ChClose           *close;
   public:
      void              BreakBollinger();
      void              ~BreakBollinger();
      bool              Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool              IsCloseUpperAt(int index=0);
      bool              IsCloseLowerAt(int index=0);
      
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BreakBollinger::BreakBollinger()
{
   bollinger=new ChBollinger;
   close=new ChClose;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BreakBollinger::~BreakBollinger()
{
   if (bollinger!=NULL) {delete bollinger; bollinger=NULL;}
   if (close!=NULL)     {delete close;     close=NULL;}
}

bool BreakBollinger::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   bollinger.Create(symbol,timeFrame);   
   close.Create(symbol,timeFrame);
   return (true);
}

bool BreakBollinger::IsCloseLowerAt(int index=0)
{
   return (close.Main(index)<bollinger.Lower(index))  ;
}

bool BreakBollinger::IsCloseUpperAt(int index=0)
{
   return (close.Main(index)>bollinger.Upper(index));
}
//+------------------------------------------------------------------+
