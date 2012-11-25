//+------------------------------------------------------------------+
//|                                               TestActiveWave.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\include\Fibonaq\ActiveWaveOfPeakLeftRight.mqh";
#include "..\..\include\Fibonaq\ActiveWaveOfPeakFront.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

string testSymbol;

ActiveWaveBase  *firstUpActiveWave;
ActiveWaveBase *firstDownActiveWave;
ActiveWaveBase *upPeakLeftActiveWave;
ActiveWaveBase *downPeakLeftActiveWave;

//ActiveWaveBase *nearstActiveWave;
ENUM_TIMEFRAMES timeFrame;
int OnInit()
{
   testSymbol=Symbol();
   timeFrame=PERIOD_CURRENT;
   
   TestShowInflexions();
   TestIndexOfPossibleStart();
   TestIndexOfCentrePeak();
   TestIndexOfNextCentrePeak();
   TestFindEndIndexLeft();
   TestIsAmplitudeExist();

   
   TestFirstUpActiveWave();
   TestFirstDownActiveWave();
   TestUpPeakLeftActiveWave();
   TestDownPeakLeftActiveWave();


   EventSetTimer(60);
      
//---
   return(0);
}

//void TestNearestDownUpActiveWave()
//{  
//   nearstActiveWave=new NearestDownUpActiveWave;
//   nearstActiveWave.Init(Symbol(),PERIOD_CURRENT,50);
//   Alert(">>>0, NearestDownUpActiveWave(Start , End) = ( ",nearstActiveWave.StartIndex()," , ",nearstActiveWave.EndIndex()," ) ");
//   Alert(">>>0, NearestDownUpActiveWaveValue(Start , End) = ( ",nearstActiveWave.StartValue()," , ",nearstActiveWave.EndValue()," ) ");
//}
//
//void TestNearestUpDownActiveWave()
//{  
//   nearstActiveWave=new NearestUpDownActiveWave;
//   nearstActiveWave.Init(Symbol(),PERIOD_CURRENT,50);
//   Alert(">>>0, NearestUpDownActiveWave(Start , End) = ( ",nearstActiveWave.StartIndex()," , ",nearstActiveWave.EndIndex()," ) ");
//   Alert(">>>0, NearestUpDownActiveWaveValue(Start , End) = ( ",nearstActiveWave.StartValue()," , ",nearstActiveWave.EndValue()," ) ");
//}

void TestUpPeakLeftActiveWave()
{
   upPeakLeftActiveWave=new UpPeakLeftActiveWave;
   upPeakLeftActiveWave.Init(Symbol(),PERIOD_CURRENT,50,12);
   Alert(">>>0, UpPeakLeftActiveWave(Start , End) = ( ",upPeakLeftActiveWave.StartIndex()," , ",upPeakLeftActiveWave.EndIndex()," ) ");
   Alert(">>0,UpPeakLeftActiveWave(StartValue,EndValue) = ( ",upPeakLeftActiveWave.StartValue()," , ",upPeakLeftActiveWave.EndValue()," ) ");
   Alert(">>>85, UpPeakLeftActiveWave(Start , End) = ( ",upPeakLeftActiveWave.StartIndex(85)," , ",upPeakLeftActiveWave.EndIndex(85)," ) ");
   Alert(">>85, UpPeakLeftActiveWave(StartValue,EndValue) = ( ",upPeakLeftActiveWave.StartValue(85)," , ",upPeakLeftActiveWave.EndValue(85)," ) ");

}

void TestDownPeakLeftActiveWave()
{
   downPeakLeftActiveWave=new DownPeakLeftActiveWave;
   downPeakLeftActiveWave.Init(Symbol(),PERIOD_CURRENT,50,12);
   Alert(">>>0 DownPeakLeftActiveWave(Start , End) = ( ",downPeakLeftActiveWave.StartIndex()," , ",downPeakLeftActiveWave.EndIndex()," ) ");
   Alert(">>0,DownPeakLeftActiveWave(StartValue,EndValue) = ( ",downPeakLeftActiveWave.StartValue()," , ",downPeakLeftActiveWave.EndValue()," ) ");
   Alert(">>>85 DownPeakLeftActiveWave(Start , End) = ( ",downPeakLeftActiveWave.StartIndex(85)," , ",downPeakLeftActiveWave.EndIndex(85)," ) ");
   Alert(">>85,DownPeakLeftActiveWave(StartValue,EndValue) = ( ",downPeakLeftActiveWave.StartValue(85)," , ",downPeakLeftActiveWave.EndValue(85)," ) ");
   Alert(">>>191 DownPeakLeftActiveWave(Start , End) = ( ",downPeakLeftActiveWave.StartIndex(191)," , ",downPeakLeftActiveWave.EndIndex(191)," ) ");
   Alert(">>191,DownPeakLeftActiveWave(StartValue,EndValue) = ( ",downPeakLeftActiveWave.StartValue(191)," , ",downPeakLeftActiveWave.EndValue(191)," ) ");

}

