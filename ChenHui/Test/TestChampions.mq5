//+------------------------------------------------------------------+
//|                                                   SuperZyama.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


 input int MA_RED_PERIOD = 7; 
 input int MA_YEL_PERIOD = 14;
 input int TP = 1900;         
 input int SL = 1000;      
 
 
 MqlTradeRequest request;
 MqlTradeResult result;
 int ma_red_handle, ma_yel_handle, macd_handle;
 double MA_RED[], MA_YEL[], MACD[];
 double Ask, Bid;
 int i;
 double Lots, LOTS;
 
 
  double Volume()
      {
         double Balance = AccountInfoDouble(ACCOUNT_BALANCE);
         if(Balance < 4001.0)Lots=0.5;
         if(Balance < 11000.0 && Balance > 4000.0)Lots=1.0;
         if(Balance < 12000.0 && Balance > 10999.0)Lots=1.1;
         if(Balance < 13000.0 && Balance > 11999.0)Lots=1.2;
         if(Balance < 14000.0 && Balance > 12999.0)Lots=1.3;
         if(Balance < 15000.0 && Balance > 13999.0)Lots=1.4;
         if(Balance < 16000.0 && Balance > 14999.0)Lots=1.5;
         if(Balance < 17000.0 && Balance > 15999.0)Lots=1.6;
         if(Balance < 18000.0 && Balance > 16999.0)Lots=1.7;
         if(Balance < 19000.0 && Balance > 17999.0)Lots=1.8;
         if(Balance < 20000.0 && Balance > 18999.0)Lots=1.9;
         if(Balance < 21000.0 && Balance > 19999.0)Lots=2.0;
         if(Balance < 22000.0 && Balance > 20999.0)Lots=2.1;
         if(Balance < 23000.0 && Balance > 21999.0)Lots=2.2;
         if(Balance < 24000.0 && Balance > 22999.0)Lots=2.3;
         if(Balance < 25000.0 && Balance > 23999.0)Lots=2.4;
         if(Balance < 26000.0 && Balance > 24999.0)Lots=2.5;
         if(Balance < 27000.0 && Balance > 25999.0)Lots=2.6;
         if(Balance < 28000.0 && Balance > 26999.0)Lots=2.7;
         if(Balance < 29000.0 && Balance > 27999.0)Lots=2.8;
         if(Balance < 30000.0 && Balance > 28999.0)Lots=2.9;
         if(Balance < 31000.0 && Balance > 29999.0)Lots=3.0;
         if(Balance < 32000.0 && Balance > 30999.0)Lots=3.1;
         if(Balance < 33000.0 && Balance > 31999.0)Lots=3.2;
         if(Balance < 34000.0 && Balance > 32999.0)Lots=3.3;
         if(Balance < 35000.0 && Balance > 33999.0)Lots=3.4;
         if(Balance < 36000.0 && Balance > 34999.0)Lots=3.5;
         if(Balance < 37000.0 && Balance > 35999.0)Lots=3.6;
         if(Balance < 38000.0 && Balance > 36999.0)Lots=3.7;
         if(Balance < 39000.0 && Balance > 37999.0)Lots=3.8;
         if(Balance < 40000.0 && Balance > 38999.0)Lots=3.9;
         if(Balance < 41000.0 && Balance > 39999.0)Lots=4.0;
         if(Balance < 42000.0 && Balance > 40999.0)Lots=4.1;
         if(Balance < 43000.0 && Balance > 41999.0)Lots=4.2;
         if(Balance < 44000.0 && Balance > 42999.0)Lots=4.3;
         if(Balance < 45000.0 && Balance > 43999.0)Lots=4.4;
         if(Balance < 46000.0 && Balance > 44999.0)Lots=4.5;
         if(Balance < 47000.0 && Balance > 45999.0)Lots=4.6;
         if(Balance < 48000.0 && Balance > 46999.0)Lots=4.7;
         if(Balance < 49000.0 && Balance > 47999.0)Lots=4.8;
         if(Balance < 50000.0 && Balance > 48999.0)Lots=4.9;
         if(Balance > 49999.0)Lots=5.0;
         return(Lots);
      }
 
int OnInit()
  {
   ma_red_handle = iMA(NULL, 0, MA_RED_PERIOD, 0, MODE_EMA, PRICE_CLOSE);
   ma_yel_handle = iMA(NULL, 0, MA_YEL_PERIOD, 0, MODE_EMA, PRICE_CLOSE);
   macd_handle = iMACD(NULL, 0, 12, 26, 9, PRICE_CLOSE);
   return(0);
  }
void OnDeinit(const int reason)
  {
  }
void OnTick()
  {

   CopyBuffer(ma_red_handle, 0, 0, 4, MA_RED);
   CopyBuffer(ma_yel_handle, 0, 0, 4, MA_YEL);
   CopyBuffer(macd_handle, 0, 0, 4, MACD);
   ArraySetAsSeries(MA_RED, true);
   ArraySetAsSeries(MA_YEL, true);
   ArraySetAsSeries(MACD, true);
   
 
   Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   LOTS = Volume();
   
  
   if(PositionsTotal() < 1)
      {
         if(MA_RED[3] > MA_YEL[3] && MA_RED[1] < MA_YEL[1] && MA_RED[0] < MA_YEL[0] 
            && MACD[1] < 0)
               {
                  request.action = TRADE_ACTION_DEAL;
                  request.symbol = _Symbol;
                  request.volume = LOTS;
                  request.price = Ask;
                  request.sl = Ask - SL*_Point;
                  request.tp = Bid + TP*_Point;
                  request.deviation = 10;
                  request.type = ORDER_TYPE_BUY;
                  request.type_filling = ORDER_FILLING_AON;
                  OrderSend(request, result);
                  return;
               }
         if(MA_RED[3] < MA_YEL[3] && MA_RED[1] > MA_YEL[1] && MA_RED[0] > MA_YEL[0]
             && MACD[1] > 0)
               {
                  request.action = TRADE_ACTION_DEAL;
                  request.symbol = _Symbol;
                  request.volume = LOTS;
                  request.price = Bid;
                  request.sl = Bid + SL*_Point;
                  request.tp = Ask - TP*_Point;
                  request.deviation = 10;
                  request.type = ORDER_TYPE_SELL;
                  request.type_filling = ORDER_FILLING_AON;
                  OrderSend(request, result);
                  return;
               }
      }
      
   for(i=0;i<PositionsTotal();i++)
     {
      if(Symbol()==PositionGetSymbol(i))
        {
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
            if(SL>0)  
              {                 
               if(Bid-PositionGetDouble(POSITION_SL)>_Point*SL)
                 {
                  if(PositionGetDouble(POSITION_SL)<Bid-_Point*SL)
                    {
                        request.action = TRADE_ACTION_SLTP;
                        request.symbol = _Symbol;
                        request.sl = Ask - SL*_Point;
                        request.tp = PositionGetDouble(POSITION_TP);
                        OrderSend(request, result);
                        return;
                    }
                 }
              }
            }
            
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
           {
            if(SL>0)  
              {                 
               if((PositionGetDouble(POSITION_SL)-Ask)>(_Point*SL))
                 {
                  if((PositionGetDouble(POSITION_SL)>(Ask+_Point*SL)) || (PositionGetDouble(POSITION_SL)==0))
                    {
                        request.action = TRADE_ACTION_SLTP;
                        request.symbol = _Symbol;
                        request.sl = Bid + SL*_Point;
                        request.tp = PositionGetDouble(POSITION_TP);
                        OrderSend(request, result);
                        return;
                    }
                 }
              }
            }
         }
      }
  }

