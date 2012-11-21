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

#include ".\ActiveWaveBase.mqh"



class RightActiveWave:public ActiveWaveBase
{

public:
   RightActiveWave(){};
   ~RightActiveWave(){};
   
   virtual int EndIndex(int index=0)
   {
      int suspendStartIndex=IndexOfCentrePeak(index);
      int suspendEndIndex=GetUltras().IndexOf(index,suspendStartIndex);
      while(amplitudeChecker.IsExceed(suspendStartIndex,suspendEndIndex) && (suspendStartIndex>suspendEndIndex) && (suspendEndIndex!=noExisted))
      {
         if (GetCallBackChecker().IsOk(suspendStartIndex,suspendEndIndex,index)) return (suspendEndIndex);
         suspendEndIndex=GetUltras().IndexOf(suspendEndIndex+1,suspendStartIndex);
      }
      return (noExisted);         
   }
         
};

class UpPeakRightActiveWave:public RightActiveWave
{
protected:

   
   Peaks *GetPeaks(){return upPeaks;}
   Ultras *GetUltras(){return downUltras;}
   virtual CallBackChecker *GetCallBackChecker(){return upDownCallBackChecker;}
   virtual Inflexions *GetStartInflexion(){return upInflexions;}
   virtual Inflexions *GetEndInflexion(){return downInflexions;}

public:
   UpPeakRightActiveWave(){};
   ~UpPeakRightActiveWave(){};
     
};

class DownPeakRightActiveWave:public RightActiveWave
{
protected:

   virtual Peaks *GetPeaks(){return downPeaks;}
   virtual Ultras *GetUltras(){return upUltras;}
   virtual Inflexions *GetStartInflexion(){return downInflexions;}
   virtual Inflexions *GetEndInflexion(){return upInflexions;}
   virtual CallBackChecker *GetCallBackChecker(){return downUpCallBackChecker;}

public:
   DownPeakRightActiveWave(){};
   ~DownPeakRightActiveWave(){};
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
      if (amplitudeChecker.IsExceed(startIndex,possibleEndIndex))  return (possibleEndIndex);
      return (-1);   
   }
protected:
   int IndexOfNextCentrePeak(int index)
   {
      int centrePeak=IndexOfCentrePeak(index);
      if (amplitudeChecker.IsExceed(centrePeak,IndexOfNextCounterPeak(centrePeak)))  
         return (IndexOfNextCounterPeak(centrePeak));
      return (-1);  
   }  
   virtual int IndexOfNextCounterPeak(int peakIndex){return (-1);}
   
   bool HasActiveWaveBetween(int startIndex,int nextPeakIndex)
   {
      return (amplitudeChecker.IsExceed(startIndex,GetUltras().IndexOf(startIndex,nextPeakIndex)));
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
   virtual Peaks *GetPeaks(){return downPeaks;}
   virtual Ultras *GetUltras(){return upUltras;}  
   virtual Inflexions *GetStartInflexion(){return downInflexions;}
   virtual Inflexions *GetEndInflexion(){return upInflexions;}

   virtual int IndexOfNextCounterPeak(int peakIndex)
   {
      return upPeaks.IndexOfNear(peakIndex);
   }
   
};
//----------------------------------------------------nearest active wave-----------------------------

