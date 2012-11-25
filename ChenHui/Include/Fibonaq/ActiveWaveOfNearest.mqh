//+------------------------------------------------------------------+
//|                                          NearestActiveWave.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\include\Fibonaq\ActiveWaveOfPeakLeftRight.mqh";
#include "..\..\include\Fibonaq\ActiveWaveOfPeakFront.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class NearestActiveWave
{

private:
   int noExisted;
   string symbol;
   ENUM_TIMEFRAMES timeFrame;
   int threshold;
   int depth;
   ActiveWaveBase  *downUpActiveWave;
   ActiveWaveBase  *upDownActiveWave;
   ActiveWaveBase  *upPeakLeftActiveWave;
   ActiveWaveBase  *upPeakRightActiveWave;
   ActiveWaveBase  *downPeakLeftActiveWave;
   ActiveWaveBase  *downPeakRightActiveWave;
   
   int startIndex;
   int endIndex;

public:
   
   NearestActiveWave()
   {
      noExisted=-1;
      startIndex=noExisted;
      endIndex=noExisted;
      downUpActiveWave= new PeakFrontDownUpActiveWave;
      upDownActiveWave= new PeakFrontUpDownActiveWave;
      upPeakLeftActiveWave=new UpPeakLeftActiveWave;
      upPeakRightActiveWave=new UpPeakRightActiveWave;
      downPeakLeftActiveWave=new DownPeakLeftActiveWave;
      downPeakRightActiveWave=new DownPeakRightActiveWave;  
   }
   
   ~NearestActiveWave()
   {
      if (downUpActiveWave!=NULL) delete downUpActiveWave;
      if (upDownActiveWave!=NULL) delete upDownActiveWave;
      if (upPeakLeftActiveWave!=NULL) delete upPeakLeftActiveWave;
      if (upPeakRightActiveWave!=NULL) delete upPeakRightActiveWave;
      if (downPeakLeftActiveWave!=NULL) delete downPeakLeftActiveWave;
      if (downPeakRightActiveWave!=NULL) delete downPeakRightActiveWave;
   }
   
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int thresholdOut,int depthOut=12)
   {
      this.symbol=symbolOut;
      this.timeFrame=timeFrameOut;
      this.threshold=thresholdOut;
      this.depth=depthOut;
      return (  downUpActiveWave.Init(symbol,timeFrame,threshold,depth)
             && upDownActiveWave.Init(symbol,timeFrame,threshold,depth)
             && upPeakLeftActiveWave.Init(symbol,timeFrame,threshold,depth)
             && upPeakRightActiveWave.Init(symbol,timeFrame,threshold,depth)
             && downPeakLeftActiveWave.Init(symbol,timeFrame,threshold,depth)
             && downPeakRightActiveWave.Init(symbol,timeFrame,threshold,depth));
   }
   
   void Show()
   {
      Alert("(start ,index)= ( ",startIndex," , ",endIndex," ) ");
   }

   int StartIndex(int index=0)
   {  
      Refresh();
      return (startIndex);
   }
   
   void Refresh()
   {
   
      Show();
      Refresh(upPeakLeftActiveWave);
      Show();
      Refresh(downUpActiveWave);
      Show();
      Refresh(upDownActiveWave);
      Show();
      Refresh(upPeakRightActiveWave);
      Show();
      Refresh(downPeakLeftActiveWave);
      Show();
      Refresh(downPeakRightActiveWave);
      Show();
      
   }
   
   void Refresh(ActiveWaveBase *possibleActiveWave)
   {
      int possibleStartIndex=possibleActiveWave.StartIndex();
      int possibleEndIndex=possibleActiveWave.EndIndex();
      if (   IsExisted(possibleStartIndex,possibleEndIndex)
         &&  !IsStandard(possibleStartIndex,possibleEndIndex) )
      {
         int temp=possibleStartIndex;
         possibleStartIndex=possibleEndIndex;
         possibleEndIndex=temp;
      }
      if (   IsStandard(possibleStartIndex,possibleEndIndex) 
         &&  (possibleStartIndex<startIndex || !IsExisted()))
      {
            
         startIndex=possibleStartIndex;
         endIndex=possibleEndIndex;
      }     
   }
   
   
   bool IsExisted()
   {
      return IsExisted(startIndex,endIndex);
   }
   
   int EndIndex(int index=0)
   {
      Refresh();
      return (endIndex);
   }

private :
   
   bool IsExisted(int possibleStartIndex,int possibleEndIndex)
   {
      return (possibleStartIndex!=noExisted && possibleEndIndex!=noExisted);
   }
   
   bool IsStandard(int possibleStartIndex,int possibleEndIndex)
   {
      return (    IsExisted(possibleStartIndex,possibleEndIndex)
             &&   possibleStartIndex>possibleEndIndex);
   }
   
   
   
};
