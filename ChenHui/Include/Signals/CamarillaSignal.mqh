//+------------------------------------------------------------------+
//|                                              CamarillaSignal.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\Indicator\ChCamarillaPivot.mqh"
#include "ISignal.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class CamarillaSignalBase:public ISignal
{
   protected:
      ChCamarillaPivot *camarilla;
      ChIndicator    *close;
   public:
      void CamarillaSignalBase(){};

      void ~CamarillaSignalBase()
      {
         if (camarilla!=NULL)  delete camarilla;
         if (close!=NULL)  delete close;
      };

      bool Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut,Parameters &parametersOut)
      {
         close=new ChClose();
         camarilla=new ChCamarillaPivot;
         return  (   close.Create(symbolOut,PERIOD_M5)  
                  && camarilla.Init(symbolOut,PERIOD_D1) );
      }

      void ShowHL(void)
      {
            Alert("Time : ",TimeCurrent(), " H5 ",camarilla.H5()," L5 ",camarilla.L5());
            Alert("Time : ",TimeCurrent(), " H4 ",camarilla.H4()," L4 ",camarilla.L4());
            Alert("Time : ",TimeCurrent(), " H3 ",camarilla.H3()," L3 ",camarilla.L3());
      }

     
};

class Camarilla3Signal:public CamarillaSignalBase
{
   public:
      void Camarilla3Signal(){};
      void ~Camarilla3Signal(){};
      virtual bool OpenBuyCondition();
      virtual bool CloseBuyCondition();
      virtual bool OpenSellCondition();
      virtual bool CloseSellCondition();
         
};

bool Camarilla3Signal::OpenBuyCondition()
{
   return ((close.Main(1)<camarilla.L3() && close.Main(2)>camarilla.L3())
          || (close.Main(1)>camarilla.L3() && close.Main(2)<camarilla.L3()));
}

bool Camarilla3Signal::OpenSellCondition()
{
   return ( (close.Main(1)<camarilla.H3() && close.Main(2)>camarilla.H3())
          || (close.Main(1)>camarilla.H3() && close.Main(2)<camarilla.H3()));
}

bool Camarilla3Signal::CloseBuyCondition()
{
   return (    OpenSellCondition() 
           ||  (close.Main(2)>camarilla.L4() && close.Main(1)<camarilla.L4()));
}

bool Camarilla3Signal::CloseSellCondition()
{
   return ( OpenBuyCondition()
          ||(close.Main(2)<camarilla.H4() && close.Main(1)>camarilla.H4()));
}

//------------------------------------------------------------------------------+

class Camarilla4Signal:public CamarillaSignalBase
{
   public:
      void Camarilla4Signal(){};
      void ~Camarilla4Signal(){};
      virtual bool OpenBuyCondition();
      virtual bool CloseBuyCondition();
      virtual bool OpenSellCondition();
      virtual bool CloseSellCondition();
         
};



bool Camarilla4Signal::OpenBuyCondition()
{
   return (close.Main(2)<camarilla.H4() && close.Main(1)>camarilla.H4());
}

bool Camarilla4Signal::OpenSellCondition()
{
   return (close.Main(2)>camarilla.L4() && close.Main(1)<camarilla.L4());
}

bool Camarilla4Signal::CloseBuyCondition()
{
   
   return (  (close.Main(1)>camarilla.H5())
           || (close.Main(2)>camarilla.H3() && close.Main(1)<camarilla.H3()));
}

bool Camarilla4Signal::CloseSellCondition()
{
   return (   (close.Main(1)<camarilla.L5())
           || (close.Main(2)<camarilla.L3() && close.Main(1)>camarilla.L3()) );
}
//-------------------------------------------------------------------------------+