//----------------------------------------------------nearest active wave-----------------------------
//class NearestActiveWave
//{
//public:
//
//   NearestActiveWave()
//   {
//      noExisted=-1;
//      zeroUpActiveWave=new UpPeakRightActiveWave;
//      zeroDownActiveWave=new DownPeakRightActiveWave;
//      upPeakActiveWave=new UpPeakLeftActiveWave;
//      downPeakActiveWave=new DownPeakLeftActiveWave;
//   };
//   
//   ~NearestActiveWave()
//   {
//      if (zeroUpActiveWave!=NULL) delete zeroUpActiveWave;
//      if (zeroDownActiveWave!=NULL) delete zeroDownActiveWave;
//      if (upPeakActiveWave!=NULL) delete upPeakActiveWave;
//      if (downPeakActiveWave!=NULL) delete downPeakActiveWave;
//   };
//   
//   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int amplitudeOut,int depthOut=12)
//   {
//      this.symbol=symbolOut;
//      this.timeFrame=timeFrameOut;
//      this.amplitude=amplitudeOut;
//      this.depth=depthOut; 
//      return ( zeroUpActiveWave.Init(symbol,timeFrame,amplitude,depth) 
//            && zeroDownActiveWave.Init(symbol,timeFrame,amplitude,depth)
//            && upPeakActiveWave.Init(symbol,timeFrame,amplitude,depth)
//            && downPeakActiveWave.Init(symbol,timeFrame,amplitude,depth));
//   
//   }
//   
//   int StartIndex()
//   {  
//      int zeroUpStart=zeroDownActiveWave.StartIndex();
//      int zeroDownStart=zeroUpActiveWave.StartIndex();
//      if (zeroUpStart!=noExisted && zeroDownStart==noExisted)  return (zeroUpStart);
//      if (zeroDownStart!=noExisted && zeroUpStart==noExisted)  return (zeroDownStart);
//      if (zeroUpStart!=noExisted && zeroDownStart!=noExisted) return (zeroUpStart<=zeroDownStart)?zeroUpStart:zeroDownStart;
//      return (noExisted);
//   }
//   
//   int EndIndex()
//   {
//      int zeroUpEnd=zeroDownActiveWave.EndIndex();
//      int zeroDownEnd=zeroUpActiveWave.EndIndex();
//      if (zeroUpEnd!=noExisted && zeroDownEnd==noExisted)  return (zeroUpEnd);
//      if (zeroDownEnd!=noExisted && zeroUpEnd==noExisted)  return (zeroDownEnd);
//      if (zeroUpEnd!=noExisted && zeroDownEnd!=noExisted) return (zeroUpEnd<=zeroDownEnd)?zeroUpEnd:zeroDownEnd;
//      return (noExisted);
//   }
//   
//private:
//   int noExisted;
//   string symbol;
//   ENUM_TIMEFRAMES timeFrame;
//   int    amplitude;
//   int    depth;
//   ActiveWaveBase *zeroUpActiveWave;
//   ActiveWaveBase *zeroDownActiveWave;
//   ActiveWaveBase *upPeakActiveWave;
//   ActiveWaveBase *downPeakActiveWave;
//   
//};

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
//         if (amplitudeChecker.IsExceed(indexOfNearPeak,indexOfNearUltra))   return (true);
//      }
//      if (downPeaks.IsPossible(indexOfNearPeak))
//      {
//         int indexOfNearUltra=upUltras.IndexOf(start,indexOfNearPeak);
//         if (amplitudeChecker.IsExceed(indexOfNearPeak,indexOfNearUltra))   return (true);        
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
//         if (amplitudeChecker.IsExceed(startIndex,ultraIndex)) return (ultraIndex);
//         nextPeakIndex=upPeaks.IndexOfNear(nextPeakIndex);
//      }
//      if (amplitudeChecker.IsExceed(startIndex,possibleEndIndex))  return (possibleEndIndex);
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
//         if (amplitudeChecker.IsExceed(startIndex,ultraIndex)) return (ultraIndex);
//         nextPeakIndex=downPeaks.IndexOfNear(nextPeakIndex);
//      }
//      if (amplitudeChecker.IsExceed(startIndex,possibleEndIndex))  return (possibleEndIndex);
//      return (-1);
//   }
//   
//
//   
//   int IndexOfCentrePeak(int index)
//   {      
//      int upIndex=upPeaks.IndexOfNear(index);
//      int downIndex=downPeaks.IndexOfNear(index);
//      if (amplitudeChecker.IsExceed(upIndex,downIndex))
//          return ((upIndex>=downIndex)? downIndex : upIndex);
//      return 0;
//   } 
//   
//     
//   int IndexOfNextCentrePeak(int index)
//   {
//      int upIndex=upPeaks.IndexOfNear(index);
//      int downIndex=downPeaks.IndexOfNear(index);
//      if (amplitudeChecker.IsExceed(upIndex,downIndex))
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
