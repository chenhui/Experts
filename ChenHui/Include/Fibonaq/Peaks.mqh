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
