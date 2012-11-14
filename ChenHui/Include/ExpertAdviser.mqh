//+------------------------------------------------------------------+
//|                                               CExpertAdvisor.mq4 |
//|              Copyright Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property library

#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\DealInfo.mqh>
//------------------------------------------------------------------ CExpertAdvisor
class CExpertAdvisor
  {
protected:
   bool              initFlag;       // flag of correct initialization
   ulong             magic;       // magic number of expert
   string            symbol;         // symbol, on which expert works
   ENUM_TIMEFRAMES   timeFrame;          // working timeframe
   CSymbolInfo       symbolInfor;      // symbol parameters
   int               timer;       // time for timer

public:
   double            point;         // consider 5/3 digit quotes for stops
   CTrade            trade;       // object to execute trade orders
   string            comment;         // comment string for information about expert's work

public:
   //--- Initialization
   void              CExpertAdvisor();                               // constructor
   void             ~CExpertAdvisor();                               // destructor
   virtual bool      Init(long magic,string symbol,ENUM_TIMEFRAMES timeFrame); // initialization

   //--- Trade modules
   virtual bool      Main();                            // main module controlling trade process
   virtual void      OpenPosition(int dir) {};         // module of opening position
   virtual void      CheckPosition(int dir) {};        // check position and open additional ones
   virtual void      ClosePosition(int dir) {};        // close position
   virtual void      BEPosition(int dir,int BE);       // moving Stop Loss to break-even
   virtual void      TrailingPosition(int dir,int TS); // trailing position of Stop Loss
   virtual void      OpenPending(int dir) {};          // module of opening pending orders
   virtual void      CheckPending(int dir) {};         // work with current orders and open additional ones
   virtual void      TrailingPending(int dir) {};      // move pending orders
   virtual void      DeletePending(int dir) {};        // delete pending orders

   //--- Functions of getting signals/events
   bool              CheckNewBar();                            // check for new bar
   bool              CheckTime(datetime start,datetime end);   // check allowed trade time
   virtual long      CheckSignal(bool bEntry) { return(-1); }; // check signal 
   virtual bool      CheckFilter(int dir) { return(false); }; // check filter for direction
   bool SetTimer(int sec)                                      // set timer
     { timer=sec; return(EventSetTimer(timer)); }
   int GetTimer() { return(timer); }                         // returns time of set timer
   void KillTimer() { EventKillTimer(); }                      // deletes timer event processing

   //--- Service functions
   double            CountLotByRisk(int dist,double risk,double lot); // calculate lot by size of risk
   ulong             DealOpen(int dir,double lot,int SL,int TP);     // execute deal with specified parameters
   ulong             GetDealByOrder(ulong order);                     // get deal ticket by order ticket
   double            CountProfitByDeal(ulong ticket);                 // calculate profit by deal ticket

   //--- Type conversion macro
   int              BaseType(int dir);             // returns the base type of order for specified direction
   int              ReversType(int dir);           // returns the reverse type of order for specified direction
   int              StopType(int dir);             // returns the stop-order type for specified direction
   int              LimitType(int dir);            // returns the limit-order type for specified direction

   //--- Normalization macro
   double            NormalPrice(double d);          // normalization of price
   double            NormalDbl(double d, int n=-1);  // normalization of price per tick
   double            BasePrice(int dir);            // returns Bid/Ask price for specified direction
   double            ReversPrice(int dir);          // returns Bid/Ask price for reverse direction
   double            NormalOpen(int dir,double op,double stop); // normalization of pending order opening price
   double            NormalTP(int dir, double op, double pr, int TP, double stop); // normalization of Take Profit considering stop level and spread
   double            NormalSL(int dir, double op, double pr, int SL, double stop); // normalization of Stop Loss considering stop level and spread
   double            NormalLot(double lot);          // normalization of lot considering symbol properties

   //--- Info macro
   void              AddInfo(string st,bool ini=false);            // add string to comment parameter
   void              ErrorHandle(int err,ulong ticket,string str); // display error and description
  };
