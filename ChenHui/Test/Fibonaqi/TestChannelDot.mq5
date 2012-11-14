//+------------------------------------------------------------------+
//|                                               TestChannelDot.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//--- input parameters
#include "..\..\include\Fibonaq\Inflexion.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

ChannelDot *upChannelDot;
ChannelDot *downChannelDot;
int rangeOut=100;
string SymbolOut;
ENUM_TIMEFRAMES timeFrame;
int OnInit()
{
   SymbolOut=Symbol();
   timeFrame=PERIOD_CURRENT;
   upChannelDot=new UpChannelDot;
   downChannelDot=new DownChannelDot;
   ShowUpInflexions(rangeOut);
   ShowDownInflexions(rangeOut);
     
   Alert(" Up next Inflexion of ",0," : ",NextUpInflexionOf(0));
   Alert(" Up next inflexion of ",30," : ",NextUpInflexionOf(30));
     
   Alert(" Down next Inflexion of ",0," : ",NextDownInflexionOf(0));
   Alert(" Down next inflexion of ",7," : ",NextDownInflexionOf(7));
    
   EventSetTimer(60);
      
   return(0);
}

int NextUpInflexionOf(int currentIndex)
{
   int nextIndex=currentIndex;
   upChannelDot.Init(SymbolOut,timeFrame,nextIndex);
   while(!upChannelDot.IsInFlexion())
   {
      upChannelDot.Init(SymbolOut,timeFrame,++nextIndex);
   };
   return nextIndex;
}


int NextDownInflexionOf(int currentIndex)
{
   int nextIndex=currentIndex;
   downChannelDot.Init(SymbolOut,timeFrame,nextIndex);
   while(!downChannelDot.IsInFlexion())
   {
      downChannelDot.Init(SymbolOut,timeFrame,++nextIndex);
   };
   return nextIndex;
}


void ShowUpInflexions(int range)
{   
   for(int index=0;index<range;index++)
   {

      upChannelDot.Init(SymbolOut,timeFrame,index);
      if (upChannelDot.IsInFlexion()) Alert(" Up inflexion ",index ," : ",upChannelDot.ValueOf());
   }
}

void ShowDownInflexions(int range)
{
   for(int index=0;index<range;index++)
   {
      downChannelDot.Init(SymbolOut,timeFrame,index);
      if (downChannelDot.IsInFlexion()) Alert(" Down inflexion ",index ," : ",downChannelDot.ValueOf());
   }

}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if (upChannelDot!=NULL) delete upChannelDot;
   if (downChannelDot!=NULL) delete downChannelDot;
   EventKillTimer();
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
