//+------------------------------------------------------------------+
//|                                                  AllMacd.mqh.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Indicator\ChMacd.mqh"
#include "..\..\Include\Symbol\AllSymbol.mqh"
#include "..\..\Include\Support\Voter.mqh"
#include "..\..\Include\Support\Support.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
AllSymbols *symbols;


int OnInit()
{
   EventSetTimer(300);  
   symbols=new AllSymbols;
   FindAllMacdLargeZero();
   FindAllMacdSmallZero();
   return(0);
}



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   delete symbols;symbols=NULL;
      
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
   FindAllMacdLargeZero();
   FindAllMacdSmallZero();   
}


void FindAllMacdLargeZero()
{
   Alert(" ---------------- All macd > 0 ----------------------");
   for(int index=0;index<symbols.Total();index++)
   {         
      if (IsAllMacdLargeZero(symbols.At(index))) 
      {
          Alert("All macd of ",symbols.At(index)," > 0");
      }
   }
}


void FindAllMacdSmallZero()
{
   Alert(" ---------------- All macd < 0 ----------------------");
   for(int index=0;index<symbols.Total();index++)
   {         
      if (IsAllMacdSmallZero(symbols.At(index)))  
      {
         Alert("All macd of ",symbols.At(index)," < 0");
      }
   }
}

bool  IsAllMacdLargeZero(string symbol)
{
   double macdOfD1=MacdOf(symbol,PERIOD_D1);
   double macdOfH4=MacdOf(symbol,PERIOD_H4);
   double macdOfM30=MacdOf(symbol,PERIOD_M30);
   //double macdOfM5=MacdOf(symbol,PERIOD_M5);
   return ((macdOfD1>0) && (macdOfH4>0) && (macdOfM30>0));// && (macdOfM5>0));
}

bool IsAllMacdSmallZero(string symbol)
{
   double macdOfD1=MacdOf(symbol,PERIOD_D1);
   double macdOfH4=MacdOf(symbol,PERIOD_H4);
   double macdOfM30=MacdOf(symbol,PERIOD_M30);
   //double macdOfM5=MacdOf(symbol,PERIOD_M5);
   return ((macdOfD1<0) && (macdOfH4<0) && (macdOfM30<0));// && (macdOfM5<0));
   
}

double MacdOf(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   ChMacd *macd=new ChMacd;
   macd.Create(symbol,timeFrame);
   double macdData=macd.Main();
   delete macd;macd=NULL;
   return macdData;
}





//+------------------------------------------------------------------+
