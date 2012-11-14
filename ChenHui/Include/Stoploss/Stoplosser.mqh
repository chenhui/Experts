//+------------------------------------------------------------------+
//|                                             Stoplosser.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include <Trade/Trade.mqh>
#include "./StoplossCalculate.mqh"

class Stoplosser
{
   protected:  
   
      int    index;
      CTrade *trade;
      StoplossCalculate  *stoplossCalculator;
      
      bool  virtual SetOnce(){return (false);};
      void  virtual Show(){};

   public:
   
      void Stoplosser();
      void ~Stoplosser();
      bool Init(int indexOut,StoplossCalculate *stoplossCalculatorOut);
      bool Main(int number=10);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stoplosser::Stoplosser()
{
   stoplossCalculator=NULL;
   trade=new CTrade;   
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stoplosser::~Stoplosser()
{
  delete trade;
  trade=NULL;
}
//+------------------------------------------------------------------+
bool Stoplosser::Init(int indexOut,StoplossCalculate *stoplossCalculatorOut)
{
   this.index=indexOut;
   if (this.stoplossCalculator==NULL)   this.stoplossCalculator=stoplossCalculatorOut;
   return (this.stoplossCalculator!=NULL );
}

bool Stoplosser::Main(int number)
{
   //int count=0;
   //while(!SetOnce()&& count++<number){};
   //return (count<number);
   return SetOnce();
}

//=========================================================================

class PendingStoplosser:public Stoplosser
{  
   private:
      COrderInfo     *orderInfo;
       
      bool virtual SetOnce();

   public:
      void PendingStoplosser();
      void ~PendingStoplosser();
      void virtual Show();
      
};

void  PendingStoplosser::PendingStoplosser(void)
{
   orderInfo=new COrderInfo;
}

void  PendingStoplosser::~PendingStoplosser(void)
{  
   delete orderInfo;
   orderInfo=NULL;
   
}

bool PendingStoplosser::SetOnce()
{
  orderInfo.SelectByIndex(index);
  return (trade.OrderModify(orderInfo.Ticket(),
                           orderInfo.PriceOpen(),
                           stoplossCalculator.Main(),0,
                           orderInfo.TypeTime(),
                           orderInfo.TimeExpiration()));
}

void PendingStoplosser::Show()
{
   Alert(" Position ","  Symbol ",orderInfo.Symbol(),
            "  OpenPrice : ",orderInfo.PriceOpen(),
            "  Stoploss : ",orderInfo.StopLoss());
}

//===========================================================================
class PositionStoplosser:public Stoplosser
{  

   protected:

      CPositionInfo  *positionInfo;
      
      bool virtual SetOnce();

   public:
      void PositionStoplosser();
      void ~PositionStoplosser();
      void virtual Show();
      
};

void  PositionStoplosser::PositionStoplosser(void)
{
    positionInfo=new CPositionInfo;
}

void  PositionStoplosser::~PositionStoplosser(void)
{  
   
   delete positionInfo;
   positionInfo=NULL;
   
}


bool PositionStoplosser::SetOnce()
{
  positionInfo.SelectByIndex(index);
  //if ( !trade.PositionModify(positionInfo.Symbol(),stoplossCalculator.Main(),0)  )
  //{
  //  Show();
  //  Alert("-----stoploss------",stoplossCalculator.Main());
  //}
  return (trade.PositionModify(positionInfo.Symbol(),stoplossCalculator.Main(),0));
}

void PositionStoplosser::Show()
{
   Alert(" Position ","  Symbol ",positionInfo.Symbol(),
            "  OpenPrice : ",positionInfo.PriceOpen(),
            "  Profit  :  ",positionInfo.Profit(),
            "  Stoploss : ",positionInfo.StopLoss(),
            "  Current Price : ",positionInfo.PriceCurrent(),
            "  type : ",positionInfo.TypeDescription());
}

