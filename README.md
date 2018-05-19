# EURx-embedded-in-MT4-Platform


EURx, also known as Euro Currency Index, represents the arithmetic ratio of four major currencies against the Euro: US-Dollar, British Pound, Japanese Yen and Swiss Franc. All currencies are expressed in units of currency per Euro. (please refer to wiki for more details, https://en.wikipedia.org/wiki/Euro_Currency_Index)

The movement of EURx is highly correlated to the movement of EURUSD, the most traded currency pairs, and EUR-pair currencies. MT4 is the most used trading platform. As a financial investors or traders, it is essential to have a EURx tool that can be embedded into MT4 to enhance the efficiencies of your trading and profitabilities of your performance.

This MT4 indicator is made with visualized candle sticks (bullish with red color, bearish with white color) and multiple simple moving average (10,20,40). Source code is provided. Code can be easily edited too.

Formula of EURX: EURX = 34.38805726 x (EURUSD)^(-0.3155) x (EURGBP)^(0.3056) x (EURJPY)^(-0.1891) x (EURSEK)^(0.0785) x (EURCHF)^(0.1113)

Installation:

1. Your must signup a MT4 account with any forex broker;
2. Your forex broker must provide the following currency pairs: EURUSD, EURGBP, EURJPY, EURSEK, EURCHF
3. Open your MT4 Platform, select "File" > "Open Data Folder" > "MQL4" > "Indicators"
4. Drag the "EURX.mq4" file into "Indicators" folder in the 3 step
5. Select "View" > "Navigator", under "Indicators" list, select "EURX", right click and select "Modify"
6. In the MetaEditor, select "EURX.mq4", click "Compile" or F7(keyboard shortcut)
7. Close your MT4 platform
8. Reopen your MT4 platform
9. Select "View" > "Navigator", under "Indicators" list, select "EURX"
10. Drag "EURX" indicator to any Chart Window
11. Enjoy!
