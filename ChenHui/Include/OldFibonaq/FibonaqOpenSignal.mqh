//+------------------------------------------------------------------+
//|                                            FibonaqOpenSignal.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "../Signal/ISignal.mqh"
#include "../Fibonaq/ActiveWaveTrigger.mqh"
#include "../indicator/ChIndicator.mqh"
#include "../indicator/ChRsi.mqh"


class FibonaqOpenSignal : public ISignal
{
   protected:
      ChIndicator          *rsi;
      IActiveWaveTrigger   *trigger;
      ENUM_TIMEFRAMES      rsiTimeFrame;
      double               rsiUpThreshold;
      int                  minTrigIndex;
      int                  maxTrigIndex;

      int  virtual TrigIndex(){return -1;};
      bool IsTrigIndexValid(void);
      bool virtual IsRsiOk(){return false;};      
   public:
      FibonaqOpenSignal();
      ~FibonaqOpenSignal();
      bool  virtual Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool  virtual Main(int index=0);

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FibonaqOpenSignal::FibonaqOpenSignal()
{
   rsiTimeFrame=PERIOD_D1;
   rsiUpThreshold=50;
   minTrigIndex=1;
   maxTrigIndex=5;
   if (rsi==NULL )  rsi=new ChRsi;

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FibonaqOpenSignal::~FibonaqOpenSignal()
{
   if (rsi!=NULL)  delete rsi;
   if (trigger!=NULL) delete trigger;
   rsi=NULL;
   trigger=NULL;
}

bool FibonaqOpenSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return(rsi.Create(symbol,rsiTimeFrame)  &&   trigger.Init(symbol,timeFrame));  
}


bool FibonaqOpenSignal::Main(int index=0)
{
   return (  IsTrigIndexValid()  &&  IsRsiOk()  );
          
}

bool FibonaqOpenSignal::IsTrigIndexValid(void)
{
   return ( (TrigIndex()>=minTrigIndex) && (TrigIndex()<=maxTrigIndex));
}

//--------------------------------------------------------------------------
class FibonaqOpenLongSignalInUpActiveWave:public FibonaqOpenSignal
{
   protected:
      int virtual TrigIndex();
      bool virtual IsRsiOk();
   public:
      void FibonaqOpenLongSignalInUpActiveWave();
      void ~FibonaqOpenLongSignalInUpActiveWave();
};

void FibonaqOpenLongSignalInUpActiveWave::FibonaqOpenLongSignalInUpActiveWave(void)
{
   trigger=new UpActiveWaveTrigger;
}

void FibonaqOpenLongSignalInUpActiveWave::~FibonaqOpenLongSignalInUpActiveWave(void)
{
}


int FibonaqOpenLongSignalInUpActiveWave::TrigIndex()
{
   return (trigger.IndexOfKUpThreeQuarters());
}

bool FibonaqOpenLongSignalInUpActiveWave::IsRsiOk(void)
{
      return (rsi.Main()>rsiUpThreshold);
}

//--------------------------------------------------------------------------

class FibonaqOpenShortSignalInUpActiveWave:public FibonaqOpenSignal
{
   protected:
      int virtual TrigIndex();
      bool virtual IsRsiOk();
   public:
      void FibonaqOpenShortSignalInUpActiveWave();
      void ~FibonaqOpenShortSignalInUpActiveWave();
};

void FibonaqOpenShortSignalInUpActiveWave::FibonaqOpenShortSignalInUpActiveWave(void)
{
   if (trigger==NULL)  trigger=new UpActiveWaveTrigger;
}

void FibonaqOpenShortSignalInUpActiveWave::~FibonaqOpenShortSignalInUpActiveWave(void)
{
}

int FibonaqOpenShortSignalInUpActiveWave::TrigIndex(void)
{
   return (trigger.IndexOfKDownOneQuarter());
}

bool FibonaqOpenShortSignalInUpActiveWave::IsRsiOk()
{
   return (rsi.Main()<rsiUpThreshold);
}

//--------------------------------------------------------------------------
class FibonaqOpenLongSignalInDownActiveWave:public FibonaqOpenSignal
{
   protected:
      bool virtual IsRsiOk();
      int virtual TrigIndex();

   public:
      void FibonaqOpenLongSignalInDownActiveWave();
      void ~FibonaqOpenLongSignalInDownActiveWave();
};

void FibonaqOpenLongSignalInDownActiveWave::FibonaqOpenLongSignalInDownActiveWave(void)
{
   trigger=new DownActiveWaveTrigger;
}

void FibonaqOpenLongSignalInDownActiveWave::~FibonaqOpenLongSignalInDownActiveWave(void)
{
}

int FibonaqOpenLongSignalInDownActiveWave::TrigIndex(void)
{
   return (trigger.IndexOfKUpThreeQuarters());
}

bool FibonaqOpenLongSignalInDownActiveWave::IsRsiOk(void)
{
   return (rsi.Main()>rsiUpThreshold);
}

//--------------------------------------------------------------------------

class FibonaqOpenShortSignalInDownActiveWave:public FibonaqOpenSignal
{
   protected:
      bool virtual IsRsiOk();
      int virtual TrigIndex();

   public:
      void FibonaqOpenShortSignalInDownActiveWave();
      void ~FibonaqOpenShortSignalInDownActiveWave();
};

void FibonaqOpenShortSignalInDownActiveWave::FibonaqOpenShortSignalInDownActiveWave(void)
{
   if (trigger==NULL)  trigger=new DownActiveWaveTrigger;
}

void FibonaqOpenShortSignalInDownActiveWave::~FibonaqOpenShortSignalInDownActiveWave(void)
{
}

bool FibonaqOpenShortSignalInDownActiveWave::IsRsiOk(void)
{
   return (rsi.Main()<rsiUpThreshold);
}

int FibonaqOpenShortSignalInDownActiveWave::TrigIndex(void)
{
   return (trigger.IndexOfKDownOneQuarter());
}

