//+------------------------------------------------------------------+
//|                                                MacdCrossZero.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "../indicator/ChPrice.mqh"
#include "../indicator/ChEma.mqh"
#include "../indicator/ChMacd.mqh"
#include "../indicator/ChIndicator.mqh"
#include "../Symbol/AllSymbol.mqh"

class MacdCrossZero
{
   protected:
    
      ChIndicator     *macd;                 
      
   public :
   
      void           MacdCrossZero();
      void           ~MacdCrossZero();
      bool           Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool           IsMacdCrossZeroBetween(int baseIndex,int startIndex,int endIndex);
      int            IndexOfMacdCrossZeroNear(int index);     
      virtual bool   IsMacdCrossZeroAt(int index){return false;};
      virtual bool   IsMacdCrossZeroStable(int index,int crossStableLength){return false;};
      
      
};

void MacdCrossZero::MacdCrossZero()
{  
}

bool MacdCrossZero::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{

   macd  =  new ChMacd; 
   return ( macd.Create(symbol,timeFrame) );
}



void MacdCrossZero::~MacdCrossZero()
{

   if(macd!=NULL)   delete macd;
   macd=NULL;
}

bool MacdCrossZero::IsMacdCrossZeroBetween(int baseIndex,int startIndex,int endIndex)
{
   int indexOfMacdCross=IndexOfMacdCrossZeroNear(baseIndex);
   return ((indexOfMacdCross>=startIndex) && (indexOfMacdCross<=endIndex));  

}

int MacdCrossZero::IndexOfMacdCrossZeroNear(int index)
{
   while (!IsMacdCrossZeroAt(++index))  ;
   return (index);
}


class MacdCrossDownZero :public MacdCrossZero
{
        
   public:
   
      void  MacdCrossDownZero();
      void  ~MacdCrossDownZero();
          
      bool IsMacdCrossZeroStable(int index,int crossStableLength);    
      bool IsMacdCrossZeroAt(int index);
         
};

void MacdCrossDownZero::MacdCrossDownZero()
{  
}

void MacdCrossDownZero::~MacdCrossDownZero()
{
}


bool MacdCrossDownZero::IsMacdCrossZeroStable(int index,int crossStableLength)
{
   return (macd.Main(index)<0 && IsMacdCrossZeroAt(index+crossStableLength));
}

bool MacdCrossDownZero::IsMacdCrossZeroAt(int index)
{
   return ( (macd.Main(index+1)>0)  && (macd.Main(index)<0) );
}




class MacdCrossUpZero :public MacdCrossZero
{

        
   public:
   
      void  MacdCrossUpZero();
      void  ~MacdCrossUpZero();
    
      bool IsMacdCrossZeroStable(int index,int crossStableLength);    
      bool IsMacdCrossZeroAt(int index);
         
};

void MacdCrossUpZero::MacdCrossUpZero()
{  
}


void MacdCrossUpZero::~MacdCrossUpZero()
{
}


bool MacdCrossUpZero::IsMacdCrossZeroStable(int index,int crossStableLength)
{
   return (macd.Main(index)>0 && IsMacdCrossZeroAt(index+crossStableLength));
}

bool MacdCrossUpZero::IsMacdCrossZeroAt(int index)
{
   return ( (macd.Main(index+1)<0)  && (macd.Main(index)>0) );
}



////+------------------------------------------------------------------+
////| Expert initialization function                                   |
////+------------------------------------------------------------------+
//
//MacdCrossZero *macdCrossUpZero;
//MacdCrossZero *macdCrossDownZero;
//AllSymbols *allSymbols;
//int OnInit()
//{
//   macdCrossUpZero = new MacdCrossUpZero;
//   macdCrossDownZero = new MacdCrossDownZero;
//   allSymbols=new AllSymbols;
//   return(0);
//}
////+------------------------------------------------------------------+
////| Expert deinitialization function                                 |
////+------------------------------------------------------------------+
//void OnDeinit(const int reason)
//{
//   delete macdCrossUpZero;
//   delete macdCrossDownZero;
//   
//}
////+------------------------------------------------------------------+
////| Expert tick function                                             |
////+------------------------------------------------------------------+
//void OnTick()
//{
//   Alert("<------Tick time = ",TimeCurrent());
//   TestAllCrossUpSignal();
//   TestAllCrossDownSignal();
//   Alert("Tick time = ",TimeCurrent(),"------>");
//}
//
//void TestAllCrossUpSignal()
//{
//   for(int i=0;i<allSymbols.Total();i++)
//   {
//      string symbol=allSymbols.At(i);
//      macdCrossUpZero.Init(symbol,PERIOD_M5);
//      TestCrossSignal(macdCrossUpZero,symbol,"Up");
//   }
//}
//
//
//
//void TestAllCrossDownSignal()
//{
//   for(int i=0;i<allSymbols.Total();i++)
//   {
//      string symbol=allSymbols.At(i);
//      macdCrossDownZero.Init(symbol,PERIOD_M5);
//      TestCrossSignal(macdCrossDownZero,symbol,"Down");
//   }
//}
//
//void TestCrossSignal(MacdCrossZero *macdCrossZero,string symbol,string UpOrDown)
//{
//  if (macdCrossZero.IsMacdCrossZeroAt(0)) Alert(symbol," macd cross ",UpOrDown," zero now ");
//  if (macdCrossZero.IsMacdCrossZeroStable(0,1)) Alert(symbol, "  macd cross ",UpOrDown," zero stable "); 
//  if (macdCrossZero.IsMacdCrossZeroBetween(0,1,5)) Alert(symbol, "  macd cross ",UpOrDown," zero between 1 and 5 "); 
//}
//


