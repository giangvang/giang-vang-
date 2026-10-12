# Nhật ký tra cứu AI (Prompt Log)

**1. Khám phá ảnh hưởng của Index TEXT và BOOLEAN**
- *Prompt:* "Trong MySQL, nếu tôi tạo Index trên một cột chứa văn bản dài (TEXT) và một cột kiểu BOOLEAN (0 và 1), thì điều này gây hại như thế nào đến bộ nhớ RAM, dung lượng Disk và bộ tối ưu hóa (Query Optimizer)?"[cite: 13]
- *Kết quả học được:* Tạo Index trên TEXT làm phình to B-Tree, tốn Disk và chiếm dụng RAM của Buffer Pool[cite: 13]. Với BOOLEAN, Cardinality thấp khiến Query Optimizer đánh giá việc dùng Index tốn chi phí I/O (Random Read) nhiều hơn là quét toàn bảng (Sequential Read), do đó Index bị bỏ qua[cite: 13].

**2. Tìm hiểu quyết định của Query Optimizer**
- *Prompt:* "Tại sao khi tôi truy vấn SELECT * FROM Posts WHERE is_visible = 1 trên một bảng có hàng triệu dòng (trong đó 99% bài viết là visible = 1), MySQL lại quyết định quét toàn bảng (Full Table Scan) thay vì sử dụng Index idx_is_visible đã tạo?"[cite: 13]
- *Kết quả học được:* Vì 99% dữ liệu thỏa mãn điều kiện, nếu dùng Index, MySQL phải dò B-Tree rồi nhảy về Data Pages hàng triệu lần (Look-up)[cite: 13]. Quét tuần tự toàn bảng từ đầu đến cuối tiết kiệm I/O ổ cứng hơn rất nhiều[cite: 13].

**3. Lệnh kiểm tra dung lượng**
- *Prompt:* "Hãy cho tôi xem truy vấn SQL sử dụng bảng information_schema.TABLES để in ra kích thước Data và kích thước Index của bảng 'Posts' tính theo đơn vị Megabyte (MB)."[cite: 13]
- *Kết quả học được:* Áp dụng công thức `(DATA_LENGTH / 1024 / 1024)` và `(INDEX_LENGTH / 1024 / 1024)` từ bảng `information_schema.TABLES` để có số liệu trực quan[cite: 13].

**4. Cơ chế tìm kiếm văn bản thay thế**
- *Prompt:* "Nếu muốn tìm kiếm từ khóa bên trong cột content (kiểu TEXT) mà không bị tốn quá nhiều dung lượng như B-Tree Index, tôi nên sử dụng cơ chế nào của MySQL?"[cite: 13]
- *Kết quả học được:* Dùng cơ chế `FULLTEXT INDEX`[cite: 13]. Cấu trúc Inverted Index của nó giống như mục lục sách, giúp tìm kiếm từ khóa nhanh chóng mà không lưu nguyên chuỗi dài vào B-Tree[cite: 13].