//+------------------------------------------------------------------+
//|                                                    BePointer.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Trade/PositionInfo.mqh>
#include "../Trade/ChTrade.mqh"
#include "../Symbol/ChSymbolInfo.mqh"


class BePointer
{
   protected:
      
      CPositionInfo *positionInfo;
      ChSymbolInfo  *symbolInfo;
      ChTrade *trade;   
      int     number;

      
      bool InitSymbolInfo(int index);
      bool IsSelectValid(int index);
      bool IsLotsPart(double lots);
      bool SetStoplossToBalance();
      double virtual BalancePrice();
      bool ClosePart(double lots);
   public:
      BePointer();
      ~BePointer();
      bool Main(int index,double partLots);
};


void BePointer::BePointer(void)
{
   number=10;
   trade=new ChTrade;
   positionInfo=new CPositionInfo;
   symbolInfo=new ChSymbolInfo;
}

void BePointer::~BePointer()
{
   if (positionInfo!=NULL) delete positionInfo;
   if (symbolInfo!=NULL)   delete symbolInfo;
   if (trade!=NULL)        delete trade;
   positionInfo=NULL;
   trade=NULL;
}


bool BePointer::Main(int index,double partLots)
{
   return      (  InitSymbolInfo(index) 
               && IsSelectValid(index)
               && IsLotsPart(partLots)
               && SetStoplossToBalance()
               && ClosePart(partLots));
}

bool BePointer::InitSymbolInfo(int index)
{
   return (positionInfo.SelectByIndex(index) && symbolInfo.Init(positionInfo.Symbol()));
}

bool BePointer::SetStoplossToBalance()
{
   int count=0;
   while(!trade.PositionModify(positionInfo.Symbol(),BalancePrice(),0))
   {
      if (count++>number)  return (false);
   }
   return (true);
}

double BePointer::BalancePrice()
{
   if (positionInfo.PositionType()==POSITION_TYPE_BUY)  
      return (positionInfo.PriceOpen()+symbolInfo.PointValue());
   if (positionInfo.PositionType()==POSITION_TYPE_SELL)  
      return (positionInfo.PriceOpen()-symbolInfo.PointValue());
   return (0);
}

bool BePointer::ClosePart(double lots)
{
   int count=0;
   while(!trade.ClosePart(lots,positionInfo.Symbol()))
   {
      if (count++>number)   return  (false);
   }
   return (true);
}

bool BePointer::IsSelectValid(int index)
{  
   return ( positionInfo.SelectByIndex(index));
}

bool BePointer::IsLotsPart(double lots)
{
   return (positionInfo.Volume()>=lots);
}

