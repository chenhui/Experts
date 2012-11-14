//+------------------------------------------------------------------+
//|                                                  ChGthSignal.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Indicators\TimeSeries.mqh>
#include "..\Symbol\AllSymbol.mqh" 
#include ".\ChIndicator.mqh"
class ChClose : public ChIndicator
{  
   
   private:
      CiClose           *close;
      void              RefreshBuffer(int index);

   public:
      void              ChClose();
      void              ~ChClose();
      virtual double    Main(int index);
      
  private:    
      virtual   bool    IsNew();
      virtual   bool    IsInitParameter();
              
};

void ChClose::ChClose()
{
   timeFrame=PERIOD_M5;
   close=new CiClose;
}

void ChClose::~ChClose()
{
   if (close!=NULL)
   {
      delete close;
      close = NULL;
   }
  
}
 
bool ChClose::IsNew()
{
   if(close ==NULL)
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChClose::IsInitParameter()
{
   if(!close.Create(symbol,timeFrame))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChClose::Main(int index)
{   
   close.BufferResize(CalculateSize(index)); 
   close.Refresh(-1);
   return (close.GetData(index));
   
}



//----------------------------------------------------------------------------

class ChHigh : public ChIndicator
{  
   
   private:
      CiHigh           *high;

   public:
      void              ChHigh();
      void              ~ChHigh();
      virtual double    Main(int index);
      
  private:    
      virtual   bool    IsNew();
      virtual   bool    IsInitParameter();
              
};

void ChHigh::ChHigh()
{
   timeFrame=PERIOD_M5;
   high=new CiHigh;
}

void ChHigh::~ChHigh()
{
   if (high!=NULL)
   {
      delete high;
      high = NULL;
   }
  
}


  
bool ChHigh::IsNew()
{
   if(high==NULL)
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChHigh::IsInitParameter()
{
   if(!high.Create(symbol,timeFrame))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChHigh::Main(int index)
{   
   high.BufferResize(CalculateSize(index)); 
   high.Refresh(-1); 
   return (high.GetData(index));
   
}

//-----------------------------------------------------------------------

class ChOpen : public ChIndicator
{  
   
   private:
      CiOpen           *open;

   public:
      void              ChOpen();
      void              ~ChOpen();
      virtual double    Main(int index);
      
  private:    
      virtual   bool    IsNew();
      virtual   bool    IsInitParameter();
              
};

void ChOpen::ChOpen()
{
   timeFrame=PERIOD_M5;
   open =new CiOpen;
}

void ChOpen::~ChOpen()
{
   if (open!=NULL)
   {
      delete open;
      open = NULL;
   }
  
}


  
bool ChOpen::IsNew()
{
   if(open==NULL)
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChOpen::IsInitParameter()
{
   if(!open.Create(symbol,timeFrame))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChOpen::Main(int index)
{   
   open.BufferResize(CalculateSize(index)); 
   open.Refresh(-1); 
   return (open.GetData(index));
   
}


//-----------------------------------------------------------------------

class ChLow : public ChIndicator
{  
   
   private:
      CiLow           *low;

   public:
      void              ChLow();
      void              ~ChLow();
      virtual double    Main(int index);
      
  private:    
      virtual   bool    IsNew();
      virtual   bool    IsInitParameter();
              
};

void ChLow::ChLow()
{
   low=new CiLow;
   timeFrame=PERIOD_M5;
}

void ChLow::~ChLow()
{
   if (low!=NULL)
   {
      delete low;
      low = NULL;
   }
  
}


  
bool ChLow::IsNew()
{
   if(low ==NULL)
   {
      printf(__FUNCTION__+": error creating object");
      return(false);
   }
   return true;
}

bool ChLow::IsInitParameter()
{
   if(!low.Create(symbol,timeFrame))
   {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
     return (true);
}

double ChLow::Main(int index)
{   
   low.BufferResize(CalculateSize(index)); 
   low.Refresh(-1); 
   return (low.GetData(index));
   
}


