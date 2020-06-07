# Risk Transmission Mechanism across Industries in China based on VAR-Lasso

It is crucial to learn how the risk has been transmitted between industries in China before and after some big events. To conduct the empirical research on risk transmission mechanism in China based on daily data of the SWS secondary industry index, I utilize the LASSO algorithm to compress, select and estimate variables and build a high dimensional VAR model to calculate the pairwise risk connectedness between different industries. With the help of network analysis, I visualize the outcome of the VAR-Lasso model. Then, both full sample estimation and rolling window estimation are applied to make a static and dynamic study of the risk transmission network. As is revealed in dynamic analysis, clustering characteristics can be easily seen in risk transmission in the market, especially between elements in the same industrial chain or between industries that are closely connected. Particularly, Oil exploitation, Insurance, Banking, and Railway Transportation are functioning as the efficient intermediary node in the whole transmission process. As for dynamic analysis, the overall risk connectedness reaches the summit of the great stock damage in 2015 and the shock of Covid-19. Comparisons are made on the risk transmission network before and after those big events.

## Data

I obtain the data of 104 industries from the SWS secondary industry index, from October 12, 2010 to May 23, 2020. The data is in classical OHLC format, which contains high price, low price, open price and close price during the day.

## Code

I use R to realized to whole model based on the framwork of **Diebold–Yilmaz volatility connectedness**. The packages I use in the code are:

- [frequencyConnectedness](https://github.com/tomaskrehlik/frequencyConnectedness)
- [BigVAR](https://github.com/wbnicholson/BigVAR)
- [tidyverse](https://www.tidyverse.org/)

The output of R is stored in the *r file* folder. Also, I use [Gephi](https://gephi.org/) to draw the network plot and the related file is stored in *gephi file* folder.