//+------------------------------------------------------------------+
//|                                                        Voter.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "./ISupport.mqh"
#include "../Symbol/AllSymbol.mqh"
class Voter
{
   private:
          ISupport *support;
          AllSymbols  *allSymbols;
   public:
          void Voter();
          void ~Voter();
          bool With(ISupport *support);
          int  Numbers();
};

void Voter::Voter(void)
{
   allSymbols=new AllSymbols;
}

void Voter::~Voter(void)
{
   if (this.support!=NULL)  delete this.support; this.support=NULL;
   if (this.allSymbols!=NULL) delete this.allSymbols;this.allSymbols=NULL;
}

bool Voter::With(ISupport *support)
{
   this.support=support;
   return (true);  
}

int  Voter::Numbers()
{   
   int number=0; 
   for(int index=0;index<allSymbols.Total();index++)
   {
      string suspentsSymbol=allSymbols.At(index);
      if  (support.IsLeftLeftTo(suspentsSymbol))  
      {  
         number++;
         //support.LeftLeftAlert(number,suspentsSymbol);
      }
      if  (support.IsLeftRightTo(suspentsSymbol))
      {
         number++;
         //support.LeftRightAlert(number,suspentsSymbol);
      }
      if  (support.IsRightLeftTo(suspentsSymbol))  
      {  
         number++;
         //support.RightLeftAlert(number,suspentsSymbol);
      }
      if  (support.IsRightRightTo(suspentsSymbol))
      {
         number++;
         //support.RightRightAlert(number,suspentsSymbol);
      }
   }     
   return number;
}
