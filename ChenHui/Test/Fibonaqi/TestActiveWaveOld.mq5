//+------------------------------------------------------------------+
//|                                            TestActiveWaveOld.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\include\Fibonaq\Inflexion.mqh"
#include "..\..\include\Indicator\ChPrice.mqh"
#include "..\..\include\Symbol\ChSymbolInfo.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

Inflexions  *upInflexions;
Inflexions  *downInflexions; 
ChSymbolInfo *symbolInfo;

int OnInit()
{
   EventSetTimer(60);
   string symbol=Symbol();
   symbolInfo=new ChSymbolInfo;
   symbolInfo.Init(symbol);
   
   
   upInflexions=new UpInflexions;
   upInflexions.Init(Symbol(),PERIOD_CURRENT);
   Alert("---------------up range-----------------");
   upInflexions.Show(0,100);
   Alert("---------------up range-----------------");
   
   downInflexions=new DownInflexions;
   downInflexions.Init(Symbol(),PERIOD_CURRENT);
   Alert("---------------dwon range-----------------");
   downInflexions.Show(0,100);  
   Alert("---------------dwon range-----------------"); 
   
   Alert(" Up = ",upInflexions.NextOf(0)," : ",upInflexions.ValueOf(upInflexions.NextOf(0)),
         "  Down = ",downInflexions.NextOf(0)," : ",downInflexions.ValueOf(downInflexions.NextOf(0)));
   Alert(" Points Of up and down = ",PointsOfWave(upInflexions.NextOf(0),downInflexions.NextOf(0)));
   Alert(" Start index of zero wave = ",StartIndexOfZeroWave());
   Alert(" The highest up inflexion is ",FindIndexOfHighestUpInflexion(4,100));
   Alert(" The lowest down inflexion is ",FindIndexOfLowestDownInflexion(4,100));
   return(0);
}


int StartIndexOfZeroWave()
{
   return IndexOfNextUltra(0);
}

int IndexOfNextUltra(int index)
{
   if (upInflexions.NextOf(index)<downInflexions.NextOf(index))  
      return FindIndexOfHighestUpInflexion(upInflexions.NextOf(index),downInflexions.NextOf(index));
   if (downInflexions.NextOf(index)<upInflexions.NextOf(index))
      return FindIndexOfLowestDownInflexion(downInflexions.NextOf(index),upInflexions.NextOf(index));
   return 0;  
}


int FindIndexOfHighestUpInflexion(int startIndex,int endIndex)
{
      int index=startIndex;
      int position=0;
      double ultraValue=DBL_MIN;
      while(index<endIndex)
      {
         if (ultraValue<upInflexions.ValueOf(index))
         {
           ultraValue=upInflexions.ValueOf(index);
           position=index;
         }
         index=upInflexions.NextOf(index);
      }
      return position;
}

int FindIndexOfLowestDownInflexion(int startIndex,int endIndex)
{
      int index=startIndex;
      int position=0;
      double ultraValue=DBL_MAX;
      while(index<endIndex)
      {
         if (ultraValue>downInflexions.ValueOf(index))
         {
           ultraValue=downInflexions.ValueOf(index);
           position=index;
         }
         index=downInflexions.NextOf(index);
      }
      return position;
}


int PointsOfWave(int upIndex,int downIndex)
{   
   return PointsOf(upInflexions.ValueOf(upIndex)-downInflexions.ValueOf(downIndex));
}

int PointsOf(double amplitude)
{
   return (amplitude/symbolInfo.PointValue());
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   if (upInflexions!=NULL) delete upInflexions;
   if (downInflexions!=NULL) delete downInflexions;
      
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
