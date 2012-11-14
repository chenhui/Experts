//+------------------------------------------------------------------+
//|                                                   ExpertBase.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\Include\Trade\ChSymmetryTrade.mqh"
#include "..\..\Include\Time\TimeSection.mqh"
#include "..\Stoploss\PrimaryStoplossCalculate.mqh"
#include "..\Signals\ISignal.mqh"

//-------------------------------------------------------------------

class SymmetryBase
{
   protected:
      ulong magicNumber;
      string symbol;
      double lots;
      ENUM_TIMEFRAMES  timeFrame;
      ChSymmetryTrade   *trade;
      ISignal           *signal;
      TimeSectionChecker *timeChecker;
      IStoplosser      *stoplosser;
      
      bool IsTimeInOpenSections()
      {
         return timeChecker.IsTimeInSections(TimeCurrent());
      }

      void WhenCloseSellSignalIsTrue()
      {
         if (signal.CloseSellCondition() && trade.IsSellPositionExist() && trade.CloseSellPosition() )
            Alert(symbol," close sell condition is true  and close sell position !");
      }


      void WhenCloseBuySignalIsTrue()
      {
         if (signal.CloseBuyCondition() && trade.IsBuyPositionExist() && trade.CloseBuyPosition() )
            Alert(symbol," close buy condition is true  and close buy position !");
      }
      
      virtual void WhenOpenBuySignalIsTrue()
      {
         if (!IsTimeInOpenSections())  return;
         if (  signal.OpenBuyCondition() 
            && !trade.IsBuyPositionExist()
            && !trade.IsSellPositionExist() 
            && trade.OpenBuyPositionWith(stoplosser.BuyStoploss()))
            Alert(symbol," open buy conditin is true and open buy position and primary stoploss ! " ); 
      }
      
      
      virtual void WhenOpenSellSignalIsTrue()
      {
         if (!IsTimeInOpenSections())  return;
         if (  signal.OpenSellCondition() 
            && !trade.IsSellPositionExist()
            && !trade.IsBuyPositionExist() 
            && trade.OpenSellPositionWith(stoplosser.SellStoploss()))
            Alert(symbol," open sell conditin is true and open sell position and primary stoploss ! ");  
      }

      
   public:
      SymmetryBase(){};
      
      ~SymmetryBase()
      {
         if (signal!=NULL)       delete signal;
         if (timeChecker!=NULL)  delete timeChecker;
         if (trade!=NULL)        delete trade;
         if (stoplosser!=NULL)   delete stoplosser;
      }  
          
      bool Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,ISignal *signalOut,TimeSectionChecker *timeCheckerOut,IStoplosser *stoplosserOut)
      {
         this.magicNumber=magicNumberOut;
         this.symbol=symbolOut;
         this.timeFrame=timeFrameOut;
         this.lots=lotsOut;
         this.signal=signalOut;
         this.timeChecker=timeCheckerOut;
         this.stoplosser=stoplosserOut;
         this.trade=new ChSymmetryTrade;
         return (trade.Init(magicNumber,symbol,lots));
      }
            
      virtual void Main(void)
      {
         WhenCloseSellSignalIsTrue();
         WhenCloseBuySignalIsTrue();
         WhenOpenSellSignalIsTrue();
         WhenOpenBuySignalIsTrue();  
      }
      
};


//--------------------------------------------------------------------
class Symmetry:public SymmetryBase
{          
   public:
      void Symmetry(){};
      void ~Symmetry(){};
};




//-------------------------------------------------------------------------------+
class SymmetryInDay:public SymmetryBase
{
   protected:
   
      TimeSectionChecker *cleanTimeChecker;     
      bool IsTimeInCleanSections();     
      void WhenTimeIsInCleanSection();    

      virtual void WhenOpenSellSignalIsTrue();
      virtual void WhenOpenBuySignalIsTrue();
      
      
   public:
      void SymmetryInDay(){};
      void ~SymmetryInDay();
      virtual bool Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,
            double lotsOut,ISignal *signalOut,TimeSectionChecker* openTimeCheckerOut,
            TimeSectionChecker *cleanTimeCheckerOut,IStoplosser *stoplosserOut);
      virtual void Main();
};

bool SymmetryInDay::Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double lotsOut,ISignal *signalOut,TimeSectionChecker *timeCheckerOut,TimeSectionChecker *cleanTimeCheckerOut,IStoplosser *stoplosserOut)
{

   this.cleanTimeChecker=cleanTimeCheckerOut;
   return SymmetryBase::Init(magicNumberOut,symbolOut,timeFrameOut,lotsOut,signalOut,timeCheckerOut,stoplosserOut);

}

void SymmetryInDay::~SymmetryInDay(void)
{
   if (cleanTimeChecker!=NULL) delete cleanTimeChecker;
}

void SymmetryInDay::Main(void)
{
   WhenTimeIsInCleanSection();
   SymmetryBase::Main();
   
}

void SymmetryInDay::WhenTimeIsInCleanSection()
{
   if (IsTimeInCleanSections())
   {
      trade.CloseBuyPosition();
      trade.CloseSellPosition();
   }
}

void SymmetryInDay::WhenOpenBuySignalIsTrue()
{
   if (IsTimeInCleanSections())  return;
   SymmetryBase::WhenOpenBuySignalIsTrue(); 
}


void SymmetryInDay::WhenOpenSellSignalIsTrue()
{
   if (IsTimeInCleanSections())  return;
   SymmetryBase::WhenOpenSellSignalIsTrue();  
}

bool SymmetryInDay::IsTimeInCleanSections(void)
{
   return cleanTimeChecker.IsTimeInSections(TimeCurrent());
}





