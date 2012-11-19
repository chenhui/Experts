//+------------------------------------------------------------------+
//|                                            NearestActiveWave.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "./ActiveWave.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//----------------------------------------------------nearest active wave-----------------------------
enum STARTOREND{
   START=0,
   END=1
};  
class PossibleActiveWave
{
public:
   int startIndex;
   int endIndex;
   int index;
   PossibleActiveWave(int startIndexOut,int endIndexOut,int indexOut)
   {
      this.startIndex=startIndexOut;
      this.endIndex=endIndexOut;
      this.index=indexOut;
   };
};

//----------------------------------------------------------------------------------------------------
class NearestActiveWave:public ActiveWaveBase
{
public:
   int StartIndex(int index=0)
   {  
      int startTotalIndex=GetPeaks().IndexOfNear(0);
      int endTotalIndex=GetUltras().IndexOf(index,startTotalIndex);
      return StartIndexIn(startTotalIndex,endTotalIndex,index);
   }
   
   int EndIndex(int index=0)
   {
      int startTotalIndex=GetPeaks().IndexOfNear(0);
      int endTotalIndex=GetUltras().IndexOf(index,startTotalIndex);
      return EndIndexIn(startTotalIndex,endTotalIndex,index);
   }

protected:
   
   int StartIndexIn(int startTotalIndex,int endTotalIndex,int callBackIndex)
   {
        return IndexIn(START,startTotalIndex,endTotalIndex,callBackIndex);  
   }
   
   int EndIndexIn(int startTotalIndex,int endTotalIndex,int callBackIndex)
   {
      return IndexIn(END,startTotalIndex,endTotalIndex,callBackIndex); 
   }
 
   int IndexIn(STARTOREND startOrEnd,int startTotalIndex,int endTotalIndex,int callBackIndex)
   {
      PossibleActiveWave *possibleStartWave=FindPossibleActiveWaveIn(startTotalIndex,endTotalIndex,callBackIndex); 
      if (possibleStartWave==NULL) return (noExisted);
      int possibleStartIndex=possibleStartWave.startIndex;
      int possibleEndIndex=possibleStartWave.endIndex;
      int possibleIndex=possibleStartWave.index;
      if (possibleStartWave!=NULL) delete possibleStartWave;
                
      if ( (possibleStartIndex<startTotalIndex)
         ||  ((possibleStartIndex==startTotalIndex) && IsActiveWave(possibleStartIndex,possibleEndIndex,possibleIndex)))
         return (startOrEnd==START) ? possibleStartIndex : possibleEndIndex;
      return noExisted;   
   }

   PossibleActiveWave *FindPossibleActiveWaveIn(int startTotalIndex,int endTotalIndex,int callBackIndex)
   {
      if  (!HaveActiveWave(endTotalIndex,startTotalIndex))  return (NULL); 
      
      int possibleStartIndex=NextSerial(GetStartInflexion().NextOf(endTotalIndex));
      int possibleEndIndex=endTotalIndex;
      int possibleIndex=callBackIndex;
      
      while (  (possibleStartIndex<startTotalIndex) 
            && (!IsActiveWave(possibleStartIndex,possibleEndIndex,possibleIndex)) )
      {
         possibleIndex=possibleStartIndex;
         possibleEndIndex=GetUltras().IndexOf(startTotalIndex,possibleIndex);
         possibleStartIndex=NextSerial(GetStartInflexion().NextOf(possibleEndIndex));
      }
      return (new PossibleActiveWave(possibleStartIndex,possibleEndIndex,possibleIndex));

   }

   bool HaveActiveWave(int startTotalIndex,int endTotalIndex)
   {
      return amplitudeChecker.IsExceed(startTotalIndex,endTotalIndex);
   }
      
   int NextSerial(int inflexionIndex)
   {
      int nextSerialIndex=inflexionIndex;
      while( IsNextSerial(nextSerialIndex))
      {
         nextSerialIndex=GetStartInflexion().NextOf(nextSerialIndex);
      }
      return nextSerialIndex;
   }
   
   bool IsNextSerial(int inflexionIndex)
   {
      return (GetStartInflexion().NextOf(inflexionIndex)<GetEndInflexion().NextOf(inflexionIndex));
   }
   
   bool IsActiveWave(int possibleStartIndex,int possibleEndIndex,int possibleIndex)
   {
      return   (amplitudeChecker.IsExceed(possibleStartIndex,possibleEndIndex) 
               && GetCallBackChecker().IsOk(possibleStartIndex,possibleEndIndex,possibleIndex));
   }
   
};


class NearestDownUpActiveWave:public NearestActiveWave
{
protected:
   virtual   Peaks *GetPeaks(){return downPeaks;}
   virtual   Ultras *GetUltras(){return upUltras;} 
   virtual   Inflexions *GetStartInflexion(){return downInflexions;}
   virtual   Inflexions *GetEndInflexion(){return upInflexions;}
   virtual   CallBackChecker *GetCallBackChecker(){return downUpCallBackChecker;}
   
};

//----------------------------------------------------nearest active wave-----------------------------
class NearestUpDownActiveWave:public NearestActiveWave
{
protected:
   virtual Peaks *GetPeaks(){return upPeaks;}
   virtual Ultras *GetUltras(){return downUltras;} 
   virtual Inflexions *GetStartInflexion(){return upInflexions;}
   virtual Inflexions *GetEndInflexion(){return downInflexions;}
   virtual CallBackChecker *GetCallBackChecker(){return upDownCallBackChecker;}

};

