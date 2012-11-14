//+------------------------------------------------------------------+
//|                                                 RelateConfirmer.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RelateConfirmer
{
   private:
      string symbol;
      
      bool IsLeftRelates(string partSymbol,string suspentsSymbol);
      bool IsRightRelates(string partSymbol,string suspentsSymbol);
      bool IsEqual(string symbol,string suspentsSymbol);
      string RightOf(string symbol);
      string LeftOf(string symbol);

   public:
      RelateConfirmer();
      ~RelateConfirmer();
      bool Init(string symbol);
      string SymbolString();
      bool IsLeftLeftRelateTo(string suspentsSymbol);
      bool IsLeftRightRelateTo(string suspentsSymbol);
      bool IsRightLeftRelateTo(string suspentsSymbol);
      bool IsRightRightRelateTo(string suspentsSymbol);

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RelateConfirmer::RelateConfirmer()
{
   this.symbol=NULL;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RelateConfirmer::~RelateConfirmer()
{
   this.symbol=NULL;
}
//+------------------------------------------------------------------+

bool RelateConfirmer::Init(string symbol)
{
   this.symbol=symbol;
   return (this.symbol!=NULL);
}

string RelateConfirmer::SymbolString(void)
{
   return (this.symbol);
}



bool RelateConfirmer::IsLeftLeftRelateTo(string suspentsSymbol)
{
   return( !IsEqual(symbol,suspentsSymbol) && IsLeftRelates(LeftOf(symbol),suspentsSymbol ) );
}

bool RelateConfirmer::IsLeftRightRelateTo(string suspentsSymbol)
{
   return( !IsEqual(symbol,suspentsSymbol) && IsRightRelates(LeftOf(symbol),suspentsSymbol ) );
}

bool RelateConfirmer::IsRightLeftRelateTo(string suspentsSymbol)
{
   return( !IsEqual(symbol,suspentsSymbol) && IsLeftRelates(RightOf(symbol),suspentsSymbol ) );
}

bool RelateConfirmer::IsRightRightRelateTo(string suspentsSymbol)
{
   return( !IsEqual(symbol,suspentsSymbol) && IsRightRelates(RightOf(symbol),suspentsSymbol ) );
}


bool RelateConfirmer::IsLeftRelates(string partSymbol,string suspentsSymbol)
{
      return (StringFind(suspentsSymbol,partSymbol)==0);
}

bool RelateConfirmer::IsRightRelates(string partSymbol,string suspentsSymbol)
{
   return (StringFind(suspentsSymbol,partSymbol)==3);
}

bool RelateConfirmer::IsEqual(string symbol,string suspentsSymbol)
{
   return (StringCompare(symbol,suspentsSymbol)==0);
}


string RelateConfirmer::LeftOf(string symbol)
{
   return StringSubstr(symbol,0,3);
}

string RelateConfirmer::RightOf(string symbol)
{
   return StringSubstr(symbol,3,3);
}

