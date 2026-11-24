-- =====================================================
-- KEPUTUSAN CLEANING (berdasarkan hasil di 01_eksplorasi.sql)
-- =====================================================
-- 1. Ada 1 baris duplikat (pesanan US-2014-150119).
--    Dari baris yang isinya persis sama, hanya Row ID terkecil yang dipakai.
-- 2. Semua pesanan dipakai (tidak ada kolom status pesanan seperti di Olist).
-- 3. Periode analisis: 2014-01 s.d. 2017-12 (48 bulan penuh).
--    Tidak ada bulan kosong atau data terpotong, jadi filter periode tidak membuang baris.
-- 4. Profit negatif dan nilai ekstrem tidak dihapus karena itu data nyata.
-- 5. Tanggal berformat M/D/YYYY (teks), jadi ditambahkan kolom tahun dan bulan.
-- 6. Diskon dikelompokkan menjadi 4 kelompok (kolom kelompok_diskon).

-- Membuat view pesanan bersih (tanpa duplikat, Jan 2014 - Des 2017)
DROP VIEW IF EXISTS erkuy.clean_superstore;

CREATE VIEW erkuy.clean_superstore AS
SELECT *,
       YEAR(STR_TO_DATE(`Order Date`, '%m/%d/%Y'))                 AS tahun,
       DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y-%m') AS bulan,
       CASE
         WHEN Discount = 0    THEN '1. Tanpa diskon'
         WHEN Discount <= 0.2 THEN '2. Diskon 1-20%'
         WHEN Discount <= 0.4 THEN '3. Diskon 21-40%'
         ELSE                      '4. Diskon di atas 40%'
       END                                                         AS kelompok_diskon
FROM erkuy.`sample - superstore`
WHERE `Row ID` IN (
        SELECT MIN(`Row ID`)
        FROM erkuy.`sample - superstore`
        GROUP BY `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`,
                 `Product ID`, Sales, Quantity, Discount, Profit
      )
  AND STR_TO_DATE(`Order Date`, '%m/%d/%Y') >= '2014-01-01'
  AND STR_TO_DATE(`Order Date`, '%m/%d/%Y') <  '2018-01-01';

-- =====================================================
-- VERIFIKASI
-- =====================================================


SELECT (SELECT COUNT(*) FROM erkuy.`sample - superstore`) AS baris_mentah,
       (SELECT COUNT(*) FROM erkuy.clean_superstore)      AS baris_bersih;


-- Verifikasi isi view clean_superstore
SELECT COUNT(*)              AS jumlah_baris_bersih,
       MIN(bulan)            AS awal,
       MAX(bulan)            AS akhir,
       COUNT(DISTINCT bulan) AS jumlah_bulan
FROM erkuy.clean_superstore;
-- Hasil: 9.993 baris bersih, 2014-01 s.d. 2017-12, 48 bulan

-- Preview hasil akhir
SELECT * FROM erkuy.clean_superstore LIMIT 5;