//+------------------------------------------------------------------+
//|                                             TestFibonaqClose.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include "../../include/Fibonaq/FibonaqClose.mqh"

class FakeCloseSignal:public ICloseSignal
{
   public:
      void  FakeCloseSignal(){};
      void  ~FakeCloseSignal(){};
      bool  virtual Init(string symbol,ENUM_TIMEFRAMES timeFrame){return true;};
      bool  virtual Main(int index=0){return (true);} ;
      
};



int OnInit()
{
   Alert("current time is ",TimeCurrent());  
   //please open long position that current price is higher than open price
   TestFibonaqCloseLong();
   //please open short position that current price is lower than open price
   TestFibonaqCloseShort();

   return(0);
}

void TestFibonaqCloseLong()
{
   TestFibonaq(new FibonaqCloseLong);
}


void TestFibonaqCloseShort()
{
   TestFibonaq(new FibonaqCloseShort);
}

void TestFibonaq(IClose *close)
{
   ICloseSignal *closeSignal=new FakeCloseSignal;
   close.Init(closeSignal);
   close.Main();
   delete closeSignal;
   delete close;
   
}

void OnDeinit(const int reason)
{

}

void OnTick()
{ 
}
//+------------------------------------------------------------------+
