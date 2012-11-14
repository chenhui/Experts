//+------------------------------------------------------------------+
//|                                                      Support.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "./ISupport.mqh"
#include "../Indicator/ChEma.mqh"
#include "../Indicator/ChPrice.mqh"
#include "../Symbol/AllSymbol.mqh"
#include "../Symbol/RelateConfirmer.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


class EmaSupport:public ISupport
{
   protected:
      string symbol;
      ENUM_TIMEFRAMES timeFrame;
      //ChIndicator *ema;
      //ChIndicator *close;
      AllSymbols  *allSymbols;
      RelateConfirmer *relateConfirmer;
      
      bool IsLongTrend(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool IsShortTrend(string symbol,ENUM_TIMEFRAMES timeFrame);
      double GetEma(string symbol,ENUM_TIMEFRAMES timeFrame);
      double GetClose(string symbol,ENUM_TIMEFRAMES timeFrame);
      
   public:
      EmaSupport();
      ~EmaSupport();
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool virtual IsLeftLeftTo(string suspentsSymbol){return false;};
      bool virtual IsLeftRightTo(string suspentsSymbol){return false;};
      bool virtual IsRightLeftTo(string suspentsSymbol){return false;};
      bool virtual IsRightRightTo(string suspentsSymbol){return false;};
      void virtual LeftLeftAlert(int number,string suspentsSymbol){};
      void virtual LeftRightAlert(int number,string suspentsSymbol){};
      void virtual RightLeftAlert(int number,string suspentsSymbol){};
      void virtual RightRightAlert(int number,string suspentsSymbol){};     
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EmaSupport::EmaSupport()
{
   //ema=new ChEma;
   //close=new ChClose;
   allSymbols=new AllSymbols;
   relateConfirmer=new RelateConfirmer;
   
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EmaSupport::~EmaSupport()
{
   //if (ema!=NULL)  {delete ema; ema=NULL;}
   //if (close!=NULL) {delete close;close=NULL;}
   if (allSymbols!=NULL)  {delete allSymbols;   allSymbols=NULL;}
   if (relateConfirmer!=NULL) {delete relateConfirmer;relateConfirmer=NULL;}
}
//+------------------------------------------------------------------+

bool EmaSupport::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   this.symbol=symbol;
   this.timeFrame=timeFrame;
   relateConfirmer.Init(this.symbol);
   return (true);
}

bool EmaSupport::IsLongTrend(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return (GetEma(symbol,timeFrame)<GetClose(symbol,timeFrame));
}

bool EmaSupport::IsShortTrend(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return (GetEma(symbol,timeFrame)>GetClose(symbol,timeFrame));
}

double EmaSupport::GetEma(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   ChEma *ema=new ChEma;
   ema.Create(symbol,timeFrame);
   double emaData=ema.Main();
   delete ema;
   return emaData;
}

double EmaSupport::GetClose(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   ChClose *close=new ChClose;
   close.Create(symbol,timeFrame);
   double closeData=close.Main();
   delete close;
   return closeData;

}


class LongEmaSupport:public EmaSupport
{
   public:
      void LongEmaSupport(){};
      void ~LongEmaSupport(){};
      bool virtual IsLeftLeftTo(string suspentsSymbol);
      bool virtual IsLeftRightTo(string suspentsSymbol);
      bool virtual IsRightLeftTo(string suspentsSymbol);
      bool virtual IsRightRightTo(string suspentsSymbol);
      void virtual LeftLeftAlert(int number,string suspentsSymbol);
      void virtual LeftRightAlert(int number,string suspentsSymbol);
      void virtual RightLeftAlert(int number,string suspentsSymbol);
      void virtual RightRightAlert(int number,string suspentsSymbol);
};


bool LongEmaSupport::IsLeftLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftLeftRelateTo(suspentsSymbol)
         && IsLongTrend(suspentsSymbol,timeFrame);
}

bool LongEmaSupport::IsLeftRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftRightRelateTo(suspentsSymbol)
          && IsShortTrend(suspentsSymbol,timeFrame);
}

bool LongEmaSupport::IsRightLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightLeftRelateTo(suspentsSymbol)
          && IsShortTrend(suspentsSymbol,timeFrame);
}

bool LongEmaSupport::IsRightRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightRightRelateTo(suspentsSymbol)
          && IsLongTrend(suspentsSymbol,timeFrame);
}

void LongEmaSupport::LeftLeftAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is left left support long trend with symbol ");
}

void LongEmaSupport::LeftRightAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is left Right support long trend with symbol ");
}

void LongEmaSupport::RightLeftAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is Right left support long trend with symbol ");
}

void LongEmaSupport::RightRightAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is Right Right support long trend with symbol ");
}

class ShortEmaSupport:public EmaSupport
{
   public:
      void ShortEmaSupport(){};
      void ~ShortEmaSupport(){};
      bool virtual IsLeftLeftTo(string suspentsSymbol);
      bool virtual IsLeftRightTo(string suspentsSymbol);
      bool virtual IsRightLeftTo(string suspentsSymbol);
      bool virtual IsRightRightTo(string suspentsSymbol);
      void virtual LeftLeftAlert(int number,string suspentsSymbol);
      void virtual LeftRightAlert(int number,string suspentsSymbol);
      void virtual RightLeftAlert(int number,string suspentsSymbol);
      void virtual RightRightAlert(int number,string suspentsSymbol);
};



bool ShortEmaSupport::IsLeftLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftLeftRelateTo(suspentsSymbol)
          && IsShortTrend(suspentsSymbol,timeFrame) ;
}

bool ShortEmaSupport::IsLeftRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftRightRelateTo(suspentsSymbol)
          && IsLongTrend(suspentsSymbol,timeFrame);
}

bool ShortEmaSupport::IsRightLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightLeftRelateTo(suspentsSymbol)
          && IsLongTrend(suspentsSymbol,timeFrame);
}

bool ShortEmaSupport::IsRightRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightRightRelateTo(suspentsSymbol)
          && IsShortTrend(suspentsSymbol,timeFrame);
}


void ShortEmaSupport::LeftLeftAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is left left support short trend with symbol ");
}

void ShortEmaSupport::LeftRightAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is left Right support short trend with symbol ");
}

void ShortEmaSupport::RightLeftAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is Right left support short trend with symbol ");
}

void ShortEmaSupport::RightRightAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is Right Right support short trend with symbol ");
}
