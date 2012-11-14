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
 
class ChMacd : public ChIndicator
{  
   
   private:
      int               slowEma;
      int               fastEma;
      int               signalSma;
      CiMACD            *macd;
      
   private:        
      virtual   bool    IsNew();
      virtual   bool    IsInitParameter();   
     
   public:
      void              ChMacd();
      virtual  void     ~ChMacd();
      bool              InitBeforeCreate(int fastEmaOut,int slowEmaOut);
      virtual  double   Main(int index);
      

              
};

void ChMacd::ChMacd()
{
   fastEma=12;
   slowEma=26;
   signalSma=9;
   
}

void ChMacd::~ChMacd()
{
   if (macd!=NULL)
   {
      delete macd;
      macd = NULL;
   }
  
}

bool ChMacd::InitBeforeCreate(int fastEmaOut,int slowEmaOut)
{
   this.fastEma=fastEmaOut;
   this.slowEma=slowEmaOut;
   return (true);
}

  
bool ChMacd::IsNew()
{
   if((macd =new CiMACD)==NULL)
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChMacd::IsInitParameter()
{
   if(!macd.Create(symbol,timeFrame,fastEma,slowEma,signalSma,PRICE_CLOSE))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChMacd::Main(int index)
{   
   macd.BufferResize(CalculateSize(index));
   macd.Refresh(-1);
   return (macd.Main(index)*1000);
}

  
//// -------------------  Test case  --------------------------------------//
//
//ChMacd *macd; // class instance
//AllSymbols allSymbols;
////------------------------------------------------------------------ OnInit
//int OnInit()
//{
//   TestAllSymbolsMacd();
//   return 0;
//}
//
////------------------------------------------------------------------ OnTick
//void OnTick()
//{
//   TestAllSymbolsMacd();
//}
//
//void TestAllSymbolsMacd()
//{
//   Alert("tick start is ",TimeCurrent());
//   for(int i=0; i<allSymbols.Total();i++)
//   {
//      macd=new ChMacd;
//      macd.Create(allSymbols.At(i),PERIOD_M5);
//      Alert(i," macd of ",allSymbols.At(i)," = ",macd.Main(0)); 
//      delete macd;
//   }
//   Alert("tick end is ",TimeCurrent());
//}
//
//
//
