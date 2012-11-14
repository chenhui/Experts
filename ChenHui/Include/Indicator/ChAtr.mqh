//+------------------------------------------------------------------+
//|                                                  ChGthSignal.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Indicators\Oscilators.mqh>
#include ".\ChIndicator.mqh"
#include "..\Symbol\AllSymbol.mqh"
 
class ChATR : public ChIndicator
{  
   
   private:
      int              maPeriod;
      CiATR            *atr;
      
   private:        
      virtual   bool    IsNew();
      virtual   bool    IsInitParameter();   
     
   public:
      void              ChATR();
      virtual  void     ~ChATR();
      virtual  double   Main(int index);
      

              
};

void ChATR::ChATR()
{
   maPeriod=20;
   atr=new CiATR;
   
}

void ChATR::~ChATR()
{
   if (atr!=NULL)
   {
      delete atr;
      atr = NULL;
   }
  
}

  
bool ChATR::IsNew()
{
   if(atr==NULL)
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChATR::IsInitParameter()
{
   if(!atr.Create(symbol,timeFrame,maPeriod))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChATR::Main(int index)
{   
   atr.BufferResize(CalculateSize(index));
   atr.Refresh(-1);
   return (atr.Main(index));
}

