//+------------------------------------------------------------------+
//|                                            FibonaqEventAlert.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "../Event/IEventAlert.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class FibonaqOpenLongPositionAlert:public EventAlert
{
   public:
      FibonaqOpenLongPositionAlert();
      ~FibonaqOpenLongPositionAlert();
      virtual string Message();
};

FibonaqOpenLongPositionAlert::FibonaqOpenLongPositionAlert(void){}

FibonaqOpenLongPositionAlert::~FibonaqOpenLongPositionAlert(void){}

string FibonaqOpenLongPositionAlert::Message()
{
   return ("open fibonaq long position ");
}
//-----------------------------------------------------------------------------

class FibonaqOpenShortPositionAlert:public EventAlert
{
   public:
      FibonaqOpenShortPositionAlert();
      ~FibonaqOpenShortPositionAlert();
      virtual string Message();
};

FibonaqOpenShortPositionAlert::FibonaqOpenShortPositionAlert(void){}

FibonaqOpenShortPositionAlert::~FibonaqOpenShortPositionAlert(void){}

string FibonaqOpenShortPositionAlert::Message()
{
   return ("open fibonaq short position ");
}


class FibonaqPositionLongPrimaryStoplossAlert:public EventAlert
{
   protected:
      string virtual Message();
   public:
      FibonaqPositionLongPrimaryStoplossAlert();
      ~FibonaqPositionLongPrimaryStoplossAlert();
};


FibonaqPositionLongPrimaryStoplossAlert::FibonaqPositionLongPrimaryStoplossAlert(void){}
FibonaqPositionLongPrimaryStoplossAlert::~FibonaqPositionLongPrimaryStoplossAlert(void){}

string FibonaqPositionLongPrimaryStoplossAlert::Message(void)
{
   return ("Set Position long primary stoploss by fibonaq ! ");
}

//--------------------------------------------------------------------------
class FibonaqPositionShortPrimaryStoplossAlert:public EventAlert
{
   protected:
      string virtual Message();
   public:
      FibonaqPositionShortPrimaryStoplossAlert();
      ~FibonaqPositionShortPrimaryStoplossAlert();
};


FibonaqPositionShortPrimaryStoplossAlert::FibonaqPositionShortPrimaryStoplossAlert(void){}
FibonaqPositionShortPrimaryStoplossAlert::~FibonaqPositionShortPrimaryStoplossAlert(void){}

string FibonaqPositionShortPrimaryStoplossAlert::Message(void)
{
   return ("Set Position short primary stoploss by fibonaq ! ");
}

class FibonaqCloseLongPositionAlert:public EventAlert
{
   public:
      FibonaqCloseLongPositionAlert();
      ~FibonaqCloseLongPositionAlert();
      virtual string Message();
};

FibonaqCloseLongPositionAlert::FibonaqCloseLongPositionAlert(void){}

FibonaqCloseLongPositionAlert::~FibonaqCloseLongPositionAlert(void){}

string FibonaqCloseLongPositionAlert::Message()
{
   return ("close fibonaq long position !");
}
//-----------------------------------------------------------------------------

class FibonaqCloseShortPositionAlert:public EventAlert
{
   public:
      FibonaqCloseShortPositionAlert();
      ~FibonaqCloseShortPositionAlert();
      virtual string Message();
};

FibonaqCloseShortPositionAlert::FibonaqCloseShortPositionAlert(void){}

FibonaqCloseShortPositionAlert::~FibonaqCloseShortPositionAlert(void){}

string FibonaqCloseShortPositionAlert::Message()
{
   return ("close fibonaq short position !");
}