//------------------------------------------------------------------ CExpertAdvisor
void CExpertAdvisor::CExpertAdvisor()
  {
   initFlag=false;
  }
//------------------------------------------------------------------ ~CExpertAdvisor
void CExpertAdvisor::~CExpertAdvisor()
  {
  }
//------------------------------------------------------------------ Init
bool CExpertAdvisor::Init(long magic,string smb,ENUM_TIMEFRAMES tf)
  {
   this.magic=magic; symbol=smb; timeFrame=tf;     // set initializing parameters
   symbolInfor.Name(symbol);                  // initialize symbol
   point=symbolInfor.Point();                // calculate multiplier for 5/3 digit quote
   if(symbolInfor.Digits()==5 || symbolInfor.Digits()==3) point*=10; // 
   trade.SetExpertMagicNumber(magic); // set magic number for expert

   initFlag=true; return(true);            // trade allowed
  }
//--- Trade modules
//------------------------------------------------------------------ Main
bool CExpertAdvisor::Main() // Main module
  {
   if(!initFlag) return(false);
   if(!MQL5InfoInteger(MQL5_TRADE_ALLOWED) || !TerminalInfoInteger(TERMINAL_CONNECTED))
      return(false);                            // if trade is not possible, then exit
   comment="";                                    // reset information string
   symbolInfor.Refresh(); symbolInfor.RefreshRates(); // update symbol parameters
   return(true);
  }
//------------------------------------------------------------------ BEPositin
void CExpertAdvisor::BEPosition(int dir,int BE)
  {
   double sl,apr,csl,cop,ctp;
   if(!PositionSelect(symbol)) return;                       // if there is no positions or error, then exit
   symbolInfor.Refresh(); symbolInfor.RefreshRates();             // update symbol parameters
   double StopLvl=symbolInfor.StopsLevel()*symbolInfor.Point();   // Stop Level
   double FreezLvl=symbolInfor.FreezeLevel()*symbolInfor.Point(); // Freeze level
   apr=ReversPrice(dir);
   cop=NormalDbl(PositionGetDouble(POSITION_PRICE_OPEN));   // price of position opening
   csl=NormalDbl(PositionGetDouble(POSITION_SL));           // Stop Loss
   ctp=NormalDbl(PositionGetDouble(POSITION_TP));           // Take Profit
   if(MathAbs(ctp-apr)<=FreezLvl || MathAbs(csl-apr)<=FreezLvl) return;          // check freeze level
   sl=NormalPrice(dir==ORDER_TYPE_BUY ? cop+BE*point:cop-BE*point);              // calculate new value of Stop Loss
   if((dir==ORDER_TYPE_BUY && sl<apr+StopLvl && (sl>csl || csl==NormalPrice(0))) // check fulfillment of condition
      || (dir==ORDER_TYPE_SELL && sl>apr-StopLvl && (sl<csl || csl==NormalPrice(0))))
     {
      if(!trade.PositionModify(symbol,sl,ctp))             // modify Stop Loss 
         ErrorHandle(GetLastError(),PositionGetInteger(POSITION_IDENTIFIER),"-BEPosition ");
     }
  }
