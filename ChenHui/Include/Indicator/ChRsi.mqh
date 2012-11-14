//+------------------------------------------------------------------+
//|                                                  ChGthSignal.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Indicators\Oscilators.mqh>
#include ".\ChIndicator.mqh";


class ChRsi: public ChIndicator
{ 
   
   private: 
      int                  rsiPeriod;
      CiRSI                *rsi;
      
   public:
      void                 ChRsi();
      void                 ~ChRsi();
      virtual  double      Main(int index=0);
      
   protected:
      virtual  bool        IsNew();
      virtual  bool        IsInitParameter();
              
};

void ChRsi::ChRsi()
{
   rsiPeriod=14;
}

void ChRsi::~ChRsi()
{
    if (rsi!=NULL)
   {
      delete rsi;
      rsi = NULL;
   }
}

  
bool ChRsi::IsNew()
{
   if((rsi =new CiRSI)==NULL)
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChRsi::IsInitParameter()
{
   if(!rsi.Create(symbol,timeFrame,rsiPeriod,PRICE_CLOSE))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChRsi::Main(int index=0)
{ 
   rsi.BufferResize(CalculateSize(index));
   rsi.Refresh(-1);
   return (rsi.Main(index));

}
