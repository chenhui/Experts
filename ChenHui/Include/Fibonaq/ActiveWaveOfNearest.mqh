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
   double threeEightTwo;
   double twoFive;
   double sixOneEight;
   double sevenFive;
   string symbol;
   ENUM_TIMEFRAMES timeFrame;
   int threshold;
   int depth;
   ChannelDot      *upChannelDots;
   ChannelDot      *downChannelDots;
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
      threeEightTwo=0.382;
      twoFive=0.25;
      sixOneEight=0.618;
      sevenFive=0.75;

      startIndex=noExisted;
      endIndex=noExisted;
      upChannelDots=new UpChannelDot;
      downChannelDots=new DownChannelDot;
      downUpActiveWave= new PeakFrontDownUpActiveWave;
      upDownActiveWave= new PeakFrontUpDownActiveWave;
      upPeakLeftActiveWave=new UpPeakLeftActiveWave;
      upPeakRightActiveWave=new UpPeakRightActiveWave;
      downPeakLeftActiveWave=new DownPeakLeftActiveWave;
      downPeakRightActiveWave=new DownPeakRightActiveWave;  
   }
   
   ~NearestActiveWave()
   {
      if (upChannelDots!=NULL)     delete upChannelDots;
      if (downChannelDots!=NULL)   delete downChannelDots;
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
      Alert("(start ,end)= ( ",startIndex," , ",endIndex," ) ");
      Alert("value(start,end)= ( ",StartValue()," , ",EndValue()," ) ");
   }

   int StartIndex()
   {  
      Refresh();
      return (startIndex);
   }
   
   double StartValue()
   {
      return ValueOf(startIndex);   
   }
   
   void Refresh()
   {
      Refresh(upPeakLeftActiveWave);
      Refresh(downUpActiveWave);
      Refresh(upDownActiveWave);
      Refresh(upPeakRightActiveWave);
      Refresh(downPeakLeftActiveWave);
      Refresh(downPeakRightActiveWave);
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
   
   int EndIndex()
   {
      Refresh();
      return (endIndex);
   }
   
   double EndValue()
   {
      return ValueOf(endIndex);
   }
   
   double ThreeEightTwoValue()
   {
      return RatioValueOf(threeEightTwo);
   }
   
   double SixOneEightValue()
   {
      return RatioValueOf(sixOneEight);
   }
   
   double TwoFiveValue()
   {
      return RatioValueOf(twoFive);
   }
   
   double SevenFiveValue()
   {
      return RatioValueOf(sevenFive);
   }
private :

   
   double RatioValueOf(double ratio)
   {
      if (EndValue()==noExisted || StartValue()==noExisted)  return noExisted;
      if (StartValue()<EndValue()) return StartValue()+ratio*(EndValue()-StartValue());
      else  return EndValue()+ratio*(StartValue()-EndValue());      
   }



   double ValueOf(int index)
   {
      if (index==noExisted)  return noExisted;
      if (upChannelDots.Init(symbol,timeFrame,index) && upChannelDots.IsInFlexion())
         return upChannelDots.ValueOf();
      if (downChannelDots.Init(symbol,timeFrame,index) && downChannelDots.IsInFlexion())
         return downChannelDots.ValueOf();
      return noExisted;     
   }
   
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
