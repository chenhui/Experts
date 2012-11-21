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
#include "..\..\include\Fibonaq\NearestActiveWave.mqh";

ActiveWaveBase *nearstActiveWave;
int threshold;




int OnInit()
{
   threshold=50;
   TestInflexions();
   TestNearestDownUpActiveWave();
   TestNearestUpDownActiveWave();
   EventSetTimer(60);
   return(0);
}

void TestInflexions()
{
   nearstActiveWave=new NearestDownUpActiveWave;
   nearstActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold);
   nearstActiveWave.ShowInflexions(100);
   if (nearstActiveWave!=NULL) delete nearstActiveWave;
}

void TestNearestDownUpActiveWave()
{  
   nearstActiveWave=new NearestDownUpActiveWave;
   nearstActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold);
   Alert(">>>0, NearestDownUpActiveWave(Start , End) = ( ",nearstActiveWave.StartIndex()," , ",nearstActiveWave.EndIndex()," ) ");
   Alert(">>>0, NearestDownUpActiveWaveValue(Start , End) = ( ",nearstActiveWave.StartValue()," , ",nearstActiveWave.EndValue()," ) ");
   if (nearstActiveWave!=NULL) delete nearstActiveWave;
}

void TestNearestUpDownActiveWave()
{  
   nearstActiveWave=new NearestUpDownActiveWave;
   nearstActiveWave.Init(Symbol(),PERIOD_CURRENT,threshold);
   Alert(">>>0, NearestUpDownActiveWave(Start , End) = ( ",nearstActiveWave.StartIndex()," , ",nearstActiveWave.EndIndex()," ) ");
   Alert(">>>0, NearestUpDownActiveWaveValue(Start , End) = ( ",nearstActiveWave.StartValue()," , ",nearstActiveWave.EndValue()," ) ");
   if (nearstActiveWave!=NULL) delete nearstActiveWave;

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
