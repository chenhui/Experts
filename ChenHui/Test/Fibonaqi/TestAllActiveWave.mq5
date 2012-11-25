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
#include "..\..\include\Fibonaq\ActiveWaveOfPeakFront.mqh";
#include "..\..\include\Fibonaq\ActiveWaveOfPeakLeftRight.mqh";

ActiveWaveBase *nearstActiveWave;
ActiveWaveBase *peakActiveWave;
int threshold;




int OnInit()
{
   threshold=10;
   TestInflexions();
   TestNearestDownUpActiveWave();
   TestNearestUpDownActiveWave();
   TestUpPeakRightActiveWave();
   TestDownPeakRightActiveWave();
   TestUpPeakLeftActiveWave();
   TestDownPeakLeftActiveWave();
   EventSetTimer(60);
   return(0);
}

void TestInflexions()
{
   nearstActiveWave=new PeakFrontDownUpActiveWave;
   nearstActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold);
   nearstActiveWave.ShowInflexions(100);
   if (nearstActiveWave!=NULL) delete nearstActiveWave;
}

void TestNearestDownUpActiveWave()
{  
   nearstActiveWave=new PeakFrontDownUpActiveWave;
   nearstActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold);
   Alert(">>>0, NearestDownUpActiveWave(Start , End) = ( ",nearstActiveWave.StartIndex()," , ",nearstActiveWave.EndIndex()," ) ");
   Alert(">>>0, NearestDownUpActiveWaveValue(Start , End) = ( ",nearstActiveWave.StartValue()," , ",nearstActiveWave.EndValue()," ) ");   
   if (nearstActiveWave!=NULL) delete nearstActiveWave;
}

void TestNearestUpDownActiveWave()
{  
   nearstActiveWave=new PeakFrontUpDownActiveWave;
   nearstActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold);
   Alert(">>>0, NearestUpDownActiveWave(Start , End) = ( ",nearstActiveWave.StartIndex()," , ",nearstActiveWave.EndIndex()," ) ");
   Alert(">>>0, NearestUpDownActiveWaveValue(Start , End) = ( ",nearstActiveWave.StartValue()," , ",nearstActiveWave.EndValue()," ) ");
   if (nearstActiveWave!=NULL) delete nearstActiveWave;

}

void TestUpPeakRightActiveWave()
{
   peakActiveWave=new UpPeakRightActiveWave;
   peakActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold,12);
   Alert(">>>0 UpPeakRightActive(Start , End) = ( ",peakActiveWave.StartIndex()," , ",peakActiveWave.EndIndex()," ) ");
   Alert(">>>0 UpPeakRightActive(StartValue , EndValue) = ( ",peakActiveWave.StartValue()," , ",peakActiveWave.EndValue()," ) ");
   if (peakActiveWave!=NULL) delete peakActiveWave;
}


void TestDownPeakRightActiveWave()
{
   peakActiveWave=new DownPeakRightActiveWave;
   peakActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold,12);
   Alert(">>>0 DownPeakRightActive(Start , End) = ( ",peakActiveWave.StartIndex()," , ",peakActiveWave.EndIndex()," ) ");
   Alert(">>>0 DownPeakRightActive(StartValue , EndValue) = ( ",peakActiveWave.StartValue()," , ",peakActiveWave.EndValue()," ) ");
   if (peakActiveWave!=NULL) delete peakActiveWave;
}

void TestUpPeakLeftActiveWave()
{
   peakActiveWave=new UpPeakLeftActiveWave;
   peakActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold,12);
   Alert(">>>0 UpPeakLeftActive(Start , End) = ( ",peakActiveWave.StartIndex()," , ",peakActiveWave.EndIndex()," ) ");
   Alert(">>>0 UpPeakLeftActive(StartValue , EndValue) = ( ",peakActiveWave.StartValue()," , ",peakActiveWave.EndValue()," ) ");
   if (peakActiveWave!=NULL) delete peakActiveWave;
}


void TestDownPeakLeftActiveWave()
{
   peakActiveWave=new DownPeakLeftActiveWave;
   peakActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold,12);
   Alert(">>>0 DownPeakLeftActive(Start , End) = ( ",peakActiveWave.StartIndex()," , ",peakActiveWave.EndIndex()," ) ");
   Alert(">>>0 DownPeakLeftActive(StartValue , EndValue) = ( ",peakActiveWave.StartValue()," , ",peakActiveWave.EndValue()," ) ");
   if (peakActiveWave!=NULL) delete peakActiveWave;
}


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if (nearstActiveWave!=NULL) delete nearstActiveWave;
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
