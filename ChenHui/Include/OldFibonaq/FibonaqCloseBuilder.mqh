//+------------------------------------------------------------------+
//|                                          ICloseBuilder.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "../Close/IClose.mqh"
#include "../Close/ICloseBuilder.mqh"
#include "../Fibonaq/FibonaqClose.mqh"
#include "../Fibonaq/FibonaqCloseSignal.mqh"


//-----------------------------------------------------------------------

class FibonaqCloseLongInDownActiveWaveBuilder:public ICloseBuilder
{
   public:
      void  FibonaqCloseLongInDownActiveWaveBuilder(){};
      void  ~FibonaqCloseLongInDownActiveWaveBuilder(){};
      virtual IClose*  Create();
};

IClose*  FibonaqCloseLongInDownActiveWaveBuilder::Create(void)
{
   IClose*  close=new FibonaqCloseLong;
   close.Init(new FibonaqCloseLongSignalInDownActiveWave);
   return (close);      
}

//-------------------------------------------------------------------------

class FibonaqCloseLongInUpActiveWaveBuilder:public ICloseBuilder
{
   public:
      void  FibonaqCloseLongInUpActiveWaveBuilder(){};
      void  ~FibonaqCloseLongInUpActiveWaveBuilder(){};
      virtual IClose*  Create();
};

IClose*  FibonaqCloseLongInUpActiveWaveBuilder::Create(void)
{
   IClose*  close=new FibonaqCloseLong;
   close.Init(new FibonaqCloseLongSignalInUpActiveWave);
   return (close);
}


//-----------------------------------------------------------------------

class FibonaqCloseShortInDownActiveWaveBuilder:public ICloseBuilder
{
   public:
      void  FibonaqCloseShortInDownActiveWaveBuilder(){};
      void  ~FibonaqCloseShortInDownActiveWaveBuilder(){};
      virtual IClose*  Create();
};

IClose*  FibonaqCloseShortInDownActiveWaveBuilder::Create(void)
{
   IClose*  close=new FibonaqCloseShort;
   close.Init(new FibonaqCloseShortSignalInDownActiveWave);
   return (close);      
}

//-------------------------------------------------------------------------

class FibonaqCloseShortInUpActiveWaveBuilder:public ICloseBuilder
{
   public:
      void  FibonaqCloseShortInUpActiveWaveBuilder(){};
      void  ~FibonaqCloseShortInUpActiveWaveBuilder(){};
      virtual IClose*  Create();
};

IClose*  FibonaqCloseShortInUpActiveWaveBuilder::Create(void)
{
   IClose*  close=new FibonaqCloseShort;
   close.Init(new FibonaqCloseShortSignalInUpActiveWave);
   return (close);
}

