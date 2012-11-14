//+------------------------------------------------------------------+
//|                                                 FibonaqClose.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "../Close/Closer.mqh"
#include "../Close/IClose.mqh"
#include "../Close/ICloseSignal.mqh"
#include "../Fibonaq/FibonaqCloseSignal.mqh"
#include "../Fibonaq/FibonaqTradeEvent.mqh"

class FibonaqClose:public IClose
{
   protected:
      CPositionInfo *positionInfo;
      Closer *closer;
      ICloseSignal  *closeSignal;
      IEventAlert   *alert;

      bool Close(int index);
      bool IsSelectValid(int index);
      bool IsSignalOk();
      bool IsClose();
      bool virtual IsPriceOk(){return false;};
      bool virtual IsTypeOk(){return false;}; 
      bool virtual InitAlert(int index);
   
   public:
      FibonaqClose();
      ~FibonaqClose();
      void virtual Main();
      bool virtual Init(ICloseSignal *closeSignal);
};


FibonaqClose::FibonaqClose()
{
   closer=new PositionCloser;
   positionInfo=new CPositionInfo;
}

bool FibonaqClose::Init(ICloseSignal *closeSignal)
{
   this.closeSignal=closeSignal;
   return (true);
}

FibonaqClose::~FibonaqClose()
{
   if (closer!=NULL)  delete closer;
   if (closeSignal!=NULL)  delete closeSignal;
   if (positionInfo!=NULL) delete positionInfo;
   if (alert!=NULL)  delete alert;
}

 
void FibonaqClose::Main(void)
{
   for(int index=0;index<PositionsTotal();index++)
   {
      if (Close(index))  
      {
         InitAlert(index);
         alert.Main();
      };
   }   
}

bool FibonaqClose::Close(int index)
{
   return (    IsSelectValid(index) 
          &&   IsSignalOk()
          &&   IsPriceOk()
          &&   IsTypeOk()
          &&   IsClose() );
   
}

bool FibonaqClose::IsSelectValid(int index)
{
   return positionInfo.SelectByIndex(index);
}

bool FibonaqClose::IsSignalOk()
{
   return (    closeSignal.Init(positionInfo.Symbol(),PERIOD_M5)
          &&   closeSignal.Main());
}

bool FibonaqClose::IsClose()
{
   return (  closer.Init(positionInfo.Symbol()) 
          && closer.Main() );
}


bool FibonaqClose::InitAlert(int index)
{
   if (!positionInfo.SelectByIndex(index))  return (false);
   return (alert.Init(positionInfo.Symbol()));
}

//----------------------------------------------------------------------------------
class  FibonaqCloseLong:public FibonaqClose
{
   private:
      bool virtual IsPriceOk();
      bool virtual IsTypeOk();

   public:
      void FibonaqCloseLong();
      void ~FibonaqCloseLong();
};

void FibonaqCloseLong::FibonaqCloseLong(void)
{
   alert=new FibonaqCloseLongPositionAlert;
}

void FibonaqCloseLong::~FibonaqCloseLong(void)
{
}


bool FibonaqCloseLong::IsPriceOk(void)
{
   return (positionInfo.PriceCurrent()>positionInfo.PriceOpen());
}

bool FibonaqCloseLong::IsTypeOk()
{
   return (positionInfo.PositionType()==POSITION_TYPE_BUY);
}


//----------------------------------------------------------------------------------

class  FibonaqCloseShort:public FibonaqClose
{
   private:
      bool virtual IsPriceOk();
      bool virtual IsTypeOk();

   public:
      void FibonaqCloseShort();
      void ~FibonaqCloseShort();
};

void FibonaqCloseShort::FibonaqCloseShort(void)
{
   alert=new FibonaqCloseShortPositionAlert;
}

void FibonaqCloseShort::~FibonaqCloseShort(void)
{
}

bool FibonaqCloseShort::IsPriceOk(void)
{
   return (positionInfo.PriceCurrent()<positionInfo.PriceOpen());
}

bool FibonaqCloseShort::IsTypeOk()
{
   return (positionInfo.PositionType()==POSITION_TYPE_SELL);
}
