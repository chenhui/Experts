//+------------------------------------------------------------------+
//|                                                    FibonaqBaseExpert.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "../Fibonaq/FibonaqOpenSignal.mqh"
#include "../Fibonaq/FibonaqOpen.mqh"
#include "../Symbol/AllSymbol.mqh"
#include "../Fibonaq/FibonaqCloseBuilder.mqh"
#include "../Fibonaq/FibonaqClose.mqh"
#include "../Fibonaq/FibonaqCloseSignal.mqh"
#include "../Stoploss/IPrimaryStoplossBuilder.mqh"
#include "../Fibonaq/FibonaqPrimaryStoplossBuilder.mqh"
#include "../Expert/IExpert.mqh"

class FibonaqBaseExpert:public BaseExpert
{
   protected:
      void virtual OneOpenSignal(string symbol);
      void virtual OneOpen(string symbol);
      void virtual AllPrimaryStoploss();      

   public:
   
      void FibonaqBaseExpert();
      void ~FibonaqBaseExpert();
      void virtual OneMain(string symbol);
      void virtual AllMain();   
};

void FibonaqBaseExpert::FibonaqBaseExpert(void)
{
}

void FibonaqBaseExpert::~FibonaqBaseExpert(void)
{
}

void FibonaqBaseExpert::AllMain(void)
{
   AllBase();
   //AllClose();
}

void FibonaqBaseExpert::OneMain(string symbol)
{
   OneBase(symbol);
   //AllClose();
}

void FibonaqBaseExpert::OneOpenSignal(string symbol)
{ 
   DoOpenSignalBy(symbol,new FibonaqOpenLongSignalInDownActiveWave);
   DoOpenSignalBy(symbol,new FibonaqOpenLongSignalInUpActiveWave);
   DoOpenSignalBy(symbol,new FibonaqOpenShortSignalInDownActiveWave);
   DoOpenSignalBy(symbol,new FibonaqOpenShortSignalInUpActiveWave);
   
}

void FibonaqBaseExpert::OneOpen(string symbol)
{
   DoOpenBy(symbol,new FibonaqOpenLongPositionInUpActiveWave);
   DoOpenBy(symbol,new FibonaqOpenLongPositionInDownActiveWave);
   DoOpenBy(symbol,new FibonaqOpenShortPositionInUpActiveWave);
   DoOpenBy(symbol,new FibonaqOpenShortPositionInDownActiveWave);
}


//--------------------------------------------------------------------

void FibonaqBaseExpert::AllPrimaryStoploss()
{
   DoPrimaryStoplossBy(new FibonaqPositionLongPrimaryStoplossBuilder);
   DoPrimaryStoplossBy(new FibonaqPositionShortPrimaryStoplossBuilder);
}

class FibonaqExpert:public BaseExpert
{
   protected:

      IExpert  *baseExpert;
      
      void AllCloseSignal();
      void OneCloseSignal(string symbol);
      void DoCloseSignalBy(string symbol,ICloseSignal *closeSignal);
   
      void AllClose();
      void DoCloseBy(ICloseBuilder *builder,ICloseSignal *closeSignal);      

   public:
      void FibonaqExpert();
      void ~FibonaqExpert();
      bool virtual Init(int magicNumber,string comment,ENUM_TIMEFRAMES timeFrame,
                        int primaryStoploss,double lots,int trailStoploss=0,
                        double partLots=0,int planThreshold=0,
                        int startDay=0,int startHour=0,int endDay=0,int endHour=0);         
      void virtual OneMain(string symbol);
      void virtual AllMain();        

};

void FibonaqExpert::FibonaqExpert(void)
{
   baseExpert=new FibonaqBaseExpert;
}

void FibonaqExpert::~FibonaqExpert(void)
{
   if (baseExpert!=NULL)  delete baseExpert;
}

bool FibonaqExpert::Init(int magicNumber,string comment,ENUM_TIMEFRAMES timeFrame,
                        int primaryStoploss,double lots,int trailStoploss=0,
                        double partLots=0,int planThreshold=0,
                        int startDay=0,int startHour=0,int endDay=0,int endHour=0)
{
   return (   BaseExpert::Init(magicNumber,comment,timeFrame,primaryStoploss,lots,
                               startDay,startHour,endDay,endHour)
           && baseExpert.Init(this.magicNumber,this.comment,this.timeFrame,
                              this.primaryStoploss,this.lots,this.startDay,
                              this.startHour,this.endDay,this.endHour)
          );
}


void FibonaqExpert::AllMain(void)
{
   baseExpert.AllMain();
   AllCloseSignal();
   AllClose();
   
}

void FibonaqExpert::OneMain(string symbol)
{
   baseExpert.OneMain(symbol);
   AllCloseSignal();
   AllClose();
}


void FibonaqExpert::AllCloseSignal()
{
   for(int index=0;index<allSymbols.Total();index++)
   {     
      OneCloseSignal(allSymbols.At(index));
   }

}

void FibonaqExpert::OneCloseSignal(string symbol)
{
   DoCloseSignalBy(symbol,new FibonaqCloseLongSignalInDownActiveWave);
   DoCloseSignalBy(symbol,new FibonaqCloseLongSignalInUpActiveWave);
   DoCloseSignalBy(symbol,new FibonaqCloseShortSignalInDownActiveWave);
   DoCloseSignalBy(symbol,new FibonaqCloseShortSignalInUpActiveWave);

}

void FibonaqExpert::DoCloseSignalBy(string symbol,ICloseSignal *closeSignal)
{
   closeSignal.Init(symbol,this.timeFrame);
   closeSignal.Main();
   if (closeSignal!=NULL )  delete closeSignal;
   closeSignal=NULL;

}
   
void FibonaqExpert::AllClose()
{
   DoCloseBy(new FibonaqCloseLongInUpActiveWaveBuilder,new FibonaqCloseLongSignalInUpActiveWave);
   DoCloseBy(new FibonaqCloseLongInDownActiveWaveBuilder,new FibonaqCloseLongSignalInDownActiveWave);
   DoCloseBy(new FibonaqCloseShortInUpActiveWaveBuilder,new FibonaqCloseShortSignalInUpActiveWave);
   DoCloseBy(new FibonaqCloseShortInDownActiveWaveBuilder,new FibonaqCloseShortSignalInDownActiveWave);

}

void FibonaqExpert::DoCloseBy(ICloseBuilder *builder,ICloseSignal *closeSignal)
{
   IClose *close=builder.Create();
   close.Init(closeSignal);
   close.Main();
   delete closeSignal;
   delete close;
   delete builder;
}