void TestFirstUpActiveWave()
{
   firstUpActiveWave=new UpPeakRightActiveWave();
   firstUpActiveWave.Init(Symbol(),PERIOD_CURRENT,50,12);
   Alert(">>> FirstUpActiveWave(Start , End) = ( ",firstUpActiveWave.StartIndex()," , ",firstUpActiveWave.EndIndex()," ) ");
   Alert(">>> FirstUpActiveWave(StartValue , EndValue) = ( ",firstUpActiveWave.StartValue()," , ",firstUpActiveWave.EndValue()," ) ");
}

void TestFirstDownActiveWave()
{
   firstDownActiveWave=new DownPeakRightActiveWave;
   firstDownActiveWave.Init(Symbol(),PERIOD_CURRENT,50,12);
   Alert(">>> FirstDownActiveWave(Start , End) = ( ",firstDownActiveWave.StartIndex()," , ",firstDownActiveWave.EndIndex()," ) ");
   Alert(">>> FirstDownActiveWave(StartValue , EndValue) = ( ",firstDownActiveWave.StartValue()," , ",firstDownActiveWave.EndValue()," ) ");
}

void TestIsAmplitudeExist()
{
   //if (activeWave.IsAmplitudeExisted(10,55))  Alert("[10,55] have amplitude activewave");
   //else Alert("[10,55] have not amplitude activewave");
   //if (activeWave.IsAmplitudeExisted(0,55))  Alert("[0,55] have amplitude activewave");
   //else Alert("[0.55] have not amplitude activewave");
   //if (activeWave.IsAmplitudeExisted(0,54))  Alert("[0,54] have amplitude activewave");
   //else Alert("[0.54] have not amplitude activewave");
}

void TestShowInflexions()
{
   firstUpActiveWave=new UpPeakRightActiveWave;
   firstUpActiveWave.ShowInflexions(350);
}

void TestFindEndIndexLeft()
{
   //Alert("Find End index : ",activeWave.FindEndIndexLeft(0));
   //Alert("Find End value : ",activeWave.ValueOfDown(activeWave.FindEndIndexLeft(0)));
   Alert("------------------ ",__FUNCTION__," -------------------");   
}

void TestIndexOfPossibleStart()
{
   //Alert("Index of start =  ",activeWave.IndexOfPossibleStart()," : ");
   Alert("------------------ ",__FUNCTION__," -------------------");
}

void TestIndexOfCentrePeak()
{
   //Alert("IndexOfCentre[0]=",activeWave.IndexOfCentrePeak(0));
   Alert("------------------ ",__FUNCTION__," -------------------");
   
}

void TestIndexOfNextCentrePeak()
{
   //Alert("NextCentrePeak[0]=",activeWave.IndexOfNextCentrePeak(0));
   Alert("------------------ ",__FUNCTION__," -------------------");
   
}

//void TestFindEndIndexRightUpPeak()
//{
//   Alert("EndIndexRight[0]=",activeWave.FindEndIndexRightUpPeak(0));
//   Alert("------------------ ",__FUNCTION__," -------------------");
//}
//
//void TestFindEndIndexRightDownPeak()
//{
//   Alert("EndIndexRightDownPeak[0]=",activeWave.FindEndIndexRightDownPeak(0));
//   Alert("-------------------",__FUNCTION__,"---------------------");
//}




//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //if (activeWave!=NULL) delete activeWave;
   if (firstDownActiveWave!=NULL) delete firstDownActiveWave;
   if (firstUpActiveWave!=NULL) delete firstUpActiveWave;
   if (upPeakLeftActiveWave!=NULL) delete upPeakLeftActiveWave;
 

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
