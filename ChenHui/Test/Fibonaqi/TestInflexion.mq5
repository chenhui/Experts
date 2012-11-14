//+------------------------------------------------------------------+
//|                                                   TestZigZag.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\..\include\Fibonaq\Inflexion.mqh";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


Inflexions *upInflexions;
Inflexions *downInflexions;

int OnInit()
{
   upInflexions=new UpInflexions;
   upInflexions.Init(Symbol(),PERIOD_CURRENT);
   
   downInflexions=new DownInflexions;
   downInflexions.Init(Symbol(),PERIOD_CURRENT);
   
   Alert("---------------up range-----------------");
   upInflexions.Show(0,100);
   Alert("---------------up range-----------------");
   Alert(" Up next Inflexion of ",0," : ( ",upInflexions.NextOf(0)," , ",upInflexions.ValueOfNext(0)," )");
   Alert(" Up next inflexion of ",1," : ( ",upInflexions.NextOf(1)," , ",upInflexions.ValueOfNext(1)," )");
   Alert(" Up next inflexion of ",30," : ( ",upInflexions.NextOf(30)," , ",upInflexions.ValueOfNext(30)," )");
   Alert(" Up value of ",10, " : ",upInflexions.ValueOf(10));
   Alert(" Down pre inflexion of ",55," : ( ",downInflexions.PreOf(55)," , ",downInflexions.ValueOfPre(55)," )");
   Alert(" Down pre inflexion of ",30," : ( ",downInflexions.PreOf(30)," , ",downInflexions.ValueOfPre(30)," )");
   

   Alert("---------------dwon range-----------------");
   downInflexions.Show(0,100);  
   Alert("---------------dwon range-----------------");   
   Alert(" Down next Inflexion of ",0," : ( ",downInflexions.NextOf(0)," , ",downInflexions.ValueOfNext(0)," )");
   Alert(" Down next inflexion of ",7," : ( ",downInflexions.NextOf(7)," , ",downInflexions.ValueOfNext(7)," )");
   Alert(" Down value of ",10, " : ",downInflexions.ValueOf(10));
   EventSetTimer(60);
   return(0);
}


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

   if (upInflexions!=NULL) delete upInflexions;
   if (downInflexions!=NULL) delete downInflexions;
   EventKillTimer();

      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //TestUpInflexion();
}



//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
}
//+------------------------------------------------------------------+
