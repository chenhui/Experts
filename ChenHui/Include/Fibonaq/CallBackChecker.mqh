//+------------------------------------------------------------------+
//|                                              CallBackChecker.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include ".\Inflexion.mqh"
#include ".\Peaks.mqh"
#include "..\Symbol\ChSymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class CallBackChecker
{
protected:
   int noExisted;
   double radio;
   Ultras      *upUltras;
   Ultras      *downUltras;     
   Inflexions  *upInflexions;
   Inflexions  *downInflexions; 
   ChSymbolInfo *symbolInfo;
   bool IsExistUltra(int suspendEndIndex,int index)
   {
      return (GetUltras().ValueOf(suspendEndIndex,index)!=noExisted);     
   }
   
   bool CallBack382(int suspendStartIndex,int suspendEndIndex,int index)
   {
      return  (CallBackPoints(suspendEndIndex,index)*1000/WavePoints(suspendStartIndex,suspendEndIndex)>radio*1000);      
   }
   int PointsOf(double value)
   {
      return MathAbs(value/symbolInfo.PointValue());
   }
   
   virtual Ultras *GetUltras(){return NULL;};
   virtual int WavePoints(int suspendStartIndex,int suspendEndIndex){return 0;};
   virtual int CallBackPoints(int suspendEndIndex,int index){return 0;}; 
   
public:
   CallBackChecker()
   {
      this.noExisted=-1;
      upUltras=new UpUltras;
      downUltras=new DownUltras;
      upInflexions=new UpInflexions;
      downInflexions=new DownInflexions;
      symbolInfo=new ChSymbolInfo;
   };
   
   ~CallBackChecker()
   {
      if (upUltras!=NULL) delete upUltras;
      if (downUltras!=NULL) delete downUltras;      
      if (upInflexions!=NULL) delete upInflexions;
      if (downInflexions!=NULL) delete downInflexions;
      if (symbolInfo!=NULL) delete symbolInfo;
   };
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,double RadioOut)
   {
      this.radio=RadioOut;
      return (  upUltras.Init(symbolOut,timeFrameOut) 
             && downUltras.Init(symbolOut,timeFrameOut)
             && upInflexions.Init(symbolOut,timeFrameOut)
             && downUltras.Init(symbolOut,timeFrameOut)
             && symbolInfo.Init(symbolOut));
   }  
   bool IsOk(int suspendStartIndex,int suspendEndIndex,int index)
   {
      return (  IsExistUltra(suspendEndIndex,index)
             && (CallBack382(suspendStartIndex,suspendEndIndex,index)));
   }

};

class UpDownCallBackChecker:public CallBackChecker
{
protected:
   
   Ultras *GetUltras(){return upUltras;}

public:
   UpDownCallBackChecker(){};
   ~UpDownCallBackChecker(){};
   
   virtual int WavePoints(int suspendStartIndex,int suspendEndIndex)
   {
      return PointsOf((upInflexions.ValueOf(suspendStartIndex)-downInflexions.ValueOf(suspendEndIndex)));
   }
   
   virtual int CallBackPoints(int suspendEndIndex,int index)
   {
      return PointsOf(upUltras.ValueOf(suspendEndIndex,index)-downInflexions.ValueOf(suspendEndIndex));
   }
     
};


class DownUpCallBackChecker:public CallBackChecker
{
protected:
   
   Ultras *GetUltras(){return downUltras;}

public:
   DownUpCallBackChecker(){};
   ~DownUpCallBackChecker(){};
   
   virtual int WavePoints(int suspendStartIndex,int suspendEndIndex)
   {
      return PointsOf((downInflexions.ValueOf(suspendStartIndex)-upInflexions.ValueOf(suspendEndIndex)));
   }
   
   virtual int CallBackPoints(int suspendEndIndex,int index)
   {
      return PointsOf(downUltras.ValueOf(suspendEndIndex,index)-upInflexions.ValueOf(suspendEndIndex));
   }
     
};


//------------------------------------------------------------------------------------+