//------------------------------------------------------------------ TralPos
void CExpertAdvisor::TrailingPosition(int dir,int TS)
  {
   double sl,apr,csl,cop,ctp;
   if(TS<=0) return;
   if(!PositionSelect(symbol)) return;                       // if there is no positions or error, then exit
   symbolInfor.Refresh(); symbolInfor.RefreshRates();             // update symbol parameters
   double StopLvl=symbolInfor.StopsLevel()*symbolInfor.Point();   // Stop Level
   double FreezLvl=symbolInfor.FreezeLevel()*symbolInfor.Point(); // Freeze level
   apr=ReversPrice(dir);
   cop=NormalDbl(PositionGetDouble(POSITION_PRICE_OPEN));   // price of position opening
   csl=NormalDbl(PositionGetDouble(POSITION_SL));           // Stop Loss
   ctp=NormalDbl(PositionGetDouble(POSITION_TP));           // Take Profit
   if(MathAbs(ctp-apr)<=FreezLvl || MathAbs(csl-apr)<=FreezLvl) return;  // check freeze level
   sl=NormalSL(dir,apr,apr,TS,StopLvl);                     // calculate Stop Loss
   if((dir==ORDER_TYPE_BUY && apr-cop>TS*point && (sl>cop && (sl>csl || csl==NormalPrice(0)))) // check condition
      || (dir==ORDER_TYPE_SELL && cop-apr>TS*point && (sl<cop && (sl<csl || csl==NormalPrice(0)))))
     {
      if(!trade.PositionModify(symbol,sl,ctp))             // move Stop Loss to new place
         ErrorHandle(GetLastError(),PositionGetInteger(POSITION_IDENTIFIER),"-TrailingPosition ");
     }
  }
//--- Functions of getting signals/events
//------------------------------------------------------------------ CheckNewBar
bool CExpertAdvisor::CheckNewBar() // check new bar
  {
   MqlRates rt[2];
   if(CopyRates(symbol,timeFrame,0,2,rt)!=2) // copy bar
     { Print("CopyRates of ",symbol," failed, no history"); return(false); }
   if(rt[1].tick_volume>1) return(false); // check volume 
   return(true);
  }
//---------------------------------------------------------------   CheckTime
bool CExpertAdvisor::CheckTime(datetime start,datetime end)
  {
   datetime dt=TimeCurrent();                          // current time
   if(start<end) if(dt>=start && dt<end) return(true); // check if we are in the range
   if(start>=end) if(dt>=start|| dt<end) return(true);
   return(false);
  }
//--- Service functions
//---------------------------------------------------------------   CountLotByRisk
double CExpertAdvisor::CountLotByRisk(int dist,double risk,double lot) // calculate lot by size of risk
  {
   if(dist==0 || risk==0) return(lot);
   symbolInfor.Refresh();
   return(NormalLot(AccountInfoDouble(ACCOUNT_BALANCE)*risk/(dist*10*symbolInfor.TickValue())));
  }
//------------------------------------------------------------------	DealOpen
ulong CExpertAdvisor::DealOpen(int dir,double lot,int SL,int TP)
  {
   double op,sl,tp,apr,StopLvl;
// determine price parameters
   symbolInfor.RefreshRates(); symbolInfor.Refresh();
   StopLvl=symbolInfor.StopsLevel()*symbolInfor.Point(); // remember stop level
   apr=ReversPrice(dir); op=BasePrice(dir);        // open price
   sl=NormalSL(dir, op, apr, SL, StopLvl);         // Stop Loss
   tp=NormalTP(dir, op, apr, TP, StopLvl);         // Take Profit

                                                   // open position
   trade.PositionOpen(symbol,(ENUM_ORDER_TYPE)dir,lot,op,sl,tp);
   ulong order=trade.ResultOrder(); if(order<=0) return(0); // order ticket
   return(GetDealByOrder(order));                  // return deal ticket
  }
//---------------------------------------------------------------   GetDealByOrder
ulong CExpertAdvisor::GetDealByOrder(ulong order) // get deal ticket by order ticket
  {
   PositionSelect(symbol);
   HistorySelectByPosition(PositionGetInteger(POSITION_IDENTIFIER));
   uint total=HistoryDealsTotal();
   for(uint i=0; i<total; i++)
     {
      ulong deal=HistoryDealGetTicket(i);
      if(order==HistoryDealGetInteger(deal,DEAL_ORDER))
         return(deal);                            // remember deal ticket 
     }
   return(0);
  }
