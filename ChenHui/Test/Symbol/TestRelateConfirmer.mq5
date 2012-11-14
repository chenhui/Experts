//+------------------------------------------------------------------+
//|                                    TestMultipleSymbolConfirm.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include "../../Include/Symbol/AllSymbol.mqh"
#include "../../Include/Symbol/RelateConfirmer.mqh"

AllSymbols  *allSymbols;
RelateConfirmer *relateConfirmer;


int OnInit()
{

   allSymbols=new AllSymbols;

   relateConfirmer=new RelateConfirmer;
   string symbol="EURUSD";
   relateConfirmer.Init(symbol);
   
   ShowAllLeftLeftRelates(relateConfirmer);
   ShowAllLeftRightRelates(relateConfirmer);
   ShowAllRightLeftRelates(relateConfirmer);
   ShowAllRightRightRelates(relateConfirmer);
   return (0);
}

void ShowAllLeftLeftRelates(RelateConfirmer *symbol)
{
   Alert ("----------------------Left Left Relates ------------------------");
   for(int index=0;index<allSymbols.Total();index++)
   {
      string suspentsSymbol=allSymbols.At(index);
      if (symbol.IsLeftLeftRelateTo(suspentsSymbol)) 
         Alert(suspentsSymbol ," is left left relate with ",symbol.SymbolString());
   }
}

void ShowAllLeftRightRelates(RelateConfirmer *symbol)
{
   Alert ("----------------------Left Right Relates ------------------------");
   allSymbols=new AllSymbols;
   for(int index=0;index<allSymbols.Total();index++)
   {
      string suspentsSymbol=allSymbols.At(index);
      if (symbol.IsLeftRightRelateTo(suspentsSymbol))
         Alert(suspentsSymbol ," is left right relate with ",symbol.SymbolString());
   }
}



void ShowAllRightLeftRelates(RelateConfirmer *symbol)
{
   Alert ("----------------------right Left Relates ------------------------");
   for(int index=0;index<allSymbols.Total();index++)
   {
      string suspentsSymbol=allSymbols.At(index);
      if (symbol.IsRightLeftRelateTo(suspentsSymbol))
         Alert(suspentsSymbol ," is right left relate with ",symbol.SymbolString());
   }
}

void ShowAllRightRightRelates(RelateConfirmer *symbol)
{
   Alert ("----------------------right Right Relates ------------------------");
   allSymbols=new AllSymbols;
   for(int index=0;index<allSymbols.Total();index++)
   {
      string suspentsSymbol=allSymbols.At(index);
      if (symbol.IsRightRightRelateTo(allSymbols.At(index))) 
         Alert(suspentsSymbol ," is right right relate with ",symbol.SymbolString());
   }
}
