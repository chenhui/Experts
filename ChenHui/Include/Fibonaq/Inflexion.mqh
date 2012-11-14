//+------------------------------------------------------------------+
//|                           ChannelDot.mqh                         |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\Indicator\ChPrice.mqh"

class ChannelDot
{
protected:
   string symbol;
   ENUM_TIMEFRAMES timeFrame;
   int dotIndex;
   int depth;
   ChIndicator *indicator;
  
   bool IsFrontFlexion()
   {
      for(int index=dotIndex+1;index<=(dotIndex+depth/2);index++)
      {
         if (IsNotCrossTo(index))  return (false);
      }
      return (true);     
   }
   
   bool IsAfterFlexion()
   {
      int afterLimitedIndex=((dotIndex-depth/2)>0 ? (dotIndex-depth/2):0);
      for(int index=dotIndex-1;index>=afterLimitedIndex;index--)
      {
         if (IsNotCrossTo(index))  return (false);
      }
      return (true);     
   }

   virtual bool IsNotCrossTo(int index){return (false);}
   
      
public:

   void ChannelDot(){};
   void ~ChannelDot(){if (indicator!=NULL) delete indicator;};
   
   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int suspendIndexOut,int depthOut=12)
   {
      this.symbol=symbolOut;
      this.timeFrame=timeFrameOut;
      this.depth=depthOut;
      this.dotIndex=suspendIndexOut;
      return (indicator.Create(symbol,timeFrame) );
   }
   
   bool IsInFlexion()
   {
      return (IsFrontFlexion() && IsAfterFlexion());
   }
   
   double ValueOf()
   {
      return (indicator.Main(dotIndex));
   }

};

class UpChannelDot:public ChannelDot
{

public:

   UpChannelDot(){indicator=new ChHigh;}
   
protected:
  
   virtual bool IsNotCrossTo(int index)
   {
      return indicator.Main(dotIndex)<indicator.Main(index);
   }
   
};

//---------------------------------------------------------------------------

class DownChannelDot:public ChannelDot
{
public:
   DownChannelDot(){indicator=new ChLow;}
   
protected:
      
   virtual  bool IsNotCrossTo(int index)
   {
      return indicator.Main(dotIndex)>indicator.Main(index);
   }  
  
};


class Inflexions
{

protected:
   string symbol;
   ENUM_TIMEFRAMES timeFrame;
   ChannelDot *channelDot;
   
public:

   bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut)
   {
      symbol=symbolOut;
      timeFrame=timeFrameOut;
      return (true);
   };
   
   Inflexions(){};
   
   ~Inflexions()
   {
      if (channelDot!=NULL)  delete channelDot;
   };


   void Show(int start,int end)
   {
      for(int index=start;index<=end;index++)
      {
         channelDot.Init(symbol,timeFrame,index);
         if (channelDot.IsInFlexion()) Alert(" inflexion ",index ," : ",channelDot.ValueOf());
      }   
   }
   
   int NextOf(int dotIndex)
   {
      int nextIndex=dotIndex+1;   
      channelDot.Init(symbol,timeFrame,nextIndex);
      while(!channelDot.IsInFlexion())
      {
         channelDot.Init(symbol,timeFrame,++nextIndex);
      };
      return nextIndex;      
   }
   
   double ValueOf(int dotIndex)
   {
      channelDot.Init(symbol,timeFrame,dotIndex);
      return channelDot.ValueOf();
   }
   
   double ValueOfNext(int dotIndex)
   {
      return ValueOf(NextOf(dotIndex));
   }
   
   int PreOf(int dotIndex)
   {
      int nextIndex=dotIndex-1;   
      channelDot.Init(symbol,timeFrame,nextIndex);
      while( (nextIndex>=0) && (!channelDot.IsInFlexion()))
      {
         channelDot.Init(symbol,timeFrame,--nextIndex);
      };
      return nextIndex;
   };
   
   double ValueOfPre(int dotIndex)
   {
      if (PreOf(dotIndex)==0)  return 0;
      return ValueOf(PreOf(dotIndex));
   }
   
};

class UpInflexions :public Inflexions
{
public:
   UpInflexions(){channelDot=new UpChannelDot;};
   ~UpInflexions(){};    
    
   
};

class DownInflexions :public Inflexions
{
public:
   DownInflexions(){channelDot=new DownChannelDot;};
   ~DownInflexions(){};  
};