//+------------------------------------------------------------------+
//|                                               TestOrderTrail.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "../include/Trail/Trail.mqh"

int OnInit()
{

   TestTrailRefreshAll();
   //TestDeleteAndSetTrail();   
   //TestTrailRefreshAll();
   return(0);
}

void TestTrailRefreshAll()
{
   //Trail *trail=new Trail;
   //trail.InitAll();
   Trail  *trail=GetTrail();
   trail.ShowAll();
   if (!trail.SetStoploss(65684,111111))      Alert("65684 Trail set stoploss is not successed");
   if (!trail.SetTakeProfit(65684,1.58680))   Alert("65684 Trail set takeprofit is not successed");
   if (!trail.SetStoploss(65644,222222))      Alert("65644 Trail set stoploss is not successed");
   if (!trail.SetTakeProfit(65644,0.98775))   Alert("65644 Trail set takeprofit is not successed");
   trail.ShowAll();
   Alert("Number of Close Position is ",trail.Refresh(),"     time : ",TimeCurrent());
   
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
   //TestTrailRefreshAll();
}
//+------------------------------------------------------------------+




void TestDeleteAndSetTrail()
{
   Alert("------start-----");
   TestTrailInitAll();
   Trail *trail=new Trail;
   trail.Delete(65684);
   trail.Delete("USDCAD");
   trail.SetStoploss(65641,11111);
   trail.SetTakeProfit(65641,2222);
   Alert("---------------");
   trail.ShowAll();

}

void TestTrailInitAll()
{
   Trail *trail=new Trail;
   trail.InitAll();
   trail.ShowAll();
}

void TestPositionInfor()
{
   CPositionInfo *positionInfo=new CPositionInfo;
   for(int index=0;index<PositionsTotal();index++)
   {
      positionInfo.SelectByIndex(index);
      Alert("  Index  ",index,
            "  Identifier : ",positionInfo.Identifier(),
            "  Opentime : ",positionInfo.Time(),
            "  Symbol : ",positionInfo.Symbol(),
            "  Price : ",positionInfo.PriceOpen(),
            "  Type : ",positionInfo.PositionType());
        
     
   }
}