//+------------------------------------------------------------------+
//|                                                TestOrderInfo.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\PositionInfo.mqh>
#include "../include/Symbol/ChSymbolInfo.mqh"
#include "../include/Stoploss/Stoploss.mqh"

CPositionInfo *positionInfo;
ChSymbolInfo   *symbolInfo;


int OnInit()
{  
   positionInfo=new CPositionInfo;
   symbolInfo=new ChSymbolInfo;
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   delete positionInfo;
   delete symbolInfo;
   positionInfo=NULL;
   symbolInfo=NULL;
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{

   ShowAllPosition();
   TestAutoPositionRefresh(64184,1.502,new AutoLongPosition);
}

void TestAutoPositionRefresh(long identifier,double stoploss,AutoPosition *autoPosition)
{
   if (!autoPosition.Init(identifier,stoploss)) Alert("init is not successed");
   if (autoPosition.Refresh())   Alert("position of ",identifier, " is be stop trade ");
}

void ShowAllPosition()
{
   int totals=PositionsTotal();
   for (int index=0;index<totals;index++)
   {
      if (!positionInfo.SelectByIndex(index))  return ;
      Alert(" Identifier = ",positionInfo.Identifier(),
            " string = ",positionInfo.Symbol(),
            " type = ",positionInfo.PositionType(),
            " volume = ",positionInfo.Volume(),
            " profit = ",positionInfo.Profit(),
            " stoploss = ",positionInfo.StopLoss(),
            " takeprofit = ",positionInfo.TakeProfit());
         
   }
   Alert("Current time is " ,TimeCurrent());
}

bool RefreshBuy(long identifier,double stoploss)
{
 
   int totals=PositionsTotal();
   for(int index=0;index<totals;index++)
   {
      if (!positionInfo.SelectByIndex(index)) return (false);
      if (positionInfo.Identifier()!=identifier) return (false);
      symbolInfo.Init(positionInfo.Symbol());
      if (stoploss>symbolInfo.Bid())  Alert(positionInfo.Symbol()," : ",
                                           positionInfo.Identifier(),
                                           " must be make stoploss ");
   }
   return (true);
}
//+------------------------------------------------------------------+
