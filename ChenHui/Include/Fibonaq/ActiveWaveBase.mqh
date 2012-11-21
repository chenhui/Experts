//+------------------------------------------------------------------+
//|                                               ActiveWaveBase.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include ".\Inflexion.mqh"
#include ".\Peaks.mqh"
#include ".\Ultras.mqh"
#include "..\Symbol\ChSymbolInfo.mqh"
#include ".\CallBackChecker.mqh"
#include ".\AmplitudeChecker.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ActiveWaveBase
{
protected:
   int noExisted;
   //int amplitude;
   double callbackRadio;
   Peaks       *upPeaks;
   Peaks       *downPeaks;
   Ultras      *upUltras;
   Ultras      *downUltras;
      
   Inflexions  *upInflexions;
   Inflexions  *downInflexions; 
   ChSymbolInfo *symbolInfo; 

   AmplitudeChecker *amplitudeChecker;
   CallBackChecker *upDownCallBackChecker;
   CallBackChecker *downUpCallBackChecker;
public:
   ActiveWaveBase()
   {
      noExisted=-1;
      callbackRadio=0.382;
      upPeaks=new UpPeaks;
      downPeaks=new DownPeaks;
      upUltras=new UpUltras;
      downUltras=new DownUltras;
      
      upInflexions=new UpInflexions;
      downInflexions=new DownInflexions;
      symbolInfo=new ChSymbolInfo;
      
      amplitudeChecker=new AmplitudeChecker;     
      upDownCallBackChecker=new UpDownCallBackChecker;
      downUpCallBackChecker=new DownUpCallBackChecker;
      
   };
   
   ~ActiveWaveBase()
   {
      if (upPeaks!=NULL)   delete upPeaks;
      if (downPeaks!=NULL) delete downPeaks;
      if (upUltras!=NULL) delete upUltras;
      if (downUltras!=NULL) delete downUltras;
      
      if (upInflexions!=NULL) delete upInflexions;
      if (downInflexions!=NULL) delete downInflexions;
      if (symbolInfo!=NULL) delete symbolInfo;
      if (amplitudeChecker!=NULL) delete amplitudeChecker;   
      if (upDownCallBackChecker!=NULL) delete upDownCallBackChecker;
      if (downUpCallBackChecker!=NULL) delete downUpCallBackChecker;
   };
   
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int thresholdOut,int depthOut=12)
   {
      return (  symbolInfo.Init(symbolOut)
             && upUltras.Init(symbolOut,timeFrameOut)
             && downUltras.Init(symbolOut,timeFrameOut)
             && upPeaks.Init(symbolOut,timeFrameOut)
             && downPeaks.Init(symbolOut,timeFrameOut)
             && upInflexions.Init(symbolOut,timeFrameOut)
             && downInflexions.Init(symbolOut,timeFrameOut)
             && amplitudeChecker.Init(symbolOut,timeFrameOut,thresholdOut)
             && upDownCallBackChecker.Init(symbolOut,timeFrameOut,callbackRadio)
             && downUpCallBackChecker.Init(symbolOut,timeFrameOut,callbackRadio));
   }
   
   void ShowInflexions(int range)
   {
   Alert("---------------up range-----------------");
   upInflexions.Show(0,range);
   Alert("---------------up range-----------------");
      
   Alert("---------------dwon range-----------------");
   downInflexions.Show(0,range);  
   Alert("---------------dwon range-----------------"); 
   }
   
   virtual int StartIndex(int index=0)
   {  
      return (EndIndex()!=noExisted) ? GetPeaks().IndexOfNear(index):noExisted;
   }
   
   virtual double StartValue(int index=0)
   {
      return GetStartInflexion().ValueOf(StartIndex(index));
   };
   
   virtual int EndIndex(int index=0){return (noExisted);}

   virtual double EndValue(int index=0)
   {
      return GetEndInflexion().ValueOf(EndIndex(index));
   };
      

protected:
  
   virtual Peaks *GetPeaks(){return NULL;};
   virtual Ultras *GetUltras(){return NULL;};
   virtual CallBackChecker *GetCallBackChecker(){return NULL;};
   virtual Inflexions *GetStartInflexion(){return NULL;}
   virtual Inflexions *GetEndInflexion(){return NULL;}
   
   int IndexOfCentrePeak(int index)
   {      
      return (GetPeaks().IndexOfNear(index));
   }

   
   bool IsExistUltra(int suspendEndIndex,int index)
   {
      return (GetUltras().ValueOf(suspendEndIndex,index)!=noExisted);     
   }
    
};