//+------------------------------------------------------------------+
//|                                                      ChSymmetryTrade.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include "..\..\Include\Symbol\ChSymbolInfo.mqh"
#include <Trade\Trade.mqh>

class ChSymmetryTrade
{
   private:
      int               numbersOfOperate;
      ulong             magicNumber;
      string            symbol;
      double            lots;
      CTrade            *trade;
      CPositionInfo     *positionInfo;
      ChSymbolInfo      *symbolInfo;
      bool              IsPositionExist(ENUM_POSITION_TYPE positionType);   
      bool              DependableBuyPosition(double stoploss=0);
      bool              DependableSellPosition(double stoploss=0);
      bool              ClosePosition(ENUM_POSITION_TYPE  positonType);
   public:
      void ChSymmetryTrade(){};
      void ~ChSymmetryTrade();
      bool Init(ulong magicNumber,string symbol,double lots);
      
      bool CloseBuyPosition();
      bool CloseSellPosition();
      
      
      bool OpenBuyPositionWith(double stoploss);
      bool OpenSellPositionWith(double stoploss);
      
      bool IsSellPositionExist();
      bool IsBuyPositionExist();          
};

bool ChSymmetryTrade::Init(ulong magicNumberOut,string symbolOut,double lotsOut)
{
   this.numbersOfOperate=50;
   this.magicNumber=magicNumberOut;
   this.symbol=symbolOut;
   this.lots=lotsOut;
   trade=new CTrade;
   trade.SetExpertMagicNumber(magicNumber);
   symbolInfo=new ChSymbolInfo;
   positionInfo=new CPositionInfo;
   return (true);
}


bool ChSymmetryTrade::CloseSellPosition()
{
   return ClosePosition(POSITION_TYPE_SELL);
}

bool ChSymmetryTrade::CloseBuyPosition()
{
   return ClosePosition(POSITION_TYPE_BUY);
}

bool ChSymmetryTrade::ClosePosition(ENUM_POSITION_TYPE  positionType)
{
   for(int index=0;index<PositionsTotal();index++)
   {
      positionInfo.SelectByIndex(index);
      if (positionInfo.Magic()!=magicNumber) continue;
      if (positionInfo.Symbol()!=symbol)  continue;
      if (positionInfo.PositionType()!=positionType) continue;
      int count=0;
      while(!trade.PositionClose(positionInfo.Symbol()) && (count++<numbersOfOperate))
      {
         Alert(positionInfo.Symbol(),
               " Delete Position is not successed",
               trade.ResultRetcodeDescription());
      }
      Alert("Delete ", index ," ",positionInfo.Symbol()," is successed "); 
      return true;
   }
   return false; 
}


bool ChSymmetryTrade::OpenBuyPositionWith(double stoploss)
{
   return DependableBuyPosition(stoploss);
}

bool ChSymmetryTrade::DependableBuyPosition(double stoploss)
{
   int count=0;
   while (!trade.Buy(lots,symbol,symbolInfo.Ask(),stoploss) && count++<this.numbersOfOperate){};
   return (count<this.numbersOfOperate);
}


bool ChSymmetryTrade::OpenSellPositionWith(double stoploss)
{
   return DependableSellPosition(stoploss);
}

bool ChSymmetryTrade::DependableSellPosition(double stoploss)
{
   int count=0;
   while (!trade.Sell(lots,symbol,symbolInfo.Bid(),stoploss) && count++<this.numbersOfOperate){};
   return (count<this.numbersOfOperate);
}

bool ChSymmetryTrade::IsSellPositionExist()
{
   return IsPositionExist(POSITION_TYPE_SELL);
}

bool ChSymmetryTrade::IsBuyPositionExist()
{
   return IsPositionExist(POSITION_TYPE_BUY);
}

bool ChSymmetryTrade::IsPositionExist(ENUM_POSITION_TYPE positionType)
{
   for(int index=0;index<PositionsTotal();index++)
   {
      positionInfo.SelectByIndex(index);
      if (  positionInfo.Symbol()==symbol 
         && positionInfo.PositionType()==positionType
         && positionInfo.Magic()==magicNumber)  return true;
   }
   return false;
}

void ChSymmetryTrade::~ChSymmetryTrade(void)
{
   if (trade!=NULL) delete trade;
   if (symbolInfo!=NULL) delete symbolInfo;
   if (positionInfo!=NULL) delete positionInfo; 
}

