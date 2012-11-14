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

class ChEma : public ChIndicator
{ 
   
   private: 
      int                  maPeriod;
      CiMA                 *ma;
      
   public:
      void                 ChEma();
      void                 ~ChEma();
      bool                 InitBeforeCreate(int maPeriod);
      virtual  double      Main(int index=0);
      
   protected:
      virtual  bool        IsNew();
      virtual  bool        IsInitParameter();
              
};

void ChEma::ChEma()
{
   maPeriod=20;
}

void ChEma::~ChEma()
{
    if (ma!=NULL)
   {
      delete ma;
      ma = NULL;
   }
}

bool ChEma::InitBeforeCreate(int maPeriodOut)
{
   this.maPeriod=maPeriodOut;
   return (true);
}
  
bool ChEma::IsNew()
{
   if((ma==NULL) && ((ma =new CiMA)==NULL))
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChEma::IsInitParameter()
{
   if(!ma.Create(symbol,timeFrame,maPeriod,0,MODE_EMA,PRICE_CLOSE))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChEma::Main(int index=0)
{ 
   ma.BufferResize(CalculateSize(index));
   ma.Refresh(-1);
   return (ma.Main(index));

}

//// -------------------  Test case  --------------------------------------//
//
//
//ChEma *ema; // class instance
//AllSymbols allSymbols;
////------------------------------------------------------------------ OnInit
//int OnInit()
//{
//   //ema.Create("EURUSD"); // initialize expert
//   Alert("test -------------");
//   TestAllSymbolsEma();
//   return(0);
//}
//
////------------------------------------------------------------------ OnTick
//void OnTick()
//{
//  //TestEmaOfAllSymbols();
//}
//
//void TestAllSymbolsEma()
//{
//   Alert("tick is comming----------------",TimeCurrent());
//   for(int i=0;i<allSymbols.Total();i++)
//   {
//      ema=new ChEma;
//      ema.Create(allSymbols.At(i),PERIOD_M5,200);
//      Alert(i ," : Ema of ",allSymbols.At(i)," = ",ema.Main(0)); 
//      delete ema;    
//   }
//   
//}
//
//
//
