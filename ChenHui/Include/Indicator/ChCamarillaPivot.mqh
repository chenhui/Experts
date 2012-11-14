//+------------------------------------------------------------------+
//|                                                      ChPivot.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include ".\ChIndicator.mqh"
#include ".\ChPrice.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class ChCamarillaPivot
{

   private:
   
      string symbol;
      ENUM_TIMEFRAMES timeFrame;
      ChIndicator *close;
      ChIndicator *high;
      ChIndicator *low;
      
      double PreClose()
      {
         return close.Main(1);
      }
      
      double PreHigh()
      {
         return high.Main(1);
      }
      
      double PreLow()
      {
         return low.Main(1);
      }
      
      double PreAmplitude()
      {
         return (PreHigh()-PreLow())*1.1;
      }
      
   public:
   
      ChCamarillaPivot()
      {
         close=new ChClose;
         high=new ChHigh;
         low=new ChLow;
      }
      
      ~ChCamarillaPivot()
      {
         if (close!=NULL) delete close;
         if (high!=NULL) delete high;
         if (low!=NULL) delete low;
      }
      
      bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut)
      {
         this.symbol=symbolOut;
         this.timeFrame=timeFrameOut;
         return ( close.Create(symbol,timeFrame)
                && low.Create(symbol,timeFrame)
                && high.Create(symbol,timeFrame));
         
      }
      
      
      double Pivot()
      {
         return (PreClose()+PreHigh()+PreLow())/3;
      }
      
      double H1()
      {
         return (PreClose()+PreAmplitude()/12);
      }
      
      double H2()
      {
         return (PreClose()+PreAmplitude()/6);
      }
      
      double H3()
      {
         return (PreClose()+PreAmplitude()/4);
      }
      
      double H4()
      {
         return (PreClose()+PreAmplitude()/2);
      }
      
      double H5()
      {
         return (PreClose()*PreHigh()/PreLow());
      }
      
      double L1()
      {
         return (PreClose()-PreAmplitude()/12);
      }
      
      double L2()
      {
         return (PreClose()-PreAmplitude()/6);
      }
      
      double L3()
      {
         return (PreClose()-PreAmplitude()/4);
      }
      
      double L4()
      {
         return (PreClose()-PreAmplitude()/2);
      }
      
      double L5()
      {
         return (2*PreClose()-H5());
      }
      
};
