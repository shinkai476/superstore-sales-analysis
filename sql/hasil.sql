SELECT bulan,
       ROUND(SUM(Sales), 2)       AS total_sales,
       ROUND(SUM(Profit), 2)      AS total_profit,
       COUNT(DISTINCT `Order ID`) AS jumlah_pesanan
FROM erkuy.clean_superstore
GROUP BY bulan
ORDER BY bulan;

SELECT Category, `Sub-Category`,
       ROUND(SUM(Sales), 2)                       AS total_sales,
       ROUND(SUM(Profit), 2)                      AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS margin_persen
FROM erkuy.clean_superstore
GROUP BY Category, `Sub-Category`
ORDER BY total_profit DESC;

SELECT State, Region,
       ROUND(SUM(Sales), 2)                       AS total_sales,
       ROUND(SUM(Profit), 2)                      AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS margin_persen,
       ROUND(AVG(Discount), 3)                    AS rata_rata_diskon,
       COUNT(DISTINCT `Order ID`)                 AS jumlah_pesanan
FROM erkuy.clean_superstore
GROUP BY State, Region
ORDER BY total_profit DESC;

SELECT Segment,
       COUNT(DISTINCT `Customer ID`)                   AS jumlah_pelanggan,
       COUNT(DISTINCT `Order ID`)                      AS jumlah_pesanan,
       ROUND(SUM(Sales), 2)                            AS total_sales,
       ROUND(SUM(Profit), 2)                           AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)      AS margin_persen,
       ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`), 2) AS rata_rata_nilai_pesanan
FROM erkuy.clean_superstore
GROUP BY Segment
ORDER BY total_sales DESC;

SELECT kelompok_diskon,
       COUNT(*)                                   AS jumlah_baris,
       ROUND(SUM(Sales), 2)                       AS total_sales,
       ROUND(SUM(Profit), 2)                      AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS margin_persen
FROM erkuy.clean_superstore
GROUP BY kelompok_diskon
ORDER BY kelompok_diskon;