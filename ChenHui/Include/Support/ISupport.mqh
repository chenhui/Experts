//+------------------------------------------------------------------+
//|                                                     ISupport.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ISupport
{
   public:
      ISupport(){};
      ~ISupport(){};
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame){return false;};
      bool virtual IsLeftLeftTo(string suspentsSymbol){return false;};
      bool virtual IsLeftRightTo(string suspentsSymbol){return false;};
      bool virtual IsRightLeftTo(string suspentsSymbol){return false;};
      bool virtual IsRightRightTo(string suspentsSymbol){return false;};
      void virtual LeftLeftAlert(int number,string suspentsSymbol){};
      void virtual LeftRightAlert(int number,string suspentsSymbol){};
      void virtual RightLeftAlert(int number,string suspentsSymbol){};
      void virtual RightRightAlert(int number,string suspentsSymbol){};     
};
