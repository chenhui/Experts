//+------------------------------------------------------------------+
//|                                            TestNearestActive.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//#include "..\..\include\Fibonaq\ActiveWave.mqh";
#include "..\..\include\Fibonaq\Inflexion.mqh"
#include "..\..\include\Fibonaq\Peaks.mqh"
#include "..\..\include\Symbol\ChSymbolInfo.mqh"
#include "..\..\include\Fibonaq\CallBackChecker.mqh"
Ultras *upUltras;
Ultras *downUltras;
Peaks *upPeaks;
Peaks *downPeaks;
Inflexions *upInflexions;
Inflexions *downInflexions;
CallBackChecker *upDownChecker;
CallBackChecker *downUpChecker;

string symbolTest;
ENUM_TIMEFRAMES timeFrameTest;


int OnInit()
{
   symbolTest=Symbol();
   timeFrameTest=PERIOD_CURRENT;
   upUltras=new UpUltras;
   downUltras=new DownUltras;
   upInflexions=new UpInflexions;
   downInflexions=new DownInflexions;
   upPeaks=new UpPeaks;
   downPeaks=new DownPeaks;
   upDownChecker=new UpDownCallBackChecker;
   downUpChecker=new DownUpCallBackChecker;
   
   upUltras.Init(symbolTest,timeFrameTest);
   downUltras.Init(symbolTest,timeFrameTest);
   upInflexions.Init(symbolTest,timeFrameTest);
   downInflexions.Init(symbolTest,timeFrameTest);
   upPeaks.Init(symbolTest,timeFrameTest);
   downPeaks.Init(symbolTest,timeFrameTest);
   upDownChecker.Init(symbolTest,timeFrameTest,0.8);
   downUpChecker.Init(symbolTest,timeFrameTest,0.8);

   int firstUpPeaksIndex=upPeaks.IndexOfNear(0);
   double firstUpPeaksValue=upPeaks.ValueOfNear(0);
   int firstDownPeaksIndex=downPeaks.IndexOfNear(6);
   double firstDownPeaksValue=downPeaks.ValueOfNear(6);
   Alert("first up Peak = ",firstUpPeaksIndex," first down peak = ",firstDownPeaksIndex);
   Alert("first up Peak value = ",firstUpPeaksValue," first down peak value = ",firstDownPeaksValue);
   Alert("down ultra = (",downUltras.IndexOf(0,95)," , ",downUltras.ValueOf(0,95)," ) ");
 
   int nearestUltraIndex=upUltras.IndexOf(0,firstDownPeaksIndex);   
   Alert("Nearest ultra index: ( ",nearestUltraIndex," , ",upInflexions.ValueOf(nearestUltraIndex)," ) ");
   int nextInflexionIndex=downInflexions.NextOf(nearestUltraIndex);
   Alert("Next of nearest ultra index ( ",nextInflexionIndex," , ",downInflexions.ValueOf(nextInflexionIndex)," ) ");
   if (downUpChecker.IsOk(nextInflexionIndex,nearestUltraIndex,0))
      Alert("the nearest active wave is (",nextInflexionIndex," , ",nearestUltraIndex," ) ");
   Alert(upUltras.IndexOf(38,7));
   
   
   EventSetTimer(60);
   return(0);
}


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if (upUltras!=NULL)  delete upUltras;
   if (downUltras!=NULL) delete downUltras;
   if (upInflexions!=NULL) delete upInflexions;
   if (downInflexions!=NULL) delete downInflexions;
   if (upPeaks!=NULL) delete upPeaks;
   if (downPeaks!=NULL) delete downPeaks;
   EventKillTimer();
      
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
