//+------------------------------------------------------------------+
//|                                                   ActiveWave.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include ".\Inflexion.mqh"
#include ".\Peaks.mqh"
#include "..\Symbol\ChSymbolInfo.mqh"
#include ".\CallBackChecker.mqh"

class ActiveWaveBase
{
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
      if (upDownCallBackChecker!=NULL) delete upDownCallBackChecker;
      if (downUpCallBackChecker!=NULL) delete downUpCallBackChecker;
   };
   
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int amplitudeOut,int depthOut=12)
   {
      this.amplitude=amplitudeOut;
      symbolInfo.Init(symbolOut);
      return (  upUltras.Init(symbolOut,timeFrameOut)
             && downUltras.Init(symbolOut,timeFrameOut)
             && upPeaks.Init(symbolOut,timeFrameOut)
             && downPeaks.Init(symbolOut,timeFrameOut)
             && upInflexions.Init(symbolOut,timeFrameOut)
             && downInflexions.Init(symbolOut,timeFrameOut)
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
   int noExisted;
   int amplitude;
   double callbackRadio;
   Peaks       *upPeaks;
   Peaks       *downPeaks;
   Ultras      *upUltras;
   Ultras      *downUltras;
      
   Inflexions  *upInflexions;
   Inflexions  *downInflexions; 
   ChSymbolInfo *symbolInfo; 

   CallBackChecker *upDownCallBackChecker;
   CallBackChecker *downUpCallBackChecker;
   
   virtual Peaks *GetPeaks(){return NULL;};
   virtual Ultras *GetUltras(){return NULL;};
   virtual CallBackChecker *GetCallBackChecker(){return NULL;};
   virtual Inflexions *GetStartInflexion(){return NULL;}
   virtual Inflexions *GetEndInflexion(){return NULL;}
   
   int IndexOfCentrePeak(int index)
   {      
      return (GetPeaks().IndexOfNear(index));
   }
   
   int PointsOf(double value)
   {
      return MathAbs(value/symbolInfo.PointValue());
   } 
   
   bool IsExceedThreshold(int upIndex,int downIndex)
   {
      return  (PointsOfWave(upIndex,downIndex)>PointsOfWave(downIndex,upIndex)) ?
              (PointsOfWave(upIndex,downIndex)>amplitude):(PointsOfWave(downIndex,upIndex)>amplitude);
   }
   
   int PointsOfWave(int upIndex,int downIndex)
   {   
      return MathAbs(PointsOf(upInflexions.ValueOf(upIndex)-downInflexions.ValueOf(downIndex)));
   }
   
   bool IsExistUltra(int suspendEndIndex,int index)
   {
      return (GetUltras().ValueOf(suspendEndIndex,index)!=noExisted);     
   }
    
};

class ZeroTo1ActiveWave:public ActiveWaveBase
{

public:
   ZeroTo1ActiveWave(){};
   ~ZeroTo1ActiveWave(){};
   
   virtual int EndIndex(int index=0)
   {
      int suspendStartIndex=IndexOfCentrePeak(index);
      int suspendEndIndex=GetUltras().IndexOf(index,suspendStartIndex);
      while(IsExceedThreshold(suspendStartIndex,suspendEndIndex) && (suspendStartIndex>suspendEndIndex) && (suspendEndIndex!=noExisted))
      {
         if (GetCallBackChecker().IsOk(suspendStartIndex,suspendEndIndex,index)) return (suspendEndIndex);
         suspendEndIndex=GetUltras().IndexOf(suspendEndIndex+1,suspendStartIndex);
      }
      return (noExisted);         
   }
         
};

class ZeroTo1UpPeakActiveWave:public ZeroTo1ActiveWave
{
protected:

   
   Peaks *GetPeaks(){return upPeaks;}
   Ultras *GetUltras(){return downUltras;}
   virtual CallBackChecker *GetCallBackChecker(){return upDownCallBackChecker;}
   virtual Inflexions *GetStartInflexion(){return upInflexions;}
   virtual Inflexions *GetEndInflexion(){return downInflexions;}

public:
   ZeroTo1UpPeakActiveWave(){};
   ~ZeroTo1UpPeakActiveWave(){};
     
};

class ZeroTo1DownPeakActiveWave:public ZeroTo1ActiveWave
{
protected:

   virtual Peaks *GetPeaks(){return downPeaks;}
   virtual Ultras *GetUltras(){return upUltras;}
   virtual Inflexions *GetStartInflexion(){return downInflexions;}
   virtual Inflexions *GetEndInflexion(){return upInflexions;}
   virtual CallBackChecker *GetCallBackChecker(){return downUpCallBackChecker;}

public:
   ZeroTo1DownPeakActiveWave(){};
   ~ZeroTo1DownPeakActiveWave(){};
};

class LeftActiveWave:public ActiveWaveBase
{
public:
   LeftActiveWave(){};
   ~LeftActiveWave(){};
   
   virtual int EndIndex(int index=0)
   {
      int startIndex=IndexOfCentrePeak(index);
      int possibleEndIndex=IndexOfNextCentrePeak(index);
      int nextPeakIndex=GetPeaks().IndexOfNear(startIndex);
      while (possibleEndIndex>nextPeakIndex)
      {
         if (HasActiveWaveBetween(startIndex,nextPeakIndex)) return IndexOfActiveWaveBetween(startIndex,nextPeakIndex);
         nextPeakIndex=GetPeaks().IndexOfNear(nextPeakIndex);
      }
      if (IsExceedThreshold(startIndex,possibleEndIndex))  return (possibleEndIndex);
      return (-1);   
   }
protected:
   int IndexOfNextCentrePeak(int index)
   {
      int centrePeak=IndexOfCentrePeak(index);
      if (IsExceedThreshold(centrePeak,IndexOfNextCounterPeak(centrePeak)))  
         return (IndexOfNextCounterPeak(centrePeak));
      return (-1);  
   }  
   virtual int IndexOfNextCounterPeak(int peakIndex){return (-1);}
   
   bool HasActiveWaveBetween(int startIndex,int nextPeakIndex)
   {
      return (IsExceedThreshold(startIndex,GetUltras().IndexOf(startIndex,nextPeakIndex)));
   }
   
   int IndexOfActiveWaveBetween(int startIndex,int nextPeakIndex)
   {
      return GetUltras().IndexOf(startIndex,nextPeakIndex);
   }
};

class UpPeakLeftActiveWave:public LeftActiveWave
{

public:
   UpPeakLeftActiveWave(){}
   ~UpPeakLeftActiveWave(){}
      
protected:
   Peaks *GetPeaks(){return upPeaks;}
   Ultras *GetUltras(){return downUltras;}  
   virtual Inflexions *GetStartInflexion(){return upInflexions;}
   virtual Inflexions *GetEndInflexion(){return downInflexions;}
   virtual int IndexOfNextCounterPeak(int peakIndex)
   {
      return downPeaks.IndexOfNear(peakIndex);
   }
};
//----------------------------------------------------down active wave---------------------------------
class DownPeakLeftActiveWave:public LeftActiveWave
{

public:
   DownPeakLeftActiveWave(){}
   ~DownPeakLeftActiveWave(){}
      
protected:
   Peaks *GetPeaks(){return downPeaks;}
   Ultras *GetUltras(){return upUltras;}  
   virtual Inflexions *GetStartInflexion(){return downInflexions;}
   virtual Inflexions *GetEndInflexion(){return upInflexions;}

   virtual int IndexOfNextCounterPeak(int peakIndex)
   {
      return upPeaks.IndexOfNear(peakIndex);
   }
   
};
//----------------------------------------------------nearest active wave-----------------------------
class NearestActiveWave
{
public:

   NearestActiveWave()
   {
      noExisted=-1;
      zeroUpActiveWave=new ZeroTo1UpPeakActiveWave;
      zeroDownActiveWave=new ZeroTo1DownPeakActiveWave;
      upPeakActiveWave=new UpPeakLeftActiveWave;
      downPeakActiveWave=new DownPeakLeftActiveWave;
   };
   
   ~NearestActiveWave()
   {
      if (zeroUpActiveWave!=NULL) delete zeroUpActiveWave;
      if (zeroDownActiveWave!=NULL) delete zeroDownActiveWave;
      if (upPeakActiveWave!=NULL) delete upPeakActiveWave;
      if (downPeakActiveWave!=NULL) delete downPeakActiveWave;
   };
   
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int amplitudeOut,int depthOut=12)
   {
      this.symbol=symbolOut;
      this.timeFrame=timeFrameOut;
      this.amplitude=amplitudeOut;
      this.depth=depthOut; 
      return ( zeroUpActiveWave.Init(symbol,timeFrame,amplitude,depth) 
            && zeroDownActiveWave.Init(symbol,timeFrame,amplitude,depth)
            && upPeakActiveWave.Init(symbol,timeFrame,amplitude,depth)
            && downPeakActiveWave.Init(symbol,timeFrame,amplitude,depth));
   
   }
   
   int StartIndex()
   {  
      int zeroUpStart=zeroDownActiveWave.StartIndex();
      int zeroDownStart=zeroUpActiveWave.StartIndex();
      if (zeroUpStart!=noExisted && zeroDownStart==noExisted)  return (zeroUpStart);
      if (zeroDownStart!=noExisted && zeroUpStart==noExisted)  return (zeroDownStart);
      if (zeroUpStart!=noExisted && zeroDownStart!=noExisted) return (zeroUpStart<=zeroDownStart)?zeroUpStart:zeroDownStart;
      return (noExisted);
   }
   
   int EndIndex()
   {
      int zeroUpEnd=zeroDownActiveWave.EndIndex();
      int zeroDownEnd=zeroUpActiveWave.EndIndex();
      if (zeroUpEnd!=noExisted && zeroDownEnd==noExisted)  return (zeroUpEnd);
      if (zeroDownEnd!=noExisted && zeroUpEnd==noExisted)  return (zeroDownEnd);
      if (zeroUpEnd!=noExisted && zeroDownEnd!=noExisted) return (zeroUpEnd<=zeroDownEnd)?zeroUpEnd:zeroDownEnd;
      return (noExisted);
   }
   
private:
   int noExisted;
   string symbol;
   ENUM_TIMEFRAMES timeFrame;
   int    amplitude;
   int    depth;
   ActiveWaveBase *zeroUpActiveWave;
   ActiveWaveBase *zeroDownActiveWave;
   ActiveWaveBase *upPeakActiveWave;
   ActiveWaveBase *downPeakActiveWave;
   
};

