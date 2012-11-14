//+------------------------------------------------------------------+
//|                                                     ChZigZag.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "./ChIndicator.mqh"
class ChZigZag : public ChIndicator
{ 
   
   private: 
      int      depth;
      int      deviation;
      int      backstep;
      string   path;
      double   zigzags[];
      int      increasedSize;
      bool     Refresh(int index);
      bool     IsNeedRefresh(int index);
      
   public:
      void                 ChZigZag();
      void                 ~ChZigZag();
      virtual  double      Main(int index=0);
      
   protected:  
      virtual  bool        IsNew();
      virtual  bool        IsInitParameter();
              
};

void ChZigZag::ChZigZag()
{
   depth=12;
   deviation=5;
   backstep=3;
   path="Examples\\ZigZag";
   ArraySetAsSeries(zigzags,true);
   ArrayInitialize(zigzags,NULL);
}

void ChZigZag::~ChZigZag()
{
   ArrayFree(zigzags);
}

  
bool ChZigZag::IsNew()
{
   return (true);
}

bool ChZigZag::IsInitParameter()
{
   return (true);
}

double ChZigZag::Main(int index=0)
{  
   if (!IsNeedRefresh(index))  return(zigzags[index]);  
   if (Refresh(index))   return(zigzags[index]);
   return (WRONG_VALUE); 
}

bool ChZigZag::IsNeedRefresh(int index)
{
   return (index>=ArraySize(zigzags));
}

bool ChZigZag::Refresh(int index)
{
   int maHandle=iCustom(symbol,timeFrame,path,depth,deviation,backstep);
   if (maHandle==INVALID_HANDLE)
   {
      Print(__FILE__, "  in file  and   ",__FUNCTION__, "  function  is wrong ");
      return (false);
   }
   int counts=CopyBuffer(maHandle,0,0,increaseSize+index,zigzags);
//   Reverse();
   IndicatorRelease(maHandle);
   return (counts!=WRONG_VALUE);
}
//
//void ChZigZag::Reverse()
//{
//   for(int start=0,end=ArraySize(zigzags)-1;start<end;start++,end--)
//   {
//      double temp=zigzags[start];
//      zigzags[start]=zigzags[end];
//      zigzags[end]=temp;
//   }
//}

