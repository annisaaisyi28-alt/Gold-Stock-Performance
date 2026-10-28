# Gold-Stock-Performance
📌 **Project Overview**: This project analyzes the performance of a single stock from 2,968 daily price gold and volume records between 2014 and 2025. Therefore, this project builds a Power BI dashboard that tracks returns, risk, and volume to support more informed decisions on entry timing and risk exposure.
#
📊 **Dataset Summary**
- Total Data: 2968 rows, 6 columns
- Source: Kaggle (https://www.kaggle.com/datasets/shakhnoza12/gold-price-analysis-20002026/code)
#
| Column Name | Description                                     |
|-------------|-------------------------------------------------|
| Date        | Trading timestamp                               |
| Open        | Stock price at market open (USD)                |
| High        | Peak stock price during trading session (USD)   |
| Low         | Lowest stock price during trading session (USD) |
| Close       | Closing stock price adjusted for splits (USD)   |
| Volume      | Total shares traded during the session          |
#
⚙️ **Workflow**
1. **Data preparation and modeling** using Power Query
2. **Data Analysis (DAX)**: Calculated annual and monthly returns, CAGR, and 50-day and 200-day moving averages, running peak, drawdown, and 30-day rolling volatility measures to quantify downside risk, compared average daily volume by year, flagged days when volume exceeded twice its trailing 30-day average, and measured the relationship between the size of daily moves and trading volume.
3. **Data Visualization**: The analysis is descriptive and does not claim to explain why the price moved, since the dataset contains no external factors.
#
💡**Key Highlights**
1. Growth was strong but uneven. The stock compounded at 18.2% per year, yet that average hides a lopsided path, with gains of +241.4% in 2020 and about +146% in 2021 following three consecutive losing years in 2017–2019 (−23.4%, about −19%, and −29.9%).
2. Downside risk has been severe. The maximum drawdown reached −62.9% on 28 January 2020, and the latest close of $33.76 still sits 25% below the September 2024 peak of $44.81.
3. Volatility is high and clustered. Annualized volatility is 44%, and three of the six most extreme days fall in 2020–2021, including the best day (+27.2% on 11 September 2020) and the worst (−17.5% on 10 February 2021).
4. Trading activity has surged. Average daily volume rose from about 16K shares in 2019 to 348K in 2024 and remained high at 319K in 2025, showing much heavier investor participation during and after the 2020–2021 rally.
5. Recent momentum is recovering. After small losses in 2023 (−8.4%) and 2024 (about −7%), the stock gained 28.4% in 2025, which brought the price back toward its higher range but not yet to its previous peak.
