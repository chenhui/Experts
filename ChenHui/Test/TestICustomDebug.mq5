//+------------------------------------------------------------------+
//|                                             TestICustomDebug.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int macdHandle;
double macd[];

int OnInit()
{
   macdHandle=iCustom(NULL,0,"Examples\\ZigZag",12,5,3);
   Alert("macdHandle is " ,macdHandle,"  error = ",GetLastError());
   TestIMacd();
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
   macdHandle=iCustom(NULL,0,"Examples\\ZigZag",12,5,3);
   TestIMacd();
}

void TestIMacd()
{
   int copy=CopyBuffer(macdHandle,0,0,100,macd);
   for(int i=0;i<100;i++)
   {
      Alert("MACD[  ",i,"  ] = ",macd[i]);
   }

}
//+------------------------------------------------------------------+
