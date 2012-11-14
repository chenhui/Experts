//+------------------------------------------------------------------+
//|                                                 BePoint.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade/PositionInfo.mqh>
#include "../Trade/ChTrade.mqh"
#include "../Symbol/ChSymbolInfo.mqh"
//#include "../Stoploss/ICommentValidater.mqh"
#include "../BEPoint/Bepointer.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

class IBePoint
{
   public:
      void IBePoint(){};
      void ~IBePoint(){};
      bool virtual Main(){return (false);};
      bool virtual Init(int magicNumberOut,string symbol,double partLots){return (false);};
};

class BePoint:public IBePoint
{
   protected:
      int            magicNumber;
      string         symbol;
      
      double         partLots;
      string         comment;
      CPositionInfo  *positionInfo;
      ChTrade        *trade;
      ChSymbolInfo   *symbolInfo;
      BePointer      *bePointer;
      
//      CommentValidater  *commentValidater;
      
   
      bool virtual IsSelectValid(int index){return false;};
      bool virtual IsPrimary(){return false;};
      bool virtual IsTouch(){return false;};      
      double virtual BePointCalculate(){return false;};
      bool InitSymbolInfo(int index);
      bool SetBePointAlert(int index);      
      
   public :
      void BePoint();
      void ~BePoint();
      bool virtual Main();
      bool virtual Init(int magicNumberOut,string symbol,double partLots=0);
};

void BePoint::BePoint(void)
{

   positionInfo=new CPositionInfo;
   trade=new ChTrade;
   
   symbolInfo=new ChSymbolInfo;
   bePointer=new BePointer;

}

void BePoint::~BePoint(void)
{
   if (positionInfo!=NULL)    delete positionInfo;
   if (trade!=NULL)           delete trade;
   if (symbolInfo!=NULL)      delete symbolInfo;
   if (bePointer!=NULL)       delete bePointer;

   positionInfo=NULL;
   trade=NULL;
   symbolInfo=NULL;
   bePointer=NULL;


}

bool BePoint::Init(int magicNumberOut,string symbolOut,double partLots=0)
{
   this.magicNumber=magicNumberOut;
   this.symbol=symbolOut;
   this.partLots=partLots;
   return (true);
}

bool BePoint::Main()
{
   for(int index=0 ;index<PositionsTotal();index++)
   {
      if (!InitSymbolInfo(index))  continue;
      if (!IsSelectValid(index) )  continue;
      if (!IsPrimary() )           continue;
      if (!IsTouch())              continue;
      if (bePointer.Main(index,partLots))      SetBePointAlert(index);
   }
   return (true);
}

bool BePoint::InitSymbolInfo(int index)
{
   return ( positionInfo.SelectByIndex(index) && symbolInfo.Init(positionInfo.Symbol()));
}

bool BePoint::SetBePointAlert(int index)
{
   if (!positionInfo.SelectByIndex(index)) return (false);
   return(true);
}


class BuyBePoint:public BePoint
{
   public:
      void BuyBePoint();
      void ~BuyBePoint();
      bool virtual IsSelectValid(int index);
      bool virtual IsPrimary();
      bool virtual IsTouch();      
      double virtual BePointCalculate();
};

void BuyBePoint::BuyBePoint(void)
{
}

void BuyBePoint::~BuyBePoint(void)
{
}

bool BuyBePoint::IsSelectValid(int index)
{
   return (positionInfo.SelectByIndex(index) 
          && (positionInfo.Symbol()==symbol)
          && (positionInfo.Magic()==magicNumber)
          && (positionInfo.PositionType()==POSITION_TYPE_BUY) );
}

double BuyBePoint::BePointCalculate()
{
   return (positionInfo.PriceOpen()+(positionInfo.PriceOpen()-positionInfo.StopLoss()));
}

bool  BuyBePoint::IsPrimary()
{
   return (positionInfo.StopLoss()<(positionInfo.PriceOpen()-symbolInfo.PointValue()));
}

bool  BuyBePoint::IsTouch(void)
{
   return (positionInfo.PriceCurrent()>=BePointCalculate());
}
//--------------------------------------------------------------------
class SellBePoint:public BePoint
{
   public:
      void SellBePoint();
      void ~SellBePoint();
      bool virtual IsSelectValid(int index);
      bool virtual IsPrimary();
      bool virtual IsTouch();      
      double virtual BePointCalculate();
};

void SellBePoint::SellBePoint(void)
{
}

void SellBePoint::~SellBePoint(void)
{
}


bool SellBePoint::IsSelectValid(int index)
{
   return (    positionInfo.SelectByIndex(index) 
          &&  (positionInfo.Symbol()==symbol)
          && (positionInfo.Magic()==magicNumber)
          && (positionInfo.PositionType()==POSITION_TYPE_SELL));
}

bool  SellBePoint::IsPrimary(void)
{
   return (positionInfo.StopLoss()>(positionInfo.PriceOpen()+symbolInfo.PointValue()));
}

double SellBePoint::BePointCalculate()
{
   return (positionInfo.PriceOpen()-(positionInfo.StopLoss()-positionInfo.PriceOpen()));
}

bool  SellBePoint::IsTouch(void)
{
   return (positionInfo.PriceCurrent()<=BePointCalculate());
}

