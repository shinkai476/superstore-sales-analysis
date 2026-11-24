-- Preview tabel
SELECT * FROM erkuy.`sample - superstore` LIMIT 5;

-- Cek nilai kosong pada kolom penting
SELECT SUM(`Order ID` IS NULL OR `Order ID` = '')       AS kosong_order_id,
       SUM(`Order Date` IS NULL OR `Order Date` = '')   AS kosong_tanggal,
       SUM(State IS NULL OR State = '')                 AS kosong_state,
       SUM(Category IS NULL OR Category = '')           AS kosong_kategori,
       SUM(Sales IS NULL)                               AS kosong_sales,
       SUM(Profit IS NULL)                              AS kosong_profit
FROM erkuy.`sample - superstore`;

-- Cek baris duplikat (semua kolom sama, selain Row ID)
SELECT `Order ID`, `Product ID`, Sales, Quantity, COUNT(*) AS jumlah
FROM erkuy.`sample - superstore`
GROUP BY `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`,
         `Product ID`, Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

-- Cek baris duplikat (semua kolom sama, selain Row ID)
SELECT `Order ID`, `Product ID`, Sales, Quantity, COUNT(*) AS jumlah
FROM erkuy.`sample - superstore`
GROUP BY `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`,
         `Product ID`, Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

-- Jumlah pesanan per tahun
SELECT YEAR(STR_TO_DATE(`Order Date`, '%m/%d/%Y')) AS tahun,
       COUNT(DISTINCT `Order ID`)                  AS jumlah_pesanan
FROM erkuy.`sample - superstore`
GROUP BY tahun
ORDER BY tahun;

-- Distribusi kategori
SELECT Category, COUNT(*) AS jumlah
FROM erkuy.`sample - superstore`
GROUP BY Category
ORDER BY jumlah DESC;

-- Distribusi region
SELECT Region, COUNT(*) AS jumlah
FROM erkuy.`sample - superstore`
GROUP BY Region
ORDER BY jumlah DESC;

-- Distribusi segmen pelanggan
SELECT Segment, COUNT(*) AS jumlah
FROM erkuy.`sample - superstore`
GROUP BY Segment
ORDER BY jumlah DESC;

-- Sebaran Sales (min, max, rata-rata)
SELECT MIN(Sales), MAX(Sales), ROUND(AVG(Sales), 2)
FROM erkuy.`sample - superstore`;

-- Sebaran Profit (min, max, rata-rata)
SELECT MIN(Profit), MAX(Profit), ROUND(AVG(Profit), 2)
FROM erkuy.`sample - superstore`;

-- Jumlah baris yang rugi (profit negatif)
SELECT COUNT(*) AS baris_rugi
FROM erkuy.`sample - superstore`
WHERE Profit < 0;

-- Level diskon yang ada
SELECT Discount, COUNT(*) AS jumlah
FROM erkuy.`sample - superstore`
GROUP BY Discount
ORDER BY Discount;

