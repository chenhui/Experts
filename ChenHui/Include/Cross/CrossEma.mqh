//+------------------------------------------------------------------+
//|                                                    Crossable.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "../indicator/ChPrice.mqh"
#include "../indicator/ChEma.mqh"
#include "../indicator/ChMacd.mqh"
#include "../indicator/ChIndicator.mqh"
#include "../Symbol/AllSymbol.mqh"

class CrossEma
{
   protected: 
      ChIndicator    *close;
      ChIndicator    *ema;
       
   public :
      void         CrossEma();
      void         ~CrossEma();
      bool         Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      int          IndexOfCrossEmaNear(int index);
      bool         IsCloseCrossEmaBetween(int baseIndex,int startIndex,int endIndex);
      virtual bool IsCloseCrossEmaAt(int index){return false;};
      virtual bool IsCloseCrossEmaStable(int index,int crossStableLength){return false;};
      
};

void CrossEma::CrossEma()
{  
}

bool CrossEma::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   close =  new ChClose;
   ema   =  new ChEma;
   return (close.Create(symbol,timeFrame) && ema.Create(symbol,timeFrame));
}



void CrossEma::~CrossEma()
{
   if(close!=NULL)  delete close;
   if(ema!=NULL)    delete ema;
   close=NULL; ema=NULL; 
}



bool CrossEma::IsCloseCrossEmaBetween(int baseIndex,int startIndex,int endIndex)
{
   int indexOfCloseCross=IndexOfCrossEmaNear(baseIndex);
   return ((indexOfCloseCross>=startIndex) && (indexOfCloseCross<=endIndex)); 
}

int  CrossEma::IndexOfCrossEmaNear(int index)
{
   while (!IsCloseCrossEmaAt(++index)); 
   return (index);
}

class CrossDownEma :public CrossEma
{
        
   public:
   
      void  CrossDownEma();
      void  ~CrossDownEma();
      
      bool IsCloseCrossEmaStable(int index,int crossStableLength);     
      bool IsCloseCrossEmaAt(int index);
          
         
};

void CrossDownEma::CrossDownEma()
{  
}



void CrossDownEma::~CrossDownEma()
{
}



bool CrossDownEma::IsCloseCrossEmaStable(int index,int crossStableLength)
{
   return (close.Main(index)<ema.Main(index) && IsCloseCrossEmaAt(index+crossStableLength));
}


bool CrossDownEma::IsCloseCrossEmaAt(int index)
{
   return ((close.Main(index+1)>ema.Main(index+1)) && close.Main(index)<ema.Main(index));
}


class CrossUpEma :public CrossEma
{

        
   public:
   
      void  CrossUpEma();
      void  ~CrossUpEma();
      

      bool IsCloseCrossEmaStable(int index,int crossStableLength);     
      bool IsCloseCrossEmaAt(int index);
    
         
};

void CrossUpEma::CrossUpEma()
{  
}


void CrossUpEma::~CrossUpEma()
{
}




bool CrossUpEma::IsCloseCrossEmaStable(int index,int crossStableLength)
{
   return (close.Main(index)>ema.Main(index) && IsCloseCrossEmaAt(index+crossStableLength));
}


bool CrossUpEma::IsCloseCrossEmaAt(int index)
{
   return ((close.Main(index+1)<ema.Main(index+1)) && close.Main(index)>ema.Main(index));
}

