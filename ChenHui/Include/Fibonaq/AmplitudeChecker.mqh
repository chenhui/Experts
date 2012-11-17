//+------------------------------------------------------------------+
//|                                             AmplitudeChecker.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include ".\Inflexion.mqh"
#include "..\Symbol\ChSymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AmplitudeChecker
{
private:
   int amplitude;
   Inflexions *upInflexions;
   Inflexions *downInflexions;
   ChSymbolInfo *symbolInfo;
public:
   AmplitudeChecker()
   {
      upInflexions=new UpInflexions;
      downInflexions=new DownInflexions;
      symbolInfo=new ChSymbolInfo;
   }
   ~AmplitudeChecker()
   {
      if (upInflexions!=NULL) delete upInflexions;
      if (downInflexions!=NULL) delete downInflexions;
      if (symbolInfo!=NULL) delete symbolInfo;
   }
   
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut)
   {
      return symbolInfo.Init(symbolOut) && upInflexions.Init(symbolOut,timeFrameOut) 
             && downInflexions.Init(symbolOut,timeFrameOut);
   }
   
   bool IsExceed(int upIndex,int downIndex)
   {
      return  (PointsOfWave(upIndex,downIndex)>PointsOfWave(downIndex,upIndex)) ?
              (PointsOfWave(upIndex,downIndex)>amplitude):(PointsOfWave(downIndex,upIndex)>amplitude);
   }
   
private:
  
   int PointsOfWave(int upIndex,int downIndex)
   {   
      return MathAbs(PointsOf(upInflexions.ValueOf(upIndex)-downInflexions.ValueOf(downIndex)));
   }
   
   int PointsOf(double value)
   {
      return MathAbs(value/symbolInfo.PointValue());
   }    

};

