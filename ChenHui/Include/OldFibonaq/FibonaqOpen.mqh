//+------------------------------------------------------------------+
//|                                                      InstantOpen.mqh |
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
#include "../Open/IOpen.mqh"
#include "../Open/Opener.mqh"
#include "../Open/InstantOpen.mqh"
#include "../Event/IEventAlert.mqh"
#include "./FibonaqOpenSignal.mqh"
#include "../Fibonaq/FibonaqTradeEvent.mqh"

//
//
//class InstantOpen:public Open
//{
//   protected:
//
//      bool  virtual  IsOk();
//      
//      
//   public:
//      void  InstantOpen();
//      void  ~InstantOpen();
//
//      
//};
//
//void InstantOpen::InstantOpen(void)
//{
//   this.planPrice=new ZeroPlanPrice;
//}
//
//void InstantOpen::~InstantOpen(void)
//{
//}
//
//
//bool InstantOpen::IsOk()
//{
//   return (openSignal.Main());
//}
//

//---------------------------------------------------------------------------------
class FibonaqOpenLongPositionInUpActiveWave :public InstantOpen
{  
   
   public :
      void  FibonaqOpenLongPositionInUpActiveWave();
      void  ~FibonaqOpenLongPositionInUpActiveWave();
      
}
;

void FibonaqOpenLongPositionInUpActiveWave::FibonaqOpenLongPositionInUpActiveWave(void)
{
   openSignal=new FibonaqOpenLongSignalInUpActiveWave;
   opener=new LongPositionOpener;  
   alert=new FibonaqOpenLongPositionAlert;
}
      
void FibonaqOpenLongPositionInUpActiveWave::~FibonaqOpenLongPositionInUpActiveWave(void)
{

}

//-----------------------------------------------------------------------


class FibonaqOpenLongPositionInDownActiveWave :public InstantOpen
{  
   public :
      void  FibonaqOpenLongPositionInDownActiveWave();
      void  ~FibonaqOpenLongPositionInDownActiveWave();
      
}
;

void FibonaqOpenLongPositionInDownActiveWave::FibonaqOpenLongPositionInDownActiveWave(void)
{
   openSignal=new FibonaqOpenLongSignalInDownActiveWave;
   opener=new LongPositionOpener;  
   alert=new FibonaqOpenLongPositionAlert;
}
      
void FibonaqOpenLongPositionInDownActiveWave::~FibonaqOpenLongPositionInDownActiveWave(void)
{

}

//----------------------------------------------------------------------

class FibonaqOpenShortPositionInUpActiveWave : public InstantOpen
{
   public :
      void  FibonaqOpenShortPositionInUpActiveWave();
      void  ~FibonaqOpenShortPositionInUpActiveWave();
      
}
;

void FibonaqOpenShortPositionInUpActiveWave::FibonaqOpenShortPositionInUpActiveWave(void)
{
   openSignal=new FibonaqOpenShortSignalInUpActiveWave;
   opener=new ShortPositionOpener;
   alert=new FibonaqOpenShortPositionAlert;
      
}
      
void FibonaqOpenShortPositionInUpActiveWave::~FibonaqOpenShortPositionInUpActiveWave(void)
{
}

//---------------------------------------------------------------------

class FibonaqOpenShortPositionInDownActiveWave : public InstantOpen
{
   public :
      void  FibonaqOpenShortPositionInDownActiveWave();
      void  ~FibonaqOpenShortPositionInDownActiveWave();
      
}
;

void FibonaqOpenShortPositionInDownActiveWave::FibonaqOpenShortPositionInDownActiveWave(void)
{
   openSignal=new FibonaqOpenShortSignalInDownActiveWave;
   opener=new ShortPositionOpener;
   alert=new FibonaqOpenShortPositionAlert;
      
}
      
void FibonaqOpenShortPositionInDownActiveWave::~FibonaqOpenShortPositionInDownActiveWave(void)
{
}
