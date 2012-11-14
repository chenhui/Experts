//+------------------------------------------------------------------+ 
//|                                   TestGthSetStoplossByServer.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Trade/PositionInfo.mqh>
#include <Trade/Trade.mqh>
#include "../../include/Symbol/ChSymbolInfo.mqh"
#include "../../include/Fibonaq/FibonaqPrimaryStoploss.mqh"
#include "../../include/Fibonaq/FibonaqPrimaryStoplossBuilder.mqh"
#include "../../include/Stoploss/Stoplosser.mqh"
#include "../../include/Stoploss/ITypeValidater.mqh"
#include "../../include/Trade/ChTrade.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//   

void ResetPositionStoploss()
{
   ChTrade trade;
   for(int index=0;index<PositionsTotal();index++)
   {
      CPositionInfo positionInfo;
      positionInfo.SelectByIndex(index);
      trade.PositionModify(positionInfo.Symbol(),0,0);
   }
}


void ReSetPendingStoploss()
{
   ChTrade trade;
   for(int index=0;index<OrdersTotal();index++)
   {
      COrderInfo orderInfo;
      orderInfo.SelectByIndex(index);
      trade.OrderModify(orderInfo.Ticket(),orderInfo.PriceOpen(),0,0,
                        orderInfo.TypeTime(),orderInfo.TimeExpiration());
   }
}



int OnInit()   
{
   ResetPositionStoploss();
   ReSetPendingStoploss();
   
   Do(new FibonaqPositionLongPrimaryStoplossBuilder);
   Do(new FibonaqPositionShortPrimaryStoplossBuilder);
   return(0);
}


void Do(IPrimaryStoplossBuilder *stoplossBuilder)
{
   IPrimaryStoploss * stoploss=stoplossBuilder.Create();
   stoploss.Main(40);
   delete stoploss;
   delete stoplossBuilder;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
 
}
//+------------------------------------------------------------------+
