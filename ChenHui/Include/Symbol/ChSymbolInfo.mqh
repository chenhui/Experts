//+------------------------------------------------------------------+
//|                                                 ChSymbolInfo.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#include <Trade\SymbolInfo.mqh>

class ChSymbolInfo
{
   private:
      string        symbol;
      CSymbolInfo   *symbolInfo;
      
   public :
   
    void             ChSymbolInfo();
    void             ~ChSymbolInfo();
    bool             Init(string symbolOut);
    string           SymbolString();
    double           Ask();
    double           Bid();
    double           SpreadValue();
    double           PointValue();
    double           FreezeValue();
    void             RefreshSymbolInfo();
    bool             IsFrontDirect();
    bool             IsEndDirect();
    bool             IsCross();
    string           FrontRelateDirect();
};
   
void  ChSymbolInfo::ChSymbolInfo(void)
{
   this.symbol=NULL;
   this.symbolInfo=new CSymbolInfo;
}


bool  ChSymbolInfo::Init(string symbolOut)
{
   this.symbol=symbolOut;
   return (true);
}


void ChSymbolInfo::~ChSymbolInfo(void)
{
   if (this.symbolInfo!=NULL)  delete this.symbolInfo;
   this.symbol=NULL;
   this.symbolInfo=NULL;
}

string ChSymbolInfo::SymbolString(void)
{
   return (this.symbol);
}

double ChSymbolInfo::Ask()
{
   RefreshSymbolInfo();
   return (symbolInfo.Ask());
}
double ChSymbolInfo::Bid(void)
{
   RefreshSymbolInfo();
   return (symbolInfo.Bid());   
}

void ChSymbolInfo::RefreshSymbolInfo()
{
   symbolInfo.Name(this.symbol);
   symbolInfo.Refresh();
   symbolInfo.RefreshRates();
}

double ChSymbolInfo::SpreadValue()
{
   RefreshSymbolInfo();
   return (symbolInfo.Spread()*symbolInfo.Point());
}

double ChSymbolInfo::PointValue()
{
   RefreshSymbolInfo();
   if(symbolInfo.Digits()==3 || symbolInfo.Digits()==5)  return(symbolInfo.Point()*10);
   return (symbolInfo.Point());
}

double ChSymbolInfo::FreezeValue()
{
   RefreshSymbolInfo();
   return (symbolInfo.FreezeLevel()*PointValue());
}

bool ChSymbolInfo::IsFrontDirect()
{
   if (StringFind(symbol,"USD",0)==0)  return true;
   return false;
}

bool ChSymbolInfo::IsEndDirect()
{
   if (StringFind(symbol,"USD",0)==3) return true;
   return false;
}

bool ChSymbolInfo::IsCross()
{
   if (StringFind(symbol,"USD",0)==-1) return true;
   return false;
}

string ChSymbolInfo::FrontRelateDirect()
{
   return (StringSubstr(symbol,0,3)+"USD");
}

class ChSymbolMath
{  
   private:
      CSymbolInfo  *symbolInfo;
   
   public :
      void     ChSymbolMath();
      void     ~ChSymbolMath();
      double   RoundBy(string symbol,double value); 
   
};

void  ChSymbolMath::ChSymbolMath(void) 
{
   symbolInfo=new CSymbolInfo;
}

void  ChSymbolMath::~ChSymbolMath(void)
{
   delete symbolInfo;
}

double ChSymbolMath::RoundBy(string symbol,double value)
{
   symbolInfo.Name(symbol);
   symbolInfo.Refresh();
   symbolInfo.RefreshRates();
   return  (MathRound(value/symbolInfo.Point())*symbolInfo.Point());
}




