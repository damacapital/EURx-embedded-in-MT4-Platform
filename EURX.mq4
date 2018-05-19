//+------------------------------------------------------------------+
//|                                                         EURX.mq4 |
//|                                Copyright DAMA Capital Management |
//|                                           http://damacapital.com |
//+------------------------------------------------------------------+
#property copyright "Copyright DAMA Capital Management"
#property link      "http://damacapital.com"
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color3 Blue
#property indicator_width3 1
#property indicator_color4 Aqua
#property indicator_width4 1
#property indicator_color5 SpringGreen
#property indicator_width5 2
extern string indexname="EURX";
extern int MaxBars=10000;
extern color Bullish=Red;
extern color Bearish=White;
extern int CandleWidth=3;
extern bool Reverse=false;
extern int MA_Period1=40;
extern int MA_Period2=20;
extern int MA_Period3=10;
extern int MA_Mode1=MODE_SMA;
extern int MA_Mode2=MODE_SMA;
extern int MA_Mode3=MODE_EMA;
double MA1[];
double MA2[];
double MA3[];
string Symbols[5];
double Weights[5];
int Window;
double PrH[],PrL[];
int limit;
void DrawCandle(datetime T,double O,double C){
   string ObjName=""+T;
   color CandleColor;
   if(C>=O)CandleColor=Bullish;else CandleColor=Bearish;
   Window=WindowFind(indexname);
   if(Window==-1)return;
   if(ObjectFind(ObjName+"R"+indexname)!=-1){
      ObjectSet(ObjName+"R"+indexname,OBJPROP_TIME1,T);
      ObjectSet(ObjName+"R"+indexname,OBJPROP_TIME2,T);
      ObjectSet(ObjName+"R"+indexname,OBJPROP_PRICE1,O);
      ObjectSet(ObjName+"R"+indexname,OBJPROP_PRICE2,C);
   }
   else{
      ObjectCreate(ObjName+"R"+indexname,OBJ_TREND,Window,T,O,T,C);
   } 
   ObjectSet(ObjName+"R"+indexname,OBJPROP_COLOR,CandleColor);
   ObjectSet(ObjName+"R"+indexname,OBJPROP_RAY,false);
   ObjectSet(ObjName+"R"+indexname,OBJPROP_WIDTH,CandleWidth);
   return;
} 
int init(){
   IndicatorShortName(indexname);
   IndicatorDigits(Digits);
   SetIndexStyle(0,DRAW_NONE);
   SetIndexBuffer(0,PrH);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexBuffer(1,PrL);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,MA1);
   SetIndexLabel(2,"MA("+MA_Period1+")");
   SetIndexEmptyValue(2, 0);
   
   SetIndexStyle(3, DRAW_LINE);
   SetIndexBuffer(3,MA2);
   SetIndexLabel(3,"MA2("+MA_Period2+")");
   SetIndexEmptyValue(3,0);
   
   SetIndexStyle(4, DRAW_LINE);
   SetIndexBuffer(4,MA3);
   SetIndexLabel(4,"MA3("+MA_Period3+")");
   SetIndexEmptyValue(4,0);
   //FORMULA - EURX
   //EURx = 34.38805726 x (EURUSD)^(-0.3155) x (EURGBP)^(0.3056) x (EURJPY)^(-0.1891) x (EURSEK)^(0.0785)x (EURCHF)^(0.1113)  
  
   Symbols[0]="EURUSD";
   Symbols[1]="EURGBP";
   Symbols[2]="EURJPY";
   Symbols[3]="EURSEK";
   Symbols[4]="EURCHF";
   
   Weights[0]=0.3155;
   Weights[1]=0.3056;
   Weights[2]=0.1891;
   Weights[3]=0.0785;
   Weights[4]=0.1113;
   return(0);
}
int deinit(){
   Window=WindowFind(indexname);
   if(Window!=-1){
      ObjectsDeleteAll(Window, OBJ_TREND);
}
   return(0);
}
double SymbolCoeff(int Number,int pos,int Price){
   string Symb=Symbols[Number];
   datetime T=Time[pos];
   int bar=iBarShift(Symb,0,T,false);
   double PriceV=iMA(Symb,0,1,0,MODE_SMA,Price,bar);
   double Power=Weights[Number];
   double Coeff=MathPow(PriceV,Power);
   return (Coeff);
}
int start(){
   if(Bars<=3)return(0);
   int ExtCountedBars=IndicatorCounted();
   if (ExtCountedBars<0)return(-1);
   int pos;
   double xO, xC;
   limit=Bars-2;
   if(ExtCountedBars>2) limit=Bars-ExtCountedBars-1;
   limit=MathMin(limit, MaxBars);
   pos=limit;
   while(pos>=0){
      xO=34.38805726;
      xC=34.38805726;
      xO=xO*SymbolCoeff(0,pos,PRICE_OPEN);
      xO=xO*SymbolCoeff(1,pos,PRICE_OPEN);
      xO=xO*SymbolCoeff(2,pos,PRICE_OPEN);
      xO=xO*SymbolCoeff(3,pos,PRICE_OPEN);
      xO=xO*SymbolCoeff(4,pos,PRICE_OPEN);
      xC=xC*SymbolCoeff(0,pos,PRICE_CLOSE);
      xC=xC*SymbolCoeff(1,pos,PRICE_CLOSE);
      xC=xC*SymbolCoeff(2,pos,PRICE_CLOSE);
      xC=xC*SymbolCoeff(3,pos,PRICE_CLOSE);
      xC=xC*SymbolCoeff(4,pos,PRICE_CLOSE);
      if(Reverse){
         xC=1/xC;
         xO=1/xO;
      }
      PrH[pos]=xC;
      PrL[pos]=xO;
      DrawCandle(Time[pos],xO,xC);
      pos--;
   }
   CalculateMAs();
   return(0);
}
void CalculateMAs(){
   if(Bars<MA_Period1)return;
   if(MA_Period1>0)CalcMA(MA1,MA_Mode1,MA_Period1);
   if(Bars<MA_Period2)return;
   if(MA_Period2>0)CalcMA(MA2,MA_Mode2,MA_Period2);
   if(Bars<MA_Period3)return;
   if(MA_Period3>0)CalcMA(MA3,MA_Mode3,MA_Period3);
}
void CalcMA(double &MA[],int ma_method,int ma_period){
   switch(ma_method){
      case MODE_SMA:CalcSMA(MA, ma_period);
      break;
      case MODE_EMA:CalcEMA(MA, ma_period);
      break;
      case MODE_SMMA:CalcSMMA(MA, ma_period);
      break;
      case MODE_LWMA:CalcLWMA(MA, ma_period);
      break;
      default:CalcSMA(MA, ma_period);
      break;
   }
}
void CalcSMA(double &MA[],int ma_period){
   for(int j=0;j<limit;j++){
      double MA_Sum=0;
      for(int k=j;k<j+ma_period;k++){
         MA_Sum+=PrH[k];
      }
      
      MA[j]=MA_Sum/ma_period;
   }
}
void CalcEMA(double &MA[],double ma_period){
   for(int j=limit-1;j>=0;j--){
      if(PrH[j]==EMPTY_VALUE)continue;
      if((MA[j+1]==0) || (MA[j+1]==EMPTY_VALUE))MA[j]=PrH[j];
      else{
         double coeff=2/(ma_period+1);
         MA[j]=PrH[j]*coeff+MA[j+1]*(1-coeff);
      }
   }
}
void CalcSMMA(double &MA[],double ma_period){
   for(int j=limit-1;j>=0;j--){
      if(PrH[j]==EMPTY_VALUE)continue;
      if((MA[j+1]==0) || (MA[j+1]==EMPTY_VALUE))MA[j]=PrH[j];
      else{
         double coeff=1/ma_period;
         MA[j]=PrH[j]*coeff+MA[j+1]*(1-coeff);
      }
   }
}
void CalcLWMA(double &MA[],int ma_period){
   for(int j=0;j<limit;j++){
      double MA_Sum=0;
      int weight=ma_period;
      int weight_sum=0;
      for(int k=j;k<j+ma_period;k++){
         weight_sum+=weight;
         MA_Sum+=PrH[k]*weight;
         weight--;
      }
      MA[j]=MA_Sum/weight_sum;
   }
}
