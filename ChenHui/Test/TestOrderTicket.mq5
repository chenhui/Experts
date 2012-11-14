//+------------------------------------------------------------------+
//|                                              TestOrderTicket.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\OrderInfo.mqh>
#include <Trade\Trade.mqh>
int OnInit()
{
   CTrade      trade;
   COrderInfo  orderInfo;
   for(int index=0;index<OrdersTotal();index++)
   {
      orderInfo.SelectByIndex(index);
      Alert("The symbol is : ",orderInfo.Symbol(),"  ticket is : ",orderInfo.Ticket());
      trade.OrderDelete(orderInfo.Ticket());
   }
   return(0);
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
//---
   
  }
//+------------------------------------------------------------------+