//---------------------------------------------------------------   CountProfit
double CExpertAdvisor::CountProfitByDeal(ulong ticket)// position profit by deal ticket
  {
   CDealInfo deal; deal.Ticket(ticket);               // deal ticket
   HistorySelect(deal.Time(),TimeCurrent());          // select all deals after this
   uint total=HistoryDealsTotal();
   long pos_id=deal.PositionId();                     // get position id
   double prof=0;
   for(uint i=0; i<total; i++)                        // find all deals with this id
     {
      ticket=HistoryDealGetTicket(i);
      if(HistoryDealGetInteger(ticket,DEAL_POSITION_ID)!=pos_id) continue;
      prof+=HistoryDealGetDouble(ticket,DEAL_PROFIT); // summarize profit
     }
   return(prof);                                      // return profit
  }
//--- Type conversion macro
//---------------------------------------------------------------   DIR
int CExpertAdvisor::BaseType(int dir)
  {
   if(dir==ORDER_TYPE_BUY || dir==ORDER_TYPE_BUY_STOP || dir==ORDER_TYPE_BUY_LIMIT) return(ORDER_TYPE_BUY);
   if(dir==ORDER_TYPE_SELL || dir==ORDER_TYPE_SELL_STOP || dir==ORDER_TYPE_SELL_LIMIT) return(ORDER_TYPE_SELL);
   return(-1);
  }
//------------------------------------------------------------------	ADIR
int CExpertAdvisor::ReversType(int dir)
  {
   if(dir==ORDER_TYPE_BUY || dir==ORDER_TYPE_BUY_STOP || dir==ORDER_TYPE_BUY_LIMIT) return(ORDER_TYPE_SELL);
   if(dir==ORDER_TYPE_SELL || dir==ORDER_TYPE_SELL_STOP || dir==ORDER_TYPE_SELL_LIMIT) return(ORDER_TYPE_BUY);
   return(-1);
  }
//---------------------------------------------------------------   SDIR
int CExpertAdvisor::StopType(int dir)
  {
   if(dir==ORDER_TYPE_BUY || dir==ORDER_TYPE_BUY_STOP || dir==ORDER_TYPE_BUY_LIMIT) return(ORDER_TYPE_BUY_STOP);
   if(dir==ORDER_TYPE_SELL || dir==ORDER_TYPE_SELL_STOP || dir==ORDER_TYPE_SELL_LIMIT) return(ORDER_TYPE_SELL_STOP);
   return(-1);
  }
//---------------------------------------------------------------   LDIR
int CExpertAdvisor::LimitType(int dir)
  {
   if(dir==ORDER_TYPE_BUY || dir==ORDER_TYPE_BUY_STOP || dir==ORDER_TYPE_BUY_LIMIT) return(ORDER_TYPE_BUY_LIMIT);
   if(dir==ORDER_TYPE_SELL || dir==ORDER_TYPE_SELL_STOP || dir==ORDER_TYPE_SELL_LIMIT) return(ORDER_TYPE_SELL_LIMIT);
   return(-1);
  }

//--- Normalization macro
//---------------------------------------------------------------   ND
double CExpertAdvisor::NormalDbl(double d,int n=-1) {  if(n<0) return(::NormalizeDouble(d,symbolInfor.Digits())); return(NormalizeDouble(d,n)); }
//---------------------------------------------------------------   NP
double CExpertAdvisor::NormalPrice(double d) { return(NormalDbl(MathRound(d/symbolInfor.TickSize())*symbolInfor.TickSize())); }
//---------------------------------------------------------------   NPR
double CExpertAdvisor::BasePrice(int dir)
  {
   if(dir==ORDER_TYPE_BUY) return(symbolInfor.Ask());
   if(dir==ORDER_TYPE_SELL) return(symbolInfor.Bid());
   return(WRONG_VALUE);
  }
