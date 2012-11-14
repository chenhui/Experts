//+------------------------------------------------------------------+
//|                                                        Trail.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
#include <Strings\String.mqh>
#include "../Symbol/ChSymbolInfo.mqh"
#include "../Stoploss/Stoplosser.mqh"
#include "../Stoploss/TrailStoplossCalculate.mqh"
                                                         
//+------------------------------------------------------------------+
class ITrail
{     
   public:
      void ITrail(){};
      void ~ITrail(){};
      bool virtual Main(){return (false);};
      bool virtual Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int trailStoplossOut){return (false);};
};



class Trail:public ITrail
{
   protected:
      int magicNumber;
      string symbol;
      ENUM_TIMEFRAMES timeFrame;
      int trailStoploss;
         
      CPositionInfo     *positionInfo;
      ChSymbolInfo      *symbolInfo;
      StoplossCalculate *stoplossCalculater;
      Stoplosser        *stoplosser;

      
      bool  IsSelectValid(int index);
      bool virtual IsDirectionRight(){return (false);};
      bool virtual IsAfterBePoint(){return (false);};
      bool virtual IsOk(){return (false);};
      bool InitStoplosser(int index);
      string AlertInfo();
      
   public:
      void Trail();
      void ~Trail();
      bool virtual Main();
      bool Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int trailStoplossOut);
};

void Trail::Trail(void)
{
   positionInfo=new CPositionInfo;
   symbolInfo=new ChSymbolInfo;
   stoplosser=new PositionStoplosser;
   
}

bool Trail::Init(int magicNumberOut,string symbolOut,ENUM_TIMEFRAMES timeFrameOut,int trailStoplossOut)
{
   this.magicNumber=magicNumberOut;
   this.symbol=symbolOut;
   this.timeFrame=timeFrameOut;
   this.trailStoploss=trailStoplossOut;
   symbolInfo.Init(symbolOut);
   return (true);
}


void Trail::~Trail(void)
{
   delete positionInfo;
   positionInfo=NULL;
   
   delete symbolInfo;
   symbolInfo=NULL;
   
   delete stoplossCalculater;
   stoplossCalculater=NULL;
   
   delete stoplosser;
   stoplosser=NULL;
   
   

}


bool Trail::Main(void)
{
   for(int index=0;index<PositionsTotal();index++)
   {
      if (!IsSelectValid(index)) continue;
      if (!InitStoplosser(index)) continue;
      if (IsOk() && stoplosser.Main())  
      {
//         alert.Init(positionInfo.Symbol(),AlertInfo());
//         alert.Main();         
      }
   }
   return (true);
}

string Trail::AlertInfo()
{
  CString  *str =new CString;
  str.Append(" emaStoploss = ");
  str.Append(DoubleToString(stoplossCalculater.Main()));
  str.Append(" trailStoploss = ");
  str.Append(DoubleToString(positionInfo.StopLoss()));
  return str.Str();
}

bool Trail::IsSelectValid(int index)
{
   return (   positionInfo.SelectByIndex(index)
          &&  (positionInfo.Magic()==this.magicNumber)
          &&  (positionInfo.Symbol()==this.symbol)
          &&  IsDirectionRight()
          &&  IsAfterBePoint()
          );
}



bool Trail::InitStoplosser(int index)
{
   return (    stoplossCalculater.Init(index,timeFrame,trailStoploss)  
          &&   stoplosser.Init(index,stoplossCalculater));
}



//--------------------------------------------------------------------------------

class BuyFixTrail:public Trail
{
   public:
      void BuyFixTrail();
      void ~BuyFixTrail(){};
  protected:
      bool virtual IsDirectionRight();
      bool virtual IsAfterBePoint();
      bool virtual IsOk();
};

void BuyFixTrail::BuyFixTrail(void)
{
   stoplossCalculater=new BuyFixTrailStoplossCalculate;

}



bool BuyFixTrail::IsDirectionRight()
{
   return (positionInfo.PositionType()==POSITION_TYPE_BUY);
}

bool BuyFixTrail::IsAfterBePoint()
{  
   return (positionInfo.StopLoss()>positionInfo.PriceOpen());
}

bool BuyFixTrail::IsOk()
{
   return (stoplossCalculater.Main()>positionInfo.StopLoss());
}


//--------------------------------------------------------------------------------


class SellFixTrail:public Trail
{
   public:
      void SellFixTrail();
      void ~SellFixTrail(); 
   protected:
      bool virtual IsDirectionRight();
      bool virtual IsAfterBePoint();
      bool virtual IsOk();
};

void SellFixTrail::SellFixTrail(void)
{
   stoplossCalculater=new SellFixTrailStoplossCalculate;
}

void SellFixTrail::~SellFixTrail(void)
{
}

bool SellFixTrail::IsDirectionRight()
{
   return (positionInfo.PositionType()==POSITION_TYPE_SELL);
}

bool SellFixTrail::IsAfterBePoint()
{  
   return (positionInfo.StopLoss()<positionInfo.PriceOpen());
}


bool SellFixTrail::IsOk()
{
   return (stoplossCalculater.Main()<positionInfo.StopLoss());
}


//-----------------------------------------------------------------------+

class BuyEmaTrail:public Trail
{
   public:
      void BuyEmaTrail();
      void ~BuyEmaTrail(){};
  protected:
      bool virtual IsDirectionRight();
      bool virtual IsAfterBePoint();
      bool virtual IsOk();
};

void BuyEmaTrail::BuyEmaTrail(void)
{
   stoplossCalculater=new BuyEmaTrailStoplossCalculate;

}


bool BuyEmaTrail::IsDirectionRight()
{
   return (positionInfo.PositionType()==POSITION_TYPE_BUY);
}

bool BuyEmaTrail::IsAfterBePoint()
{  
   return (positionInfo.StopLoss()>positionInfo.PriceOpen());
}

bool BuyEmaTrail::IsOk()
{
   return (stoplossCalculater.Main()>(positionInfo.StopLoss()+symbolInfo.PointValue()));
}




class SellEmaTrail:public Trail
{
   public:
      void SellEmaTrail();
      void ~SellEmaTrail(); 
   protected:
      bool virtual IsDirectionRight();
      bool virtual IsAfterBePoint();
      bool virtual IsOk();
};

void SellEmaTrail::SellEmaTrail(void)
{
   stoplossCalculater=new SellEmaTrailStoplossCalculate;
}

void SellEmaTrail::~SellEmaTrail(void)
{
}

bool SellEmaTrail::IsDirectionRight()
{
   return (positionInfo.PositionType()==POSITION_TYPE_SELL);
}

bool SellEmaTrail::IsAfterBePoint()
{  
   return (positionInfo.StopLoss()<positionInfo.PriceOpen());
}


bool SellEmaTrail::IsOk()
{
   return (stoplossCalculater.Main()<(positionInfo.StopLoss()-symbolInfo.PointValue()));
}