//+------------------------------------------------------------------+
//|                                                        Peaks.mqh |
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
#include "..\Symbol\ChSymbolInfo.mqh"

class Peaks
{
protected:
   int depth;
   Inflexions *inflexions;
   virtual bool IsCrossPreAndAfter(int current,int prev,int after){return (false);};
   virtual bool IsNot(int i,int index){return (false);};
   
   int StartOfVerify(int index)
   {
      return (index-depth/2)>0 ? index-depth/2 :1;
   }
   
public:
   Peaks(){};
   ~Peaks(){if (inflexions!=NULL) delete inflexions; };
   
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int depthOut=12)
   {
      this.depth=depthOut;
      return inflexions.Init(symbolOut,timeFrameOut);
   }
   
   int IndexOfNear(int index)
   {    
      int prev=inflexions.NextOf(index);
      int current=inflexions.NextOf(prev);
      int after=inflexions.NextOf(current);
      while (!IsCrossPreAndAfter(current,prev,after))
      {
         prev=current;
         current=after;
         after=inflexions.NextOf(after);
      }
      return current;
   }
   
   double ValueOfNear(int index)
   {
      return inflexions.ValueOf(IndexOfNear(index));
   }
   
   virtual bool IsPossible(int index)
   {
      for(int i=StartOfVerify(index);i<index+depth/2;i++)
      {
         if (IsNot(i,index))  return false;
      }
      return true;      
   }
   
};

class UpPeaks:public Peaks
{
   
public:
   UpPeaks(){inflexions= new UpInflexions;};
   ~UpPeaks(){};      
protected:   
   virtual bool IsCrossPreAndAfter(int current,int prev,int after)
   {
      return ( inflexions.ValueOf(current)>inflexions.ValueOf(prev) 
            && inflexions.ValueOf(current)>inflexions.ValueOf(after));
   }
   
   virtual bool IsNot(int i,int index)
   {
      return (inflexions.ValueOf(i)>inflexions.ValueOf(index));
   }

   
};

class DownPeaks:public Peaks
{
public:
   DownPeaks(){inflexions=new DownInflexions;};
   ~DownPeaks(){};      
protected:   
   virtual bool IsCrossPreAndAfter(int current,int prev,int after)
   {
      return ( inflexions.ValueOf(current)<inflexions.ValueOf(prev) 
            && inflexions.ValueOf(current)<inflexions.ValueOf(after));
   }
    
   virtual bool IsNot(int i,int index)
   {
      return (inflexions.ValueOf(i)<inflexions.ValueOf(index));
   }
   
   
   
};
//-------------------------------------------Ultras---------------------------------+
class Ultras
{
protected:
   Inflexions *inflexions;
   virtual double SetInitUltra(){return 0;}   
   virtual bool IsCross(double ultraValue,int index){return false;}
public:
   Ultras(){};
   ~Ultras(){if (inflexions!=NULL)  delete inflexions;};
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut)
   {
      return inflexions.Init(symbolOut,timeFrameOut);
   }
      
   int IndexOf(int startIndex,int endIndex)
   { 
         if (startIndex>endIndex) 
         {
            int temp=endIndex;
            endIndex=startIndex;
            startIndex=temp;
         }
         int index=inflexions.NextOf(startIndex);
         int position=-1;
         double ultraValue=SetInitUltra();
         while(index<endIndex)
         {
            if (IsCross(ultraValue,index))
            {
              ultraValue=inflexions.ValueOf(index);
              position=index;
            }
            index=inflexions.NextOf(index);
         }
         return position;
   };
   
   double ValueOf(int startIndex,int endIndex)
   {
      return (IndexOf(startIndex,endIndex)==-1) ? -1:inflexions.ValueOf(IndexOf(startIndex,endIndex));
   }

};

class UpUltras:public Ultras
{
public:
   UpUltras(){inflexions=new UpInflexions;};
   ~UpUltras(){};
   
   virtual double SetInitUltra()
   {
      return (DBL_MIN);
   };
   
   virtual bool IsCross(double ultraValue,int index)
   {
      return (ultraValue<inflexions.ValueOf(index));
   }
};

class DownUltras:public Ultras
{
public:
   DownUltras(){inflexions=new DownInflexions;};
   ~DownUltras(){};
   
   virtual double SetInitUltra()
   {
      return (DBL_MAX);
   };
   
   virtual bool IsCross(double ultraValue,int index)
   {
      return (ultraValue>inflexions.ValueOf(index));
   }
   
};