//---------------------------------------------------------------   APR
double CExpertAdvisor::ReversPrice(int dir)
  {
   if(dir==ORDER_TYPE_BUY) return(symbolInfor.Bid());
   if(dir==ORDER_TYPE_SELL) return(symbolInfor.Ask());
   return(WRONG_VALUE);
  }
//---------------------------------------------------------------   NOP
double CExpertAdvisor::NormalOpen(int dir,double op,double stop)
  {
   if(dir==ORDER_TYPE_BUY_LIMIT) return(NormalPrice(MathMin(op,symbolInfor.Ask()-stop)));
   if(dir==ORDER_TYPE_BUY_STOP) return(NormalPrice(MathMax(op,symbolInfor.Ask()+stop)));
   if(dir==ORDER_TYPE_SELL_LIMIT) return(NormalPrice(MathMax(op,symbolInfor.Bid()+stop)));
   if(dir==ORDER_TYPE_SELL_STOP) return(NormalPrice(MathMin(op,symbolInfor.Bid()-stop)));
   return(WRONG_VALUE);
  }
//---------------------------------------------------------------   NTP
double CExpertAdvisor::NormalTP(int dir,double op,double pr,int TP,double stop)
  {
   if(TP==0) return(NormalPrice(0));
   if(dir==ORDER_TYPE_BUY || dir==ORDER_TYPE_BUY_STOP || dir==ORDER_TYPE_BUY_LIMIT) return(NormalPrice(MathMax(op+TP*point,pr+stop)));
   if(dir==ORDER_TYPE_SELL || dir==ORDER_TYPE_SELL_STOP || dir==ORDER_TYPE_SELL_LIMIT) return(NormalPrice(MathMin(op-TP*point,pr-stop)));
   return (WRONG_VALUE);
  }
//---------------------------------------------------------------   NSL
double CExpertAdvisor::NormalSL(int dir,double op,double pr,int SL,double stop)
  {
   if(SL==0) return(NormalPrice(0));
   if(dir==ORDER_TYPE_BUY || dir==ORDER_TYPE_BUY_STOP || dir==ORDER_TYPE_BUY_LIMIT) return(NormalPrice(MathMin(op-SL*point,pr-stop)));
   if(dir==ORDER_TYPE_SELL || dir==ORDER_TYPE_SELL_STOP || dir==ORDER_TYPE_SELL_LIMIT) return(NormalPrice(MathMax(op+SL*point,pr+stop)));
   return (WRONG_VALUE);
  }
//---------------------------------------------------------------   NL
double CExpertAdvisor::NormalLot(double lot)
  {
   int k=0;
   double ll=lot,ls=symbolInfor.LotsStep();
   if(ls<=0.001) k=3; else if(ls<=0.01) k=2; else if(ls<=0.1) k=1;
   ll=NormalDbl(MathMin(symbolInfor.LotsMax(),MathMax(symbolInfor.LotsMin(),ll)),k);
   return(ll);
  }
//--- Information functions
//---------------------------------------------------------------   INF
void CExpertAdvisor::AddInfo(string st,bool ini=false)
  {
   string zn="\n      ",zzn="\n               ";
   if(ini) comment=comment+zn+st; else comment=comment+zzn+st;
  }
//---------------------------------------------------------------   ErrorHandle
void CExpertAdvisor::ErrorHandle(int err,ulong ticket,string str)
  {
   Print("-Err(",err,") ",magic," #",ticket," | "+str);
   switch(err)
     {
      case TRADE_RETCODE_REJECT:
      case TRADE_RETCODE_TOO_MANY_REQUESTS:
         Sleep(2000);        // wait 2 seconds
         break;

      case TRADE_RETCODE_PRICE_OFF:
      case TRADE_RETCODE_PRICE_CHANGED:
      case TRADE_RETCODE_REQUOTE:
         symbolInfor.Refresh(); // refresh symbol info
         symbolInfor.RefreshRates();
         break;
     }
  }
//+------------------------------------------------------------------+

