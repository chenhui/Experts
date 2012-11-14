//+------------------------------------------------------------------+
//|                                              TestChBoolinger.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include  "..\..\Include\Indicator\ChBollinger.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int OnInit()
{

   ChBollinger   *bollinger=new ChBollinger;
   bollinger.Create(Symbol(),PERIOD_CURRENT);
   Alert("Test bollinger indicator " ," of ",Symbol() ,"!!!");
   for(int index=0;index<10;index++)
   {
      Alert(" Upper[ ",index," ] = ",bollinger.Upper(index),  
            " Middle[ ",index," ] = ",bollinger.Main(index),
            " Lower[ ",index," ] = ",bollinger.Lower(index));
   }
   if (bollinger!=NULL)  delete bollinger;bollinger=NULL;
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
   
}
//+------------------------------------------------------------------+
