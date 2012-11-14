//+------------------------------------------------------------------+
//|                                                    TestMoney.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include "..\Include\Money\ChMoney.mqh"

ChMoney *money;

int OnInit()
{
   EventSetTimer(60);
   string symbol="USDJPY";
   money=new ChMoney;
   money.Init(symbol);
   Alert(symbol," lots with fixed 10 margin level = ",money.GetLotsWith(10));
   symbol="EURUSD";
   money.Init(symbol);
   Alert(symbol," lots with fixed 10 margin level = ",money.GetLotsWith(10));
   symbol="GBPJPY";
   money.Init(symbol);
   Alert(symbol," lots with fixed 10 margin level = ",money.GetLotsWith(10));
   symbol="CHFJPY";
   money.Init(symbol);
   Alert(symbol," lots with fixed 10 margin level = ",money.GetLotsWith(10));
   return(0);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   if (money!=NULL) delete money;
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   
}
//+------------------------------------------------------------------+
