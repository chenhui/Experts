#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\..\Include\Signals\GthSignal.mqh"
#include "..\..\Include\Symmetry\Symmetry.mqh"
#include "..\Stoploss\PrimaryStoplossCalculate.mqh"

//-------------------------------------------------------------------+
class ExpertBase
{
   protected:
      Symmetry *expert;
      
   public:
      ExpertBase(){expert=new Symmetry;};
      ~ExpertBase(){if (expert!=NULL) delete expert;};
      void Main(){expert.Main();};
};


//--------------------------------------------------------------------------+

class ExpertGth:public ExpertBase
{
      
   public:
   
      ExpertGth(){};
      ~ExpertGth(){};
      bool  Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int primaryStoplossOut); 
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


bool ExpertGth::Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,int primaryStoplossOut)
{
   TimeCheckerYielder *yielder=new TimeCheckerYielder;
   TimeSectionChecker *timeChecker=yielder.GetAllTimeChecker();
   //TimeSectionChecker *timeChecker=yielder.GetEuropeTimeChecker();
   //TimeSectionChecker *timeChecker=yielder.Get11To14And17To1TimeChecker();
   //TimeSectionChecker *timeChecker=yielder.Get5To7TimeChecker();
   if (yielder!=NULL) delete yielder;
   
   Parameters  parameters;
   ISignal *signal=new GthSignal;
   signal.Init(symbolOut,timeFrameOut,parameters);
   
   IStoplosser *stoplosser=new FixPrimaryStoplosser;
   stoplosser.Init(symbolOut,timeFrameOut,primaryStoplossOut);
   
   return expert.Init(magicNumberOut,symbolOut,timeFrameOut,lotsOut,signal,timeChecker,stoplosser);

}


