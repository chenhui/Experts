//+------------------------------------------------------------------+
//|                                                      ChMoney.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\AccountInfo.mqh>
#include "..\Symbol\ChSymbolInfo.mqh"
#include "..\Symbol\AllSymbol.mqh"
#include <Strings\String.mqh>

//-------------------------------------------------------------------+


class ChMoney
{
   private:
      string       symbol;
      CAccountInfo *acount;
      ChSymbolInfo *symbolInfo;
      AllSymbols  *allSymbols;
      double CalculateLotsWith(int marginLevel);
     
   public:
      void ChMoney();
      void ~ChMoney();
      void Init(string symbolOut){this.symbol=symbolOut;};
      double GetLotsWith(int marginLevel);
};

void ChMoney::ChMoney()
{
   symbolInfo=new ChSymbolInfo;
   allSymbols=new AllSymbols;
   acount=new CAccountInfo;
}

void ChMoney::~ChMoney(void)
{
   if (symbolInfo!=NULL) delete symbolInfo;
   if (allSymbols!=NULL) delete allSymbols;
   if (acount!=NULL)     delete acount;

}

double ChMoney::GetLotsWith(int marginLevel)
{
   return MathFloor(CalculateLotsWith(marginLevel)*100)/100;
}

double ChMoney::CalculateLotsWith(int marginLevel)
{
   symbolInfo.Init(symbol); 
   if (symbolInfo.IsFrontDirect()) 
      return (acount.Equity()*acount.Leverage())/((marginLevel+1)*100000);
   if (symbolInfo.IsEndDirect()) 
      return (acount.Equity()*acount.Leverage())/((marginLevel+1)*100000*symbolInfo.Ask());
   if (symbolInfo.IsCross())
   {
      string frontRelateDirectSymbol=symbolInfo.FrontRelateDirect();
      if (allSymbols.IsExist(frontRelateDirectSymbol))
      {     
         symbolInfo.Init(frontRelateDirectSymbol);
         return (acount.Equity()*acount.Leverage())/((marginLevel+1)*100000*symbolInfo.Ask());
      }
      if (allSymbols.IsReversedExist(frontRelateDirectSymbol))
      {
         symbolInfo.Init(allSymbols.Reversed(frontRelateDirectSymbol));
         return (acount.Equity()*acount.Leverage())/((marginLevel+1)*100000)*symbolInfo.Ask();  
      }
      if (!allSymbols.IsExist(frontRelateDirectSymbol) && !allSymbols.IsReversedExist(frontRelateDirectSymbol)) 
         Alert(frontRelateDirectSymbol," Front relate direct symbol of ",symbol," is not existed!!!");  
   } 
   return 0.0; 
}