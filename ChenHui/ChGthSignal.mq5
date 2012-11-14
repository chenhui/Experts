//+------------------------------------------------------------------+
//|                                                  ChGthSignal.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Indicators\Trend.mqh>;
#include "./include/ExpertAdviser.mqh" ;

class CGthSignal
{
   private:
      string               symbol;
      ENUM_TIMEFRAMES      timeFrame;
      int                  maPeriod;
      CiMA                 *ma;
   public:
      void                 CGthSignal();
      void                 ~CGthSignal();
      void                 Init(string symbol,ENUM_TIMEFRAMES timeFrame,int maPeriod);
      void                 TestMa();
      
   private:
      bool              InitMA(int size);
      double            MA(int index);
      bool              IsMaNew();
      bool              IsMaCreate();
              
};

void CGthSignal::CGthSignal()
{
}

void CGthSignal::~CGthSignal()
{
}

void CGthSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame,int maPeriod)
{
     this.symbol=symbol;
     this.timeFrame=timeFrame;
     this.maPeriod=maPeriod;
     if (!InitMA(100))  return;
      
}

bool CGthSignal::InitMA(int size)
{

   if (!IsMaNew())      return false; 
   if (!IsMaCreate())   return false; 
   ma.BufferResize(size);
   return(true);
}
  
bool CGthSignal::IsMaNew()
{
   if((ma==NULL) && ((ma =new CiMA)==NULL))
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool CGthSignal::IsMaCreate()
{
   if(!ma.Create(symbol,timeFrame,maPeriod,0,MODE_SMA,PRICE_CLOSE))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double CGthSignal::MA(int index)
{
   ma.Refresh(-1);
   return (ma.Main(index));
}
  
void CGthSignal::TestMa(void)
{
   Alert("ima from global = ",MA(0));
   
}

CGthSignal gthSignal; // class instance
//------------------------------------------------------------------ OnInit
int OnInit()
  {
   gthSignal.Init(Symbol(),Period(),5); // initialize expert
   return(0);
  }

//------------------------------------------------------------------ OnTick
void OnTick()
{
   gthSignal.TestMa();               // process incoming tick
}



