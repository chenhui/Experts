//+------------------------------------------------------------------+
//|                                                 TestChSymbol.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "../../Include/Symbol/ChSymbolInfo.mqh"

ChSymbolInfo *symboInfo;

int OnInit()
{
   EventSetTimer(60);
   symboInfo=new ChSymbolInfo;
   symboInfo.Init("EURUSD");
   if (symboInfo.IsEndDirect()) Alert("Ok , EURUSD is end directory symbol");
   symboInfo.Init("USDJPY");
   if (symboInfo.IsFrontDirect()) Alert("Ok , USDJPY is front directory symbol");
   symboInfo.Init("GBPCHF");
   if (symboInfo.IsCross())   Alert("Ok , GBPCHF is cross symbol"); 
   symboInfo.Init("GBPCHF");
   if (symboInfo.FrontRelateDirect()=="GBPUSD") Alert("Ok ,GBPCHF front relate direct symbol is GBPUSD");
   symboInfo.Init("EURUSD");
   Alert("EURUSD freeze value = ",symboInfo.FreezeValue());
       
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   if (symboInfo!=NULL) delete symboInfo;
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
