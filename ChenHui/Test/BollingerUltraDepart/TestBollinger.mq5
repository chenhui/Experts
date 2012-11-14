//+------------------------------------------------------------------+
//|                                                TestUltraMacd.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "..\..\Include\Indicator\ChMacd.mqh"
#include "..\..\Include\Indicator\ChPrice.mqh"
#include "..\..\Include\Symbol\AllSymbol.mqh"
AllSymbols *symbols;
ChMacd  *macd;
ChClose *close;
ChOpen  *open;

int OnInit()
{
   macd=new ChMacd;
   close =new ChClose;
   open =new ChOpen;
   symbols=new AllSymbols;
   string symbol=Symbol();
   macd.Create(symbol,PERIOD_CURRENT);
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
   for(int i=0;i<symbols.Total();i++)
   {
      string symbol=symbols.At(i);
      if (AreKSerialLong(symbols.At(i),PERIOD_M5,4,0))  Alert(symbol,"  : k line are serial long in 4");
   }
}

bool AreKSerialLong(string symbol, ENUM_TIMEFRAMES timeFrame,int numbers,int shift)
{
   close.Create(symbol,timeFrame);
   open.Create(symbol,timeFrame);
   for(int index=shift;index<shift+numbers;index++)
   {
      if (!IsKLong(index)) return (false);
   }
   return (true);
}

bool IsKLong(int shift)
{

   return (close.Main(shift)>open.Main(shift));
}

//+------------------------------------------------------------------+
