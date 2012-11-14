//+------------------------------------------------------------------+
//|                                                ExpertPlus.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\..\Include\Signals\PlusSignal.mqh"
#include "..\..\Include\Signals\MacdFilter.mqh"
#include "..\Stoploss\PrimaryStoplossCalculate.mqh"

//-------------------------------------------------------------------+
class ExpertPlusBase
{
   protected:
      Symmetry *expert;
      
   public:
      ExpertPlusBase(){expert=new Symmetry;};
      ~ExpertPlusBase(){if (expert!=NULL) delete expert;};
      void Main(){expert.Main();};
};


//--------------------------------------------------------------------------+

class ExpertPlus:public ExpertPlusBase
{
      
   public:
   
      ExpertPlus(){};
      ~ExpertPlus(){};
      bool  Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int threasholdOut,int primaryStoplossOut); 
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


bool ExpertPlus::Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int threadsholdOut,int primaryStoplossOut)
{
   TimeCheckerYielder *yielder=new TimeCheckerYielder;
   TimeSectionChecker *timeChecker=yielder.GetAllTimeChecker();
   //TimeSectionChecker *timeChecker=yielder.Get11To14And17To1TimeChecker();
   if (yielder!=NULL) delete yielder;
   
   Parameters  parameters;
   parameters.intOne=threadsholdOut;
   ISignal *signal=new PlusSignal;
   signal.Init(symbolOut,timeFrameOut,parameters);
   
   IStoplosser *stoplosser=new FixPrimaryStoplosser;
   stoplosser.Init(symbolOut,timeFrameOut,primaryStoplossOut);
   
   return expert.Init(magicNumberOut,symbolOut,timeFrameOut,lotsOut,signal,timeChecker,stoplosser);

}

//--------------------------------------------------------------------------+

class ExpertPlusWithMacdFilter:public ExpertPlusBase
{
      
   public:
   
      ExpertPlusWithMacdFilter(){};
      ~ExpertPlusWithMacdFilter(){};
      bool  Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int threasholdOut,int primaryStoplossOut); 
};



bool ExpertPlusWithMacdFilter::Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int threadsholdOut,int primaryStoplossOut)
{
   TimeCheckerYielder *yielder=new TimeCheckerYielder;
   TimeSectionChecker *timeChecker=yielder.GetAllTimeChecker();
   //TimeSectionChecker *timeChecker=yielder.Get11To14And17To1TimeChecker();
   if (yielder!=NULL) delete yielder;
   
   Parameters  parameters;
   parameters.intOne=threadsholdOut;
   ISignal *signal=new PlusSignal;
   signal.Init(symbolOut,timeFrameOut,parameters);
   
   Parameters nullParameter;
   ISignal *signalWithMacdFilter=new MacdFilter;
   signalWithMacdFilter.Init(symbolOut,timeFrameOut,nullParameter);
   signalWithMacdFilter.Input(signal);
   
   IStoplosser *stoplosser=new FixPrimaryStoplosser;
   stoplosser.Init(symbolOut,timeFrameOut,primaryStoplossOut);
   
   return expert.Init(magicNumberOut,symbolOut,timeFrameOut,lotsOut,
                        signalWithMacdFilter,timeChecker,stoplosser);

}




//--------------------------------------------------------------------------+

class ExpertPlusWithInterval:public ExpertPlusBase
{

   public:
   
      ExpertPlusWithInterval(){};
      ~ExpertPlusWithInterval(){};
      bool  Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int threasholdOut,int intervalOut,int primaryStoplossOut); 

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


bool ExpertPlusWithInterval::Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int threadsholdOut,int intervalOut,int primaryStoplossOut)
{
   TimeCheckerYielder *yielder=new TimeCheckerYielder;
   TimeSectionChecker *timeChecker=yielder.GetAllTimeChecker();
   if (yielder!=NULL) delete yielder;
   
   Parameters  parameters;
   parameters.intOne=threadsholdOut;
   parameters.intTwo=intervalOut;
   ISignal *signal=new PlusIntervalSignal;
   signal.Init(symbolOut,timeFrameOut,parameters);
   
   IStoplosser *stoplosser=new FixPrimaryStoplosser;
   stoplosser.Init(symbolOut,timeFrameOut,primaryStoplossOut);
   
   return expert.Init(magicNumberOut,symbolOut,timeFrameOut,lotsOut,signal,timeChecker,stoplosser);

}



//--------------------------------------------------------------------------+

class ExperPlusWithTimeSection:public ExpertPlusBase
{

   public:
   
      ExperPlusWithTimeSection(){};
      ~ExperPlusWithTimeSection(){};
      bool  Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int threasholdOut,int intervalOut,int primaryStoplossOut); 

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


bool ExperPlusWithTimeSection::Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int threadsholdOut,int intervalOut,int primaryStoplossOut)
{
   TimeCheckerYielder *yielder=new TimeCheckerYielder;
   TimeSectionChecker *timeChecker=yielder.GetAmericanTimeChecker();
   if (yielder!=NULL) delete yielder;
   
   Parameters  parameters;
   parameters.intOne=threadsholdOut;
   parameters.intTwo=intervalOut;
   ISignal *signal=new PlusIntervalSignal;
   signal.Init(symbolOut,timeFrameOut,parameters);
   
   IStoplosser *stoplosser=new FixPrimaryStoplosser;
   stoplosser.Init(symbolOut,timeFrameOut,primaryStoplossOut);
   
   return expert.Init(magicNumberOut,symbolOut,timeFrameOut,lotsOut,signal,timeChecker,stoplosser);

}





