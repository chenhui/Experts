//+------------------------------------------------------------------+
//|                                            FibonaqCloseSignal.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "../Close/ICloseSignal.mqh"
#include "../Fibonaq/ActiveWaveTrigger.mqh"
#include "../indicator/ChIndicator.mqh"
#include "../indicator/ChRsi.mqh"


class FibonaqCloseSignal : public ICloseSignal
{
   protected:
      IActiveWaveTrigger   *trigger;
      int                  minTrigIndex;
      int                  maxTrigIndex;
      
      int   virtual  TrigIndex(){return (-1);};
      bool  IsTrigIndexValid();
   public:
      FibonaqCloseSignal();
      ~FibonaqCloseSignal();
      bool  virtual Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool  Main(int index=0);

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FibonaqCloseSignal::FibonaqCloseSignal()
{
   minTrigIndex=1;
   maxTrigIndex=5;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FibonaqCloseSignal::~FibonaqCloseSignal()
{
   if (trigger!=NULL) delete trigger;
   trigger=NULL;
}

bool FibonaqCloseSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return(trigger.Init(symbol,timeFrame));  
}

bool FibonaqCloseSignal::Main(int index=0)
{
   return (IsTrigIndexValid());
}

bool FibonaqCloseSignal::IsTrigIndexValid(void)
{
   return ( (TrigIndex()>=minTrigIndex) && (TrigIndex()<=maxTrigIndex));
}


//--------------------------------------------------------------------------
class FibonaqCloseLongSignalInUpActiveWave:public FibonaqCloseSignal
{
   protected:
      int  virtual TrigIndex();
   public:
      void FibonaqCloseLongSignalInUpActiveWave();
      void ~FibonaqCloseLongSignalInUpActiveWave();
};

void FibonaqCloseLongSignalInUpActiveWave::FibonaqCloseLongSignalInUpActiveWave(void)
{
   trigger=new UpActiveWaveTrigger;
}

void FibonaqCloseLongSignalInUpActiveWave::~FibonaqCloseLongSignalInUpActiveWave(void)
{
}

int FibonaqCloseLongSignalInUpActiveWave::TrigIndex()
{
   return (trigger.IndexOfKDownOneQuarter());
}

//--------------------------------------------------------------------------

class FibonaqCloseShortSignalInUpActiveWave:public FibonaqCloseSignal
{
   protected:
      int virtual TrigIndex();
   public:
      void FibonaqCloseShortSignalInUpActiveWave();
      void ~FibonaqCloseShortSignalInUpActiveWave();
};

void FibonaqCloseShortSignalInUpActiveWave::FibonaqCloseShortSignalInUpActiveWave(void)
{
   if (trigger==NULL)  trigger=new UpActiveWaveTrigger;
}

void FibonaqCloseShortSignalInUpActiveWave::~FibonaqCloseShortSignalInUpActiveWave(void)
{
}


int FibonaqCloseShortSignalInUpActiveWave::TrigIndex()
{
   return (trigger.IndexOfKUpThreeQuarters());
}


//--------------------------------------------------------------------------
class FibonaqCloseLongSignalInDownActiveWave:public FibonaqCloseSignal
{
   protected:
      int  virtual TrigIndex();
   public:
      void FibonaqCloseLongSignalInDownActiveWave();
      void ~FibonaqCloseLongSignalInDownActiveWave();
};

void FibonaqCloseLongSignalInDownActiveWave::FibonaqCloseLongSignalInDownActiveWave(void)
{
   trigger=new DownActiveWaveTrigger;
}

void FibonaqCloseLongSignalInDownActiveWave::~FibonaqCloseLongSignalInDownActiveWave(void)
{
}
 
int FibonaqCloseLongSignalInDownActiveWave::TrigIndex(void)
{
   return (trigger.IndexOfKDownOneQuarter());
}

//--------------------------------------------------------------------------

class FibonaqCloseShortSignalInDownActiveWave:public FibonaqCloseSignal
{
   protected:
      int  virtual TrigIndex();
   public:
      void FibonaqCloseShortSignalInDownActiveWave();
      void ~FibonaqCloseShortSignalInDownActiveWave();
};

void FibonaqCloseShortSignalInDownActiveWave::FibonaqCloseShortSignalInDownActiveWave(void)
{
   if (trigger==NULL)  trigger=new DownActiveWaveTrigger;
}

void FibonaqCloseShortSignalInDownActiveWave::~FibonaqCloseShortSignalInDownActiveWave(void)
{
}

int FibonaqCloseShortSignalInDownActiveWave::TrigIndex(void)
{
   return (trigger.IndexOfKUpThreeQuarters());
}


