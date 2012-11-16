//+------------------------------------------------------------------+
//|                                          TestCallBackChecker.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\include\Fibonaq\CallBackChecker.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
CallBackChecker *upDownCallBackChecker;
CallBackChecker *downUpCallBackChecker;
string symbolOfCallBack;
ENUM_TIMEFRAMES timeFrameOfCallBack;
double radioOut;

int OnInit()
{
   symbolOfCallBack=Symbol();
   timeFrameOfCallBack=PERIOD_CURRENT;
   radioOut=0.682;
   upDownCallBackChecker=new UpDownCallBackChecker;
   upDownCallBackChecker.Init(symbolOfCallBack,timeFrameOfCallBack,radioOut);
   Alert("(113,36,0) up down callback is ",upDownCallBackChecker.IsOk(113,36,0));
   
   downUpCallBackChecker=new DownUpCallBackChecker;
   downUpCallBackChecker.Init(symbolOfCallBack,timeFrameOfCallBack,radioOut);
   Alert("(113,36,0) down up callback is ",upDownCallBackChecker.IsOk(113,36,0));   
   EventSetTimer(60);
      
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   if (upDownCallBackChecker!=NULL) delete upDownCallBackChecker;
   if (downUpCallBackChecker!=NULL) delete downUpCallBackChecker;
      
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
