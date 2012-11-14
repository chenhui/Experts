#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include "..\Cross\MacdCrossZero.mqh"
#include "..\Cross\CrossEma.mqh"
#include "..\..\Include\Signals\ISignal.mqh"

//------------------------------------------------------------------------+

class GthOpenSignal
{
   protected :
      int             crossStableLength;
      int             startIndex;
      int             endIndex;  
      
      string          symbol;
      ENUM_TIMEFRAMES timeFrame;
      MacdCrossZero   *macdCrossZero;
      CrossEma        *crossEma;

      

      bool   CheckCloseAfterMacdCrossNear(int index);
      bool   CheckMacdAfterCloseCrossNear(int index);
      virtual bool   InitCrossEma(){return false;};
      virtual bool   InitMacdCrossZero(){return false;};
           
      
   public:
      void  GthOpenSignal();
      void  ~GthOpenSignal();
      bool  virtual Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool  virtual Main(int index=0) ;

};

void GthOpenSignal::GthOpenSignal()
{
   this.crossStableLength=1;
   this.startIndex=1;
   this.endIndex=5;
   this.crossEma=NULL;
   this.macdCrossZero=NULL;

}

bool GthOpenSignal::Init(string symbolOut,ENUM_TIMEFRAMES timeFrameOut)
{
   this.symbol=symbolOut;
   this.timeFrame=timeFrameOut;
   return (InitCrossEma() && InitMacdCrossZero());
}



void GthOpenSignal::~GthOpenSignal()
{
     if(crossEma!=NULL)       delete crossEma;
     if(macdCrossZero!=NULL)  delete macdCrossZero;
     crossEma=NULL;
     macdCrossZero=NULL; 
}

bool GthOpenSignal::Main(int index)
{
   if (!(CheckCloseAfterMacdCrossNear(index) || CheckMacdAfterCloseCrossNear(index))) return (false);
   return(true);
  
}

bool GthOpenSignal::CheckCloseAfterMacdCrossNear(int index)
{
   return (  crossEma.IsCloseCrossEmaStable(index,crossStableLength) 
      && macdCrossZero.IsMacdCrossZeroBetween(index,startIndex,endIndex) );
}


bool GthOpenSignal::CheckMacdAfterCloseCrossNear(int index)
{
   return ( macdCrossZero.IsMacdCrossZeroStable(index,crossStableLength)  
      &&  crossEma.IsCloseCrossEmaBetween(index,startIndex,endIndex));
}

//---------------------------------Open long checker------------------------------//

class GthOpenLongSignal : public GthOpenSignal
{

   private:
      virtual bool  InitCrossEma();
      virtual bool  InitMacdCrossZero();
    
      
   public:
      void  GthOpenLongSignal();
      void  ~GthOpenLongSignal();
      bool  Main() ;
     


};

void GthOpenLongSignal::GthOpenLongSignal()
{
}

void GthOpenLongSignal::~GthOpenLongSignal()
{

}


bool GthOpenLongSignal::InitCrossEma()
{
   this.crossEma=new CrossUpEma;
   return ( crossEma.Init(this.symbol,this.timeFrame));
}

bool GthOpenLongSignal::InitMacdCrossZero()
{
   macdCrossZero = new MacdCrossUpZero;
   return ( macdCrossZero.Init(this.symbol,this.timeFrame));
}

//---------------------------Open short checker----------------------------//

class GthOpenShortSignal : public GthOpenSignal
{

   private:
      bool  InitCrossEma();
      bool  InitMacdCrossZero();

     
   public:
      void  GthOpenShortSignal();
      void  ~GthOpenShortSignal();
      bool  Main() ;
     


};

void GthOpenShortSignal::GthOpenShortSignal()
{
}

void GthOpenShortSignal::~GthOpenShortSignal()
{

}


bool GthOpenShortSignal::InitCrossEma()
{
   this.crossEma=new CrossDownEma;
   return (crossEma.Init(this.symbol,this.timeFrame));
}

bool GthOpenShortSignal::InitMacdCrossZero()
{
   this.macdCrossZero = new MacdCrossDownZero;
   return (macdCrossZero.Init(this.symbol,this.timeFrame));
}




//------------------------------------------------------------------------+

class GthSignal:public ISignal
{
   private:

      GthOpenSignal *openLongSignal;
      GthOpenSignal *openShortSignal;
      
      
   public:
      void GthSignal();
      void ~GthSignal();
      virtual bool Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters);
      virtual bool OpenBuyCondition();
      virtual bool CloseBuyCondition();
      virtual bool OpenSellCondition();
      virtual bool CloseSellCondition();
      
};

void GthSignal::GthSignal(void)
{
   openLongSignal=new GthOpenLongSignal;
   openShortSignal=new GthOpenShortSignal;
}


void GthSignal::~GthSignal(void)
{
   if (openLongSignal!=NULL)   delete openLongSignal;
   if (openShortSignal!=NULL)  delete openShortSignal;
}

bool GthSignal::Init(string symbol,ENUM_TIMEFRAMES timeFrame,Parameters &parameters)
{

   return (    openLongSignal.Init(symbol,timeFrame)
          &&   openShortSignal.Init(symbol,timeFrame)
          );
}


bool GthSignal::OpenBuyCondition()
{
   return ( openLongSignal.Main());
}

bool GthSignal::OpenSellCondition()
{
   return ( openShortSignal.Main());
}

bool GthSignal::CloseBuyCondition()
{
   //return ( openShortSignal.Main());
   return (false);
}

bool GthSignal::CloseSellCondition()
{
   //return ( openLongSignal.Main());
   return (false);
}

