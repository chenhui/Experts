//+------------------------------------------------------------------+
//|                                              Moving Averages.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Indicators\Trend.mqh>
#include "./include/ExpertAdviser.mqh"


input double riskInput             = 0.1; // Risk
input int    stopLossInput         = 100; // Stop Loss distance
input int    takeProfitInput       = 100; // Take Profit distance
input int    trailingStopInput     =  30; // Trailing Stop distance
input int    maPeriodInput         =  12; // Moving Average period
input int    tradeStartInput       =   7; // Hour of trade start
input int    tradeEndInput         =  20; // Hour of trade end
//---



class CGth : public CExpertAdvisor
  {
protected:
   double            risk;          // size of risk
   int               stoploss;            // Stop Loss
   int               takeProfit;            // Take Profit
   int               trailingStop;            // Trailing Stop
   int               maPeriod;           // MA period
   int               tradeStart;     // Hour of trade start
   int               tradeEnd;       // Hour of trade end
   CiMA               *ma;           // MA indicator
public:
   void              CGth();
   void             ~CGth();
   virtual bool      Init(string symbol,ENUM_TIMEFRAMES timeFrame); // initialization
  
   virtual bool      Main();                              // main function
   virtual void      OpenPosition(int dir);              // open position on signal
   virtual void      ClosePosition(int dir);             // close position on signal
   virtual long      CheckSignal(bool bEntry);            // check signal
   void              TestIndicator();
   
protected:
    bool              InitMA(int size);
    double            MA(int index);
  };
//------------------------------------------------------------------ CGth
void CGth::CGth() { }
//----------------------------------------------------------------- ~CGth
void CGth::~CGth()
  {
 
  }
//------------------------------------------------------------------ Init
bool CGth::Init(string smb,ENUM_TIMEFRAMES tf)
  {
   if(!CExpertAdvisor::Init(0,smb,tf)) return(false);  // initialize parent class

   risk=riskInput;
   takeProfit=takeProfitInput; 
   stoploss=stopLossInput; 
   trailingStop=trailingStopInput; 
   maPeriod=maPeriodInput;  // copy parameters
   tradeStart=tradeStartInput; 
   tradeEnd=tradeEndInput;
   InitMA(100);
   //maHand=iMA(symbol,timeFrame,maPeriod,0,MODE_SMA,PRICE_CLOSE); // create MA indicator
   //if(maHand==INVALID_HANDLE) return(false);            // if there is an error, then exit
   initFlag=true; return(true);                         // trade allowed
  }
  
  //+------------------------------------------------------------------+
bool CGth::InitMA(int size)
  {
//--- create medium EMA indicator
   if(ma==NULL)
      if((ma=new CiMA)==NULL)
        {
         printf(__FUNCTION__+": error creating object");
         return(false);
        }
//--- initialize medium EMA indicator
   if(!ma.Create(symbol,timeFrame,maPeriod,0,MODE_SMA,PRICE_CLOSE))
     {
      printf(__FUNCTION__+": error initializing object");
      return(false);
     }
   ma.BufferResize(size);
   return(true);
  }
  
  
//------------------------------------------------------------------ Main
bool CGth::Main()                            // main function
  {
   if(!CExpertAdvisor::Main()) return(false); // call function of parent class

   if(Bars(symbol,timeFrame)<=maPeriod) return(false); // if there are insufficient number of bars
   
   if(!CheckNewBar()) return(true);           // check new bar

   // check each direction
   int dir;
   dir=ORDER_TYPE_BUY;
   OpenPosition(dir); ClosePosition(dir); TrailingPosition(dir,trailingStop);
   dir=ORDER_TYPE_SELL;
   OpenPosition(dir); ClosePosition(dir); TrailingPosition(dir,trailingStop);

   return(true);
  }
//------------------------------------------------------------------ OpenPos
void CGth::OpenPosition(int dir)
  {
   if(PositionSelect(symbol)) return;     // if there is an order, then exit
   if(!CheckTime(StringToTime(IntegerToString(tradeStart)+":00"),
                 StringToTime(IntegerToString(tradeEnd)+":00"))) return;
   if(dir!=CheckSignal(true)) return;    // if there is no signal for current direction
   double lot=CountLotByRisk(stoploss,risk,0);
   if(lot<=0) return;                    // if lot is not defined then exit
   DealOpen(dir,lot,stoploss,takeProfit);          // open position
  }
//------------------------------------------------------------------ ClosePos
void CGth::ClosePosition(int dir)
  {
   if(!PositionSelect(symbol)) return;                 // if there is no position, then exit
   if(!CheckTime(StringToTime(IntegerToString(tradeStart)+":00"),
                 StringToTime(IntegerToString(tradeEnd)+":00")))
     { trade.PositionClose(symbol); return; }        // if it's not time for trade, then close orders
   if(dir!=PositionGetInteger(POSITION_TYPE)) return; // if position of unchecked direction
   if(dir!=CheckSignal(false)) return;                // if the close signal didn't match the current position
   trade.PositionClose(symbol,1);                    // close position
  }
//------------------------------------------------------------------ CheckSignal
long CGth::CheckSignal(bool bEntry)
  {
   MqlRates rt[2];
   if(CopyRates(symbol,timeFrame,0,2,rt)!=2)
     { Print("CopyRates ",symbol," history is not loaded"); return(WRONG_VALUE); }
   double ma0=MA(0);
   if(rt[0].open<ma0 && rt[0].close>ma0)
      return(bEntry ? ORDER_TYPE_BUY:ORDER_TYPE_SELL); // condition for buy
   if(rt[0].open>ma0 && rt[0].close<ma0)
      return(bEntry ? ORDER_TYPE_SELL:ORDER_TYPE_BUY); // condition for sell

   return(WRONG_VALUE);                                // if there is no signal
  }
  
double CGth::MA(int index)
{
   ma.Refresh(-1);
   return (ma.Main(index));
}
  
void CGth::TestIndicator(void)
{
   Alert("ima from global = ",MA(0));
   
}

CGth ea; // class instance
//------------------------------------------------------------------ OnInit
int OnInit()
  {
   ea.Init(Symbol(),Period()); // initialize expert
   return(0);
  }
//------------------------------------------------------------------ OnDeinit
void OnDeinit(const int reason) { }
//------------------------------------------------------------------ OnTick
void OnTick()
  {
   ea.Main();   
   ea.TestIndicator();               // process incoming tick
  }
