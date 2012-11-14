//+------------------------------------------------------------------+
//|                                                  ChGthSignal.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Indicators\Trend.mqh>;
#include ".\ChIndicator.mqh";
#include "..\Symbol\AllSymbol.mqh";

class ChBollinger : public ChIndicator
{ 
   
   private: 
      int                  period;
      int                  shift;
      double               deviation;
      CiBands              *bollinger;
      
      void                 RefreshBuffer(int index=0);
      
   public:
      void                 ChBollinger();
      void                 ~ChBollinger();
      double  virtual      Main(int index=0);
      double               Middle(int index=0);
      double               Upper(int index=0);
      double               Lower(int index=0);
      
   private:
      virtual  bool        IsNew();
      virtual  bool        IsInitParameter();
              
};

void ChBollinger::ChBollinger()
{
   period=20;
   shift=0;
   deviation=2.0;
}

void ChBollinger::~ChBollinger()
{
   if (bollinger!=NULL)
   {
      delete bollinger;
      bollinger= NULL;
   }
}

  
bool ChBollinger::IsNew()
{
   if((bollinger=new CiBands)==NULL)
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChBollinger::IsInitParameter()
{
   if(!bollinger.Create(symbol,timeFrame,period,shift,deviation,PRICE_CLOSE))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChBollinger::Main(int index)
{
   return Middle(index);
}

double ChBollinger::Middle(int index)
{ 
   RefreshBuffer(index);
   return ((bollinger.Upper(index)+bollinger.Lower(index))/2);

}

double ChBollinger::Upper(int index)
{
   RefreshBuffer(index);
   return bollinger.Upper(index);
}


double ChBollinger::Lower(int index=0)
{
   RefreshBuffer(index);
   return bollinger.Lower(index);
}

void ChBollinger::RefreshBuffer(int index)
{
   bollinger.BufferResize(CalculateSize(index));
   bollinger.Refresh(-1);
}

