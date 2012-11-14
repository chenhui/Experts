//+------------------------------------------------------------------+
//|                                                TestFourPrice.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "../../include/indicator/ChPrice.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int OnInit()
{
   ChClose *close;
   ChHigh  *high;
   ChOpen  *open;
   ChLow   *low;
   AllSymbols *symbols;
   

   
   symbols=new AllSymbols;
   for(int index=0;index<symbols.Total();index++)
   {
      high=new ChHigh;
      open=new ChOpen;
      low=new ChLow;
      close =new ChClose;
      
      string symbol=symbols.At(index);
      
      close.Create(symbol,PERIOD_CURRENT);
      high.Create(symbol,PERIOD_CURRENT);
      open.Create(symbol,PERIOD_CURRENT);
      low.Create(symbol,PERIOD_CURRENT);
      Alert(symbols.At(index),
            "  Close[ ",0," ]= ",close.Main(0),
            "   High[ ",0," ]= ",high.Main(0),
            "   Open[ ",0," ]= ",open.Main(0),
            "   Low[ ",0," ]= ",low.Main(0));
      if (close!=NULL) {delete close;close=NULL;}
      if (high!=NULL) {delete high;high=NULL;}
      if (open!=NULL) {delete open;open=NULL;}
      if (low!=NULL) {delete low;low=NULL;}
   }
   

   if (symbols!=NULL) {delete symbols;symbols=NULL;}
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