//----------------------------------------------------old active wave---------------------------------
//class ActiveWave:public ActiveWaveBase
//{
//
//public:
//   ActiveWave(){}
//   
//   ~ActiveWave(){}
//   
//   double ValueOfUp(int index)
//   {
//      return upInflexions.ValueOf(index);  
//   }
//   
//   double ValueOfDown(int index)
//   {
//      return downInflexions.ValueOf(index);
//   }
//   
//   bool IsAmplitudeExisted(int start,int end)
//   {
//      int indexOfNearPeak=IndexOfCentrePeak(start);
//      if (indexOfNearPeak>end)  return (false);
//      if (upPeaks.IsPossible(indexOfNearPeak))  
//      {
//         int indexOfNearUltra=downUltras.IndexOf(start,indexOfNearPeak);
//         if (IsExceedThreshold(indexOfNearPeak,indexOfNearUltra))   return (true);
//      }
//      if (downPeaks.IsPossible(indexOfNearPeak))
//      {
//         int indexOfNearUltra=upUltras.IndexOf(start,indexOfNearPeak);
//         if (IsExceedThreshold(indexOfNearPeak,indexOfNearUltra))   return (true);        
//      }
//      return (false);
//      
//   }
//   
//   
//   int IndexOfPossibleStart()
//   {
//      return IndexOfNextUltra(0);
//   } 
//
//   int FindEndIndexLeft(int index)
//   {
//      if (upPeaks.IsPossible(IndexOfCentrePeak(index)))  return FindEndIndexLeftUpPeak(index);
//      if (downPeaks.IsPossible(IndexOfCentrePeak(index))) return FindEndIndexLeftDownPeak(index);
//      return 0;
//   } 
//   
//   int FindEndIndexLeftUpPeak(int index)
//   {
//      int startIndex=IndexOfCentrePeak(index);
//      int possibleEndIndex=IndexOfNextCentrePeak(index);
//      int nextPeakIndex=upPeaks.IndexOfNear(startIndex);
//      while (possibleEndIndex>nextPeakIndex)
//      {
//         int ultraIndex=downUltras.IndexOf(startIndex,nextPeakIndex);
//         if (IsExceedThreshold(startIndex,ultraIndex)) return (ultraIndex);
//         nextPeakIndex=upPeaks.IndexOfNear(nextPeakIndex);
//      }
//      if (IsExceedThreshold(startIndex,possibleEndIndex))  return (possibleEndIndex);
//      return (-1);
//      
//   }
//   
//   int FindEndIndexLeftDownPeak(int index)
//   {
//      int startIndex=IndexOfCentrePeak(index);
//      int possibleEndIndex=IndexOfNextCentrePeak(index);
//      int nextPeakIndex=downPeaks.IndexOfNear(startIndex);
//      while (possibleEndIndex>nextPeakIndex)
//      {
//         int ultraIndex=upUltras.IndexOf(startIndex,nextPeakIndex);
//         if (IsExceedThreshold(startIndex,ultraIndex)) return (ultraIndex);
//         nextPeakIndex=downPeaks.IndexOfNear(nextPeakIndex);
//      }
//      if (IsExceedThreshold(startIndex,possibleEndIndex))  return (possibleEndIndex);
//      return (-1);
//   }
//   
//
//   
//   int IndexOfCentrePeak(int index)
//   {      
//      int upIndex=upPeaks.IndexOfNear(index);
//      int downIndex=downPeaks.IndexOfNear(index);
//      if (IsExceedThreshold(upIndex,downIndex))
//          return ((upIndex>=downIndex)? downIndex : upIndex);
//      return 0;
//   } 
//   
//     
//   int IndexOfNextCentrePeak(int index)
//   {
//      int upIndex=upPeaks.IndexOfNear(index);
//      int downIndex=downPeaks.IndexOfNear(index);
//      if (IsExceedThreshold(upIndex,downIndex))
//          return ((upIndex<=downIndex)? downIndex : upIndex);
//      return 0; 
//   }
//   
//   int IndexOfNextUltra(int index)
//   {
//      if (upInflexions.NextOf(index)<downInflexions.NextOf(index))  
//         return upUltras.IndexOf(upInflexions.NextOf(index),downInflexions.NextOf(index));
//      if (downInflexions.NextOf(index)<upInflexions.NextOf(index))
//         return downUltras.IndexOf(downInflexions.NextOf(index),upInflexions.NextOf(index));
//      return 0;  
//   }
//};
