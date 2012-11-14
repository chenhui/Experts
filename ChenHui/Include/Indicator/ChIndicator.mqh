//+------------------------------------------------------------------+
//|                                               ChGthIndicator.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

class ChIndicator
{
     
   protected:
      
      string            symbol;
      ENUM_TIMEFRAMES   timeFrame;
      int               increaseSize;

      void              SetSymbalAndTimeFrame(string symbol,ENUM_TIMEFRAMES timeFrame);
      int               CalculateSize(int index);
      virtual  bool     IsNew()            {return (false);}

   
      
   public:
      ChIndicator();
      ~ChIndicator();
      virtual  double   Main(int index=0){return 0;};
      bool     Create(string symbol,ENUM_TIMEFRAMES timeFrame);
      virtual  bool     IsInitParameter()  {return (false);}
}  
;

void ChIndicator::ChIndicator()
{
      increaseSize=50;
}

void ChIndicator::~ChIndicator()
{
}

bool ChIndicator::Create(string symbolOut,ENUM_TIMEFRAMES timeFrameOut)
{
   
     SetSymbalAndTimeFrame(symbolOut,timeFrameOut);
     if (!IsNew())             return false; 
     if (!IsInitParameter())   return false; 
     return(true);
      
}

void ChIndicator::SetSymbalAndTimeFrame(string symbolOut,ENUM_TIMEFRAMES timeFrameOut)
{
   this.symbol=symbolOut;
   this.timeFrame=timeFrameOut;
}

int ChIndicator::CalculateSize(int index)
{
   return  (index+increaseSize);
}





