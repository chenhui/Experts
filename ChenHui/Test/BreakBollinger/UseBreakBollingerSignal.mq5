//+------------------------------------------------------------------+
//|                                           TestBreakBollinger.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include  "..\..\Include\Cross\BreakBollinger.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
AllSymbols   *symbols;
BreakBollinger  *breakBollinger;

int OnInit()
{

   symbols=new AllSymbols;
   breakBollinger=new BreakBollinger; 
   EventSetTimer(120);  
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
  if (breakBollinger!=NULL) delete breakBollinger;breakBollinger=NULL; 
  if (symbols!=NULL)    delete symbols;  symbols=NULL;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{

}

void OnTimer()
{
     Check();
}


void Check()
{
   for(int i=0;i<symbols.Total();i++)
   {
      string symbol=symbols.At(i);
      if (IsCloseUpBollinger(symbol,PERIOD_M5) )
         Alert(i," : ",symbol,"  is break up bollinger upper in M5 ");
      if (IsCloseUpBollinger(symbol,PERIOD_M5) && IsCloseUpBollinger(symbol,PERIOD_M30))
         Alert(i," : ",symbol,"  is break up bollinger upper in M5 and M30");
      if (IsCloseDownBollinger(symbol,PERIOD_M5) )
         Alert(i," : ",symbol,"  is break down bollinger  lower in M5");
      if (IsCloseDownBollinger(symbol,PERIOD_M5) && IsCloseDownBollinger(symbol,PERIOD_M30))
         Alert(i," : ",symbol,"  is break down bollinger  lower in M5 and M30");
      if (  IsCloseUpBollinger(symbol,PERIOD_M5) 
         && IsCloseUpBollinger(symbol,PERIOD_M30)
         && IsCloseUpBollinger(symbol,PERIOD_M1))
         Alert(i," ! ",symbol,"  is break up bollinger upper in M5 and M30 and M1");
      if (  IsCloseDownBollinger(symbol,PERIOD_M5) 
         && IsCloseDownBollinger(symbol,PERIOD_M30)
         && IsCloseDownBollinger(symbol,PERIOD_M1))
         Alert(i," ! ",symbol,"  is break down bollinger  lower in M5 and M30");
   }
   
}


bool IsCloseUpBollinger(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   breakBollinger.Init(symbol,timeFrame);
   return breakBollinger.IsCloseUpperAt(0);
}


bool IsCloseDownBollinger(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   breakBollinger.Init(symbol,timeFrame);
   return breakBollinger.IsCloseLowerAt(0);
}
//+------------------------------------------------------------------+
