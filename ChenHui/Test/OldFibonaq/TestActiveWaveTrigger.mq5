//+------------------------------------------------------------------+
//|                                        TestTriggerIn.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Fibonaq\ActiveWaveTrigger.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//---

int OnInit()
{
  
   TestActiveWaveTriggerProcess();
   return(0);
   
}

bool TestActiveWaveTriggerProcess()
{
      string symbol=Symbol();
      ENUM_TIMEFRAMES  timeFrame=PERIOD_CURRENT;
      Alert("--------------------   Start  Test   ", symbol,"   --------------------   ");
      ShowRatioValueIn(new NearActiveWave,symbol,timeFrame);
      ShowTouchUPDownIn(new UpActiveWaveTrigger,symbol,timeFrame);
      ShowTouchUPDownIn(new DownActiveWaveTrigger,symbol,timeFrame);
      Alert("--------------------   End  Test   ", symbol,"   --------------------   ");
      return (true);            
}

void ShowRatioValueIn(NearActiveWave *activeWave,string symbol,ENUM_TIMEFRAMES timeFrame)
{
      activeWave.Init(symbol,timeFrame);
      Alert("(Start  ,  Value) = ","(",activeWave.FindStart(),"  ,  ",activeWave.ValueOfStart()," ) ",
            ",(End   ,  Value) = ","(",activeWave.FindEnd(),"  ,  ",activeWave.ValueOfEnd(),"  )  ");
      Alert("Value(0.25)= ",activeWave.OneQuaterValue()," ,  ",
            "Value(0.382)= ",activeWave.ZeroDotThreeEightTwoValue()," ,  ",
            "Value(0.618)= ",activeWave.ZeroDotSixOneEightValue()," ,  ",
            "Value(0.75)= ",activeWave.ThreeQuatersValue());
      delete   activeWave;
}

void ShowTouchUPDownIn(IActiveWaveTrigger *trigger,string symbol,ENUM_TIMEFRAMES timeFrame)
{
      trigger.Init(symbol,timeFrame);
      if (trigger.IsTouchCentralZone())  Alert("Touch Point = ",trigger.IndexOfTouchCentralZone());   
      if (trigger.IsKDownOneQuarter())   Alert("K is down 0.25 = ",trigger.IndexOfKDownOneQuarter());
      if (trigger.IsKUpThreeQuarters())  Alert("K is up 0.75 = ",trigger.IndexOfKUpThreeQuarters());
      delete trigger;
}
