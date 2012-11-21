//+------------------------------------------------------------------+
//|                                                       Ultras.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include ".\Inflexion.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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