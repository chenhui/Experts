//+------------------------------------------------------------------+
//|                                                   TestZigZag.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "..\..\Include\indicator\ChZigZag.mqh"

ChZigZag *zigZag;

int OnInit()
{
   zigZag=new ChZigZag;
   zigZag.Create(Symbol(),PERIOD_CURRENT);
   for(int index=1000;index>=0;index--)
   {     
      if (zigZag.Main(index)!=0) 
      {
       Alert(index ,"  of zigzag  =    ",zigZag.Main(index));
      }
   }  

   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   delete zigZag;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  
   
}
//+------------------------------------------------------------------+
