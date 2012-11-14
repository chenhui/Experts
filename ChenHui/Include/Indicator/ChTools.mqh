//+------------------------------------------------------------------+
//|                                                      ChTools.mqh |
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

class Ultra
{
   private:   
      ChIndicator       *low;
      ChIndicator       *high;
   public:
      void Ultra(){};
      void ~Ultra();
      bool Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      double Max(int range,int from);
      double Min(int range,int from);
};

bool Ultra::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{ 
   low=new ChLow;
   high = new ChHigh;
   return low.Create(symbol,timeFrame) && high.Create(symbol,timeFrame);
}

void Ultra::~Ultra(void)
{
   if (low!=NULL)  delete low;
   if (high!=NULL) delete high;
}


double Ultra::Min(int range,int from)
{  
   double min=INT_MAX;
   for(int i=from;i<=range;i++)
   {
      if (low.Main(i)<min)  min=low.Main(i);
   }
   return min;
}

double Ultra::Max(int range,int from)
{
   double max=INT_MIN;
   for(int i=from;i<=range;i++)
   {
      if (high.Main(i)>max)  max=high.Main(i);
   }
   return max;
}
