//+------------------------------------------------------------------+
//|                                                   ActiveWaveTrigger.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "../Indicator/ChIndicator.mqh"
#include "../Indicator/ChPrice.mqh"
#include "./ActiveWave.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class IActiveWaveTrigger
{  
   public:
      IActiveWaveTrigger(){};
      ~IActiveWaveTrigger(){};
      bool virtual   Init(string symbol,ENUM_TIMEFRAMES timeFrame){return (false);};
      bool virtual   IsTouchCentralZone(){return (false);};
      int  virtual   IndexOfTouchCentralZone(){return (-1);};
      bool virtual   IsKUpThreeQuarters(){return (-1);};
      int  virtual   IndexOfKUpThreeQuarters(){return (-1);};
      bool virtual   IsKDownOneQuarter(){return (false);};
      int  virtual   IndexOfKDownOneQuarter(){return (-1);};
   
};


class ActiveWaveTrigger:public IActiveWaveTrigger
{
   protected:
      int   noIndex;
      string symbol;
      ENUM_TIMEFRAMES timeFrame;
      ChIndicator  *close;
      ChIndicator  *low;
      ChIndicator  *high;
      NearActiveWave  *activeWave;
      
      
      bool virtual IsDirectTrue(){return (false);};
      double virtual GetBorderValue(){return (0.0);};
      bool virtual   IsTouchBorder(int index){return (false);};
      
   public:
      ActiveWaveTrigger();
      ~ActiveWaveTrigger();
      bool virtual Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool virtual IsTouchCentralZone();
      int  virtual IndexOfTouchCentralZone();
      bool virtual IsKUpThreeQuarters();
      int  virtual IndexOfKUpThreeQuarters();
      bool virtual IsKDownOneQuarter();
      int  virtual IndexOfKDownOneQuarter();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ActiveWaveTrigger::ActiveWaveTrigger()
{
   noIndex = -1;
   close=new ChClose;
   low=  new   ChLow;
   high= new  ChHigh;
   activeWave =new NearActiveWave;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ActiveWaveTrigger::~ActiveWaveTrigger()
{  
   if (close!=NULL)  delete close;
   if (low!=NULL)    delete low;
   if (high!=NULL)   delete high;
   if (activeWave!=NULL)  delete activeWave;
}

bool ActiveWaveTrigger::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   this.symbol=symbol;
   this.timeFrame=timeFrame;
   return (  close.Create(symbol,timeFrame) 
          && low.Create(symbol,timeFrame)
          && high.Create(symbol,timeFrame)
          && activeWave.Init(symbol,timeFrame));
}


bool ActiveWaveTrigger::IsTouchCentralZone(void)
{
   return (IsDirectTrue() && (IndexOfTouchCentralZone()!= noIndex));
}

int ActiveWaveTrigger::IndexOfTouchCentralZone(void)
{
      if (!IsDirectTrue())   return(noIndex);
      int start=activeWave.FindStart()-1;
      for(int index=start;index>=0;index--)
      {
         if (IsTouchBorder(index) )    return (index);
      }
      return (noIndex);   
}

bool ActiveWaveTrigger::IsKUpThreeQuarters(void)
{
   return (IndexOfKUpThreeQuarters()!=noIndex);
}

int ActiveWaveTrigger::IndexOfKUpThreeQuarters(void)
{
   int start=IndexOfTouchCentralZone()-1;
   double crossValue=activeWave.ThreeQuatersValue();
   for(int index=start;index>0;index--)
   {
      if ((low.Main(index)>crossValue) ) return (index);
   }
   return (noIndex);
}

bool ActiveWaveTrigger::IsKDownOneQuarter(void)
{
   return (IndexOfKDownOneQuarter()!=noIndex);
}


int ActiveWaveTrigger::IndexOfKDownOneQuarter(void)
{
   int start=IndexOfTouchCentralZone()-1;
   double crossValue=activeWave.OneQuaterValue();
   for(int index=start;index>0;index--)
   {
      if ((high.Main(index)<crossValue) ) return (index);
   }
   return (noIndex);
}

//------------------------------------------------------------------------
class UpActiveWaveTrigger:public ActiveWaveTrigger
{
   protected:
      bool virtual IsDirectTrue();   
      double virtual GetBorderValue();
      bool virtual IsTouchBorder(int index);
   public:
      void UpActiveWaveTrigger();
      void ~UpActiveWaveTrigger();
};

void UpActiveWaveTrigger::UpActiveWaveTrigger(void){};
void UpActiveWaveTrigger::~UpActiveWaveTrigger(void){};

bool UpActiveWaveTrigger::IsDirectTrue(void)
{
      return (activeWave.ValueOfStart()>activeWave.ValueOfEnd());
}

double UpActiveWaveTrigger::GetBorderValue()
{
   return (activeWave.ZeroDotSixOneEightValue());
}

bool UpActiveWaveTrigger::IsTouchBorder(int index)
{
   return (low.Main(index)<GetBorderValue());  
}
//-------------------------------------------------------------------------------

class DownActiveWaveTrigger:public ActiveWaveTrigger
{
   protected:
      bool virtual IsDirectTrue();   
      double virtual GetBorderValue();
      bool  virtual  IsTouchBorder(int index); 
   public:
      void DownActiveWaveTrigger();
      void ~DownActiveWaveTrigger();

};

void DownActiveWaveTrigger::DownActiveWaveTrigger(void){};
void DownActiveWaveTrigger::~DownActiveWaveTrigger(void){};

bool DownActiveWaveTrigger::IsDirectTrue(void)
{
   return (activeWave.ValueOfStart()<activeWave.ValueOfEnd());
}

double DownActiveWaveTrigger::GetBorderValue(void)
{
   return (activeWave.ZeroDotThreeEightTwoValue());
}

bool DownActiveWaveTrigger::IsTouchBorder(int index)
{
   return (high.Main(index)>GetBorderValue());
}
//+------------------------------------------------------------------+
//
//class ActiveWaveShower
//{
//   public:
//      void ActiveWaveShower();
//      void ~ActiveWaveShower();
//      
//}
