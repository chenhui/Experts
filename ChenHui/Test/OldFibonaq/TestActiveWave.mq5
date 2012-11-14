//+------------------------------------------------------------------+
//|                                               TestActiveWave.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Fibonaq\ActiveWave.mqh"
#include "..\..\Include\Indicator\ChZigZag.mqh"
//--- input parameters
input int      Amplitude=40;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
NearActiveWave *activeWave;
ChZigZag    *zigzag;
Inflexions  *inflexions;
int OnInit()
{
   string symbol=Symbol();
   ENUM_TIMEFRAMES timeFrame=PERIOD_CURRENT;
   
   zigzag =new ChZigZag;
   zigzag.Create(symbol,timeFrame);
   
   inflexions=new Inflexions;
   inflexions.Init(symbol,timeFrame);
   
   activeWave=new NearActiveWave;
   activeWave.Init(symbol,timeFrame);
   Alert("Test zigzag wave is started.......................");
   Alert("Index of pre inflexion at 0 is ",inflexions.PreIndexTo(0));
   Alert("Index of fixed inflexion is ",inflexions.FixedIndexFrom(0));
   Alert("Fixed Inflexion is zigzag[ ",inflexions.FixedIndexFrom()," ] = "
                                    ,zigzag.Main(inflexions.FixedIndexFrom()));
   Alert("Start Index of active wave is ",activeWave.FindStart(),
         "  value is ",activeWave.ValueOfStart());
   Alert("End  Index of active wave is ",activeWave.FindEnd(),
         "  value is ",activeWave.ValueOfEnd());
   Alert("Amplitude of near active wave is ",activeWave.Amplitude());
   Alert("Amplitude points of near active is ",activeWave.AmplitudePoints());
   Alert("Start Value of near active is ",activeWave.ValueOfStart());
   Alert("End Value of near active is ",activeWave.ValueOfEnd());
   Alert("0.382 of near active is ",activeWave.ZeroDotThreeEightTwoValue());
   Alert("0.618 of near active is ",activeWave.ZeroDotSixOneEightValue());
   Alert("0.25  of near active is ",activeWave.OneQuaterValue());
   Alert("0.75  of near active is ",activeWave.ThreeQuatersValue());
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
   delete zigzag;
   delete activeWave;
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   
}
//+------------------------------------------------------------------+
