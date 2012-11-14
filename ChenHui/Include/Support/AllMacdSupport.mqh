//+------------------------------------------------------------------+
//|                                                      Support.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "./ISupport.mqh"
#include "../Indicator/ChMacd.mqh"
#include "../Indicator/ChPrice.mqh"
#include "../Symbol/AllSymbol.mqh"
#include "../Symbol/RelateConfirmer.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


class AllMacdSupport:public ISupport
{

   protected:
      string symbol;
      ENUM_TIMEFRAMES timeFrame;
      AllSymbols  *allSymbols;
      RelateConfirmer *relateConfirmer;
      
      bool IsLongTrend(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool IsMacdLargeZero(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool IsShortTrend(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool IsMacdSmallZero(string symbol,ENUM_TIMEFRAMES timeFrame);
      double GetMacd(string symbol,ENUM_TIMEFRAMES timeFrame);
      double GetClose(string symbol,ENUM_TIMEFRAMES timeFrame);
      
   public:
      AllMacdSupport();
      ~AllMacdSupport();
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
AllMacdSupport::AllMacdSupport()
{
   allSymbols=new AllSymbols;
   relateConfirmer=new RelateConfirmer;
   
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
AllMacdSupport::~AllMacdSupport()
{
   if (allSymbols!=NULL)  {delete allSymbols;   allSymbols=NULL;}
   if (relateConfirmer!=NULL) {delete relateConfirmer;relateConfirmer=NULL;}
}
//+------------------------------------------------------------------+

bool AllMacdSupport::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   this.symbol=symbol;
   this.timeFrame=timeFrame;
   relateConfirmer.Init(this.symbol);
   return (true);
}

bool AllMacdSupport::IsLongTrend(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return (    IsMacdLargeZero(symbol,PERIOD_D1)
          &&   IsMacdLargeZero(symbol,PERIOD_H4)
          &&   IsMacdLargeZero(symbol,PERIOD_M30)
          &&   IsMacdLargeZero(symbol,PERIOD_M5) );
}


bool AllMacdSupport::IsMacdLargeZero(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return (GetMacd(symbol,timeFrame)>0);
}

bool AllMacdSupport::IsShortTrend(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return (    IsMacdSmallZero(symbol,PERIOD_D1)
          &&   IsMacdSmallZero(symbol,PERIOD_H4)
          &&   IsMacdSmallZero(symbol,PERIOD_M30)
          &&   IsMacdSmallZero(symbol,PERIOD_M5) );

}

bool AllMacdSupport::IsMacdSmallZero(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return (GetMacd(symbol,timeFrame)<0);
}


double AllMacdSupport::GetMacd(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   ChMacd *macd=new ChMacd;
   macd.Create(symbol,timeFrame);
   double macdData=macd.Main();
   delete macd;
   return macdData;
}

double AllMacdSupport::GetClose(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   ChClose *close=new ChClose;
   close.Create(symbol,timeFrame);
   double closeData=close.Main();
   delete close;
   return closeData;

}


class LongAllMacdSupport:public AllMacdSupport
{
   public:
      void LongAllMacdSupport(){};
      void ~LongAllMacdSupport(){};
      bool virtual IsLeftLeftTo(string suspentsSymbol);
      bool virtual IsLeftRightTo(string suspentsSymbol);
      bool virtual IsRightLeftTo(string suspentsSymbol);
      bool virtual IsRightRightTo(string suspentsSymbol);
      void virtual LeftLeftAlert(int number,string suspentsSymbol);
      void virtual LeftRightAlert(int number,string suspentsSymbol);
      void virtual RightLeftAlert(int number,string suspentsSymbol);
      void virtual RightRightAlert(int number,string suspentsSymbol);
};


bool LongAllMacdSupport::IsLeftLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftLeftRelateTo(suspentsSymbol)
         && IsLongTrend(suspentsSymbol,timeFrame);
}

bool LongAllMacdSupport::IsLeftRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftRightRelateTo(suspentsSymbol)
          && IsShortTrend(suspentsSymbol,timeFrame);
}

bool LongAllMacdSupport::IsRightLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightLeftRelateTo(suspentsSymbol)
          && IsShortTrend(suspentsSymbol,timeFrame);
}

bool LongAllMacdSupport::IsRightRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightRightRelateTo(suspentsSymbol)
          && IsLongTrend(suspentsSymbol,timeFrame);
}

void LongAllMacdSupport::LeftLeftAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is left left support long trend with symbol ");
}

void LongAllMacdSupport::LeftRightAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is left Right support long trend with symbol ");
}

void LongAllMacdSupport::RightLeftAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is Right left support long trend with symbol ");
}

void LongAllMacdSupport::RightRightAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is Right Right support long trend with symbol ");
}

class ShortAllMacdSupport:public AllMacdSupport
{
   public:
      void ShortAllMacdSupport(){};
      void ~ShortAllMacdSupport(){};
      bool virtual IsLeftLeftTo(string suspentsSymbol);
      bool virtual IsLeftRightTo(string suspentsSymbol);
      bool virtual IsRightLeftTo(string suspentsSymbol);
      bool virtual IsRightRightTo(string suspentsSymbol);
      void virtual LeftLeftAlert(int number,string suspentsSymbol);
      void virtual LeftRightAlert(int number,string suspentsSymbol);
      void virtual RightLeftAlert(int number,string suspentsSymbol);
      void virtual RightRightAlert(int number,string suspentsSymbol);
};



bool ShortAllMacdSupport::IsLeftLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftLeftRelateTo(suspentsSymbol)
          && IsShortTrend(suspentsSymbol,timeFrame) ;
}

bool ShortAllMacdSupport::IsLeftRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftRightRelateTo(suspentsSymbol)
          && IsLongTrend(suspentsSymbol,timeFrame);
}

bool ShortAllMacdSupport::IsRightLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightLeftRelateTo(suspentsSymbol)
          && IsLongTrend(suspentsSymbol,timeFrame);
}

bool ShortAllMacdSupport::IsRightRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightRightRelateTo(suspentsSymbol)
          && IsShortTrend(suspentsSymbol,timeFrame);
}


void ShortAllMacdSupport::LeftLeftAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is left left support short trend with symbol ");
}

void ShortAllMacdSupport::LeftRightAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is left Right support short trend with symbol ");
}

void ShortAllMacdSupport::RightLeftAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is Right left support short trend with symbol ");
}

void ShortAllMacdSupport::RightRightAlert(int number,string suspentsSymbol)
{
   Alert(number ," : ",suspentsSymbol, "  is Right Right support short trend with symbol ");
}
