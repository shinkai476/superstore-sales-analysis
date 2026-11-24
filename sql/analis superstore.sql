-- =====================================================
-- KPI UTAMA
-- =====================================================

SELECT ROUND(SUM(Sales), 2)                             AS total_sales,
       ROUND(SUM(Profit), 2)                            AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)       AS margin_persen,
       COUNT(DISTINCT `Order ID`)                         AS jumlah_pesanan,
       COUNT(DISTINCT `Customer ID`)                      AS jumlah_pelanggan,
       ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`), 2)  AS rata_rata_nilai_pesanan
FROM erkuy.clean_superstore;
-- Hasil: sales 2.296.919; profit 286.409; margin 12,47%; 5.009 pesanan;
--        793 pelanggan; rata-rata nilai pesanan 458,56

-- =====================================================
-- 1. TREN TAHUNAN
-- =====================================================

SELECT tahun,
       ROUND(SUM(Sales), 0)                        AS total_sales,
       ROUND(SUM(Profit), 0)                       AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)  AS margin_persen,
       COUNT(DISTINCT `Order ID`)                    AS jumlah_pesanan
FROM erkuy.clean_superstore
GROUP BY tahun
ORDER BY tahun;
-- Hasil: sales naik dari 484 ribu (2014) menjadi 733 ribu (2017).
--        Margin: 10,24% (2014), 13,10%, 13,43%, lalu turun ke 12,74% (2017).
--        Sales 2017 naik 20% dari 2016, tetapi marginnya turun.

-- Tren bulanan (untuk line chart di dashboard)
SELECT bulan,
       ROUND(SUM(Sales), 0)   AS total_sales,
       ROUND(SUM(Profit), 0)  AS total_profit
FROM erkuy.clean_superstore
GROUP BY bulan
ORDER BY bulan;
-- Hasil: 48 bulan. Penjualan melonjak tiap September-Desember dan turun tajam di Januari-Februari.

-- =====================================================
-- 2. KATEGORI DAN SUB-KATEGORI
-- =====================================================

SELECT Category,
       ROUND(SUM(Sales), 0)                        AS total_sales,
       ROUND(SUM(Profit), 0)                       AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)  AS margin_persen
FROM erkuy.clean_superstore
GROUP BY Category
ORDER BY total_profit DESC;
-- Hasil: Technology   profit 145 ribu, margin 17,40%
--        Office Supplies profit 122 ribu, margin 17,04%
--        Furniture    profit 18 ribu, margin hanya 2,49% (sales 742 ribu, hampir sama dengan Technology)

-- 5 sub-kategori dengan profit terendah
SELECT Category, `Sub-Category`,
       ROUND(SUM(Sales), 0)                        AS total_sales,
       ROUND(SUM(Profit), 0)                       AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)  AS margin_persen
FROM erkuy.clean_superstore
GROUP BY Category, `Sub-Category`
ORDER BY total_profit
LIMIT 5;
-- Hasil: Tables (-17.725), Bookcases (-3.473), Supplies (-1.189) merugi.
--        Fasteners (950) dan Machines (3.385) untungnya sangat kecil.

-- =====================================================
-- 3. PENGARUH DISKON
-- =====================================================

SELECT kelompok_diskon,
       COUNT(*)                                     AS jumlah_baris,
       ROUND(SUM(Sales), 0)                         AS total_sales,
       ROUND(SUM(Profit), 0)                        AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)   AS margin_persen
FROM erkuy.clean_superstore
GROUP BY kelompok_diskon
ORDER BY kelompok_diskon;
-- Hasil: Tanpa diskon      -> profit 320.988, margin 29,51%
--        Diskon 1-20%      -> profit 100.785, margin 11,91%
--        Diskon 21-40%     -> profit -35.805, margin -15,31%
--        Diskon di atas 40% -> profit -99.559, margin -77,40%
--        Mulai diskon di atas 20%, transaksi cenderung rugi.

-- Sub-kategori yang paling rugi saat diskon di atas 20%
SELECT `Sub-Category`,
       COUNT(*)                AS jumlah_baris,
       ROUND(SUM(Profit), 0)   AS profit_diskon_tinggi
FROM erkuy.clean_superstore
WHERE Discount > 0.2
GROUP BY `Sub-Category`
ORDER BY profit_diskon_tinggi
LIMIT 5;
-- Hasil: Binders (-38.510), Tables (-30.698), Machines (-29.555),
--        Bookcases (-11.098), Appliances (-8.630).

-- =====================================================
-- 4. WILAYAH
-- =====================================================

SELECT Region,
       ROUND(SUM(Sales), 0)                        AS total_sales,
       ROUND(SUM(Profit), 0)                       AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)  AS margin_persen,
       ROUND(AVG(Discount), 3)                       AS rata_rata_diskon
FROM erkuy.clean_superstore
GROUP BY Region
ORDER BY total_profit DESC;
-- Hasil: West (margin 14,94%), East (13,49%), South (11,93%), Central (7,92%).
--        Central punya margin terendah dan rata-rata diskon tertinggi (24%).

-- 5 state dengan profit terendah
SELECT State,
       ROUND(SUM(Sales), 0)    AS total_sales,
       ROUND(SUM(Profit), 0)   AS total_profit,
       ROUND(AVG(Discount), 3)   AS rata_rata_diskon
FROM erkuy.clean_superstore
GROUP BY State
ORDER BY total_profit
LIMIT 5;
-- Hasil: Texas (-25.729), Ohio (-16.959), Pennsylvania (-15.560),
--        Illinois (-12.608), North Carolina (-7.491).

-- 5 state dengan profit tertinggi
SELECT State,
       ROUND(SUM(Sales), 0)    AS total_sales,
       ROUND(SUM(Profit), 0)   AS total_profit
FROM erkuy.clean_superstore
GROUP BY State
ORDER BY total_profit DESC
LIMIT 5;
-- Hasil: California (76.381), New York (74.039), Washington (33.403),
--        Michigan (24.463), Virginia (18.598).

-- =====================================================
-- 5. SEGMEN PELANGGAN
-- =====================================================

SELECT Segment,
       COUNT(DISTINCT `Customer ID`)                        AS jumlah_pelanggan,
       ROUND(SUM(Sales), 0)                               AS total_sales,
       ROUND(SUM(Profit), 0)                              AS total_profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)         AS margin_persen,
       ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`), 2)    AS rata_rata_nilai_pesanan
FROM erkuy.clean_superstore
GROUP BY Segment
ORDER BY total_sales DESC;
-- Hasil: Consumer (409 pelanggan, sales 1,16 juta, margin 11,55%),
--        Corporate (236 pelanggan, margin 13,03%),
--        Home Office (148 pelanggan, margin 14,05%).
--        Consumer terbesar, tetapi marginnya paling rendah.

-- =====================================================
-- TABEL UNTUK DASHBOARD
-- =====================================================
-- Ekspor ke CSV (Save the results view > Export to CSV), lalu simpan di folder clean/:
--   clean_superstore.csv : SELECT * FROM erkuy.clean_superstore;
-- Power BI bisa menghitung tren, kategori, diskon, dan wilayah langsung dari file ini.
