//+------------------------------------------------------------------+
//|                                               TestActiveWave.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\include\Fibonaq\ActiveWave.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
ActiveWave *activeWave;
Peaks *upPeaks;
Peaks *downPeaks;
Ultras *upUltras;
Ultras *downUltras;
string testSymbol;
ENUM_TIMEFRAMES timeFrame;
int OnInit()
{
   testSymbol=Symbol();
   timeFrame=PERIOD_CURRENT;
   
   upUltras=new UpUltras;
   upUltras.Init(testSymbol,timeFrame);
   downUltras=new DownUltras;
   downUltras.Init(testSymbol,timeFrame);
   
   upPeaks=new UpPeaks;
   upPeaks.Init(Symbol(),PERIOD_CURRENT);
   downPeaks=new DownPeaks;
   downPeaks.Init(Symbol(),PERIOD_CURRENT);
   
   activeWave=new ActiveWave;
   activeWave.Init(Symbol(),PERIOD_CURRENT,50,12);
   activeWave.ShowInflexions(200);

   Alert("------------------New Peaks---------------------");
   ShowNewUpPeaks(3);
   ShowNewDownPeaks(3);
   TestUpPeaksIsPossible(55);
   TestUpPeaksIsPossible(54);
   TestUpPeaksIsPossible(158);
   TestUpPeaksIsPossible(168);
   TestDownPeaksIsPossible(158);
   TestDownPeaksIsPossible(168);
   Alert("------------------Test Ultras--------------------");
   Alert("UltraUp(0,200)= (",upUltras.IndexOf(0,200)," : ",upUltras.ValueOf(0,200)," )");
   Alert("UltraDwon(0,200)= (",downUltras.IndexOf(0,200)," : ",downUltras.ValueOf(0,200)," )");
   Alert("UltraDwon(33,55)= (",downUltras.IndexOf(33,55)," : ",downUltras.ValueOf(33,55)," )");  
 
   
   
   EventSetTimer(60);
      
//---
   return(0);
}

void TestUpPeaksIsPossible(int index)
{
   if (upPeaks.IsPossible(index))  Alert(index," is possible up peaks ");
   else Alert(index," is not possible up peaks ");   
}

void TestDownPeaksIsPossible(int index)
{
   if (downPeaks.IsPossible(index))  Alert(index," is possible down peaks ");
   else Alert(index," is not possible down peaks ");   
}


void ShowNewUpPeaks(int Counts)
{
   ShowPeaks(3,upPeaks);
}


void ShowNewDownPeaks(int Counts)
{
   ShowPeaks(3,downPeaks);
}

void ShowPeaks(int counts,Peaks *peaks)
{
   int indexOfPeak=peaks.IndexOfNear(0);
   double valueOfPeak=peaks.ValueOfNear(0);
   for (int count=0;count<counts;count++)
   { 
      Alert("Index of up peak = (",indexOfPeak," : ",valueOfPeak," )");
      valueOfPeak=peaks.ValueOfNear(indexOfPeak);
      indexOfPeak=peaks.IndexOfNear(indexOfPeak);
   }
   
}



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if (activeWave!=NULL) delete activeWave;
   if (upPeaks!=NULL) delete upPeaks;
   if (downPeaks!=NULL) delete downPeaks;
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
