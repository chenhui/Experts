//+------------------------------------------------------------------+
//|                                           FibonaqSignalEvent.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "./ActiveWave.mqh"
#include "./ActiveWaveTrigger.mqh"
#include "../indicator/ChRsi.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class FibonaqSignalEvent
{
   private:
      string symbol;
      ENUM_TIMEFRAMES timeFrame;
      NearActiveWave     *activeWave; 
      ChIndicator    *rsi;

      void ShowDayRsi();   
      void ShowRatioValue();
      void ShowTouchUpDownIn(IActiveWaveTrigger *trigger);

   public:
      FibonaqSignalEvent();
      ~FibonaqSignalEvent();
      bool Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool Main();
      
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FibonaqSignalEvent::FibonaqSignalEvent()
{
   activeWave=new NearActiveWave;
   rsi=new ChRsi;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FibonaqSignalEvent::~FibonaqSignalEvent()
{
   delete activeWave;
   activeWave=NULL;
   delete rsi;
   rsi=NULL;
}

bool FibonaqSignalEvent::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   this.symbol=symbol;
   this.timeFrame=timeFrame;
   return (activeWave.Init(symbol,timeFrame)  && rsi.Create(symbol,PERIOD_D1));
}


//+------------------------------------------------------------------+

bool FibonaqSignalEvent::Main()
{
      Alert("--------------------   Start  Test   ", symbol,"   --------------------   ");
      ShowDayRsi();
      ShowRatioValue();
      ShowTouchUpDownIn(new UpActiveWaveTrigger);
      ShowTouchUpDownIn(new DownActiveWaveTrigger);
      Alert("--------------------   End  Test   ", symbol,"   --------------------   ");
      return (true);            
}

void FibonaqSignalEvent::ShowRatioValue()
{

      Alert("(Start  ,  Value) = ","(",activeWave.FindStart(),"  ,  ",activeWave.ValueOfStart()," ) ",
            ",(End   ,  Value) = ","(",activeWave.FindEnd(),"  ,  ",activeWave.ValueOfEnd(),"  )  ");
      Alert("Value(0.25)= ",activeWave.OneQuaterValue()," ,  ",
            "Value(0.382)= ",activeWave.ZeroDotThreeEightTwoValue()," ,  ",
            "Value(0.618)= ",activeWave.ZeroDotSixOneEightValue()," ,  ",
            "Value(0.75)= ",activeWave.ThreeQuatersValue());

}

void FibonaqSignalEvent::ShowTouchUpDownIn(IActiveWaveTrigger *trigger)
{
      trigger.Init(symbol,timeFrame);
      if (trigger.IsTouchCentralZone())  Alert("Touch Point = ",trigger.IndexOfTouchCentralZone());   
      if (trigger.IsKDownOneQuarter())   Alert("K is down 0.25 = ",trigger.IndexOfKDownOneQuarter());
      if (trigger.IsKUpThreeQuarters())  Alert("K is up 0.75 = ",trigger.IndexOfKUpThreeQuarters());
      delete trigger;
}

void FibonaqSignalEvent::ShowDayRsi()
{
   Alert("Day Rsi = ",rsi.Main());     
}
