//+------------------------------------------------------------------+
//|                                                    AllSymbol.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Arrays\ArrayString.mqh>
#include <Strings\String.mqh>
 
//string  Symbols[]={"AUDCAD",
//                   "AUDJPY",
//                   "AUDNZD",
//                   "AUDUSD",
//                   "CADJPY",
//                   "CHFJPY",
//                   "EURAUD",
//                   "EURCAD",
//                   "EURCHF",
//                   "EURGBP",
//                   "EURJPY",
//                   "EURUSD",
//                   "GBPCHF",
//                   "GBPJPY",
//                   "GBPUSD",
//                   "NZDUSD",
//                   "USDCAD",
//                   "USDCHF",
//                   "USDJPY",
//                   "USDMXN",
//                   "USDTRY",
//                   "XAGUSD",
//                   "XAUUSD"};
// 


class AllSymbols
{
   private:
      CString       *cString;
      CArrayString  *allSymbols;   
      
      
   public :
   
      void      AllSymbols();
      void      ~AllSymbols();
      string    At(int index);
      int       Total();
      bool      IsReversedExist(string symbol);     
      bool      IsExist(string symbol);   
      string    Reversed(string symbol);
};

void AllSymbols::AllSymbols(void)
{
      if ((allSymbols==NULL) && (allSymbols=new CArrayString)==NULL)
      {
         printf(__FUNCTION__+": error creating object");
         return;
      }
      for(int index=0;index<SymbolsTotal(true);index++)
      {
         allSymbols.Add(SymbolName(index,true));
      }
      
//    allSymbols.AssignArray(Symbols);     
}

void AllSymbols::~AllSymbols(void)
{
   if (allSymbols!=NULL)
   {
      delete allSymbols;
      allSymbols=NULL;
   }
   if (cString!=NULL) delete cString;
}

string AllSymbols::At(int index)
{
   return allSymbols.At(index);
}

int AllSymbols::Total(void)
{
   return allSymbols.Total();
}

bool AllSymbols::IsReversedExist(string symbol)
{
   return (IsExist(Reversed(symbol)));
}

string AllSymbols::Reversed(string symbol)
{
   cString=new CString;
   cString.Assign(symbol);
   return (cString.Right(3)+cString.Left(3));
}

bool AllSymbols::IsExist(string symbol)
{
   for(int index=0;index<allSymbols.Total();index++)
   {
      if (allSymbols.At(index)==symbol)  return (true);
   }
   return (false);
}

////+------------------------------------------------------------------+
////| Expert initialization function                                   |
////+------------------------------------------------------------------+
//int OnInit()
//{
//   AllSymbols  allSymbols;
//   for(int i=0;i<allSymbols.Total();i++)
//   {
//      Alert(" the " ,i ," of symbols is ",allSymbols.At(i));
//   }
//   return(0);
//}
////+------------------------------------------------------------------+
////| Expert deinitialization function                                 |
////+------------------------------------------------------------------+
//void OnDeinit(const int reason)
//{
//
//   
//}
////+------------------------------------------------------------------+
////| Expert tick function                                             |
////+------------------------------------------------------------------+
//void OnTick()
//{   
//   
//   
//}
////+------------------------------------------------------------------+
