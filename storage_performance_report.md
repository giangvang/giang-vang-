# Báo cáo Tối ưu hóa Lưu trữ và Hiệu suất - Bảng Posts

## 1. Sự đánh đổi giữa Read (Đọc) và Write (Ghi)
Trong InnoDB, Index giúp tăng tốc độ truy vấn (Read) nhưng lại làm chậm tốc độ ghi (Write)[cite: 14]. Mỗi khi có thao tác `INSERT`, `UPDATE` hoặc `DELETE`, MySQL không chỉ cập nhật dữ liệu ở Data Pages mà còn phải cập nhật cấu trúc cây B-Tree của tất cả các Index liên quan[cite: 14]. Việc lạm dụng 5 Index trên bảng `Posts` khiến mỗi lần thêm bài viết mới, hệ thống phải chịu chi phí ghi gấp 6 lần (1 lần Data + 5 lần Index), gây quá tải I/O Disk, làm tăng Latency và dẫn đến Timeout cho ứng dụng[cite: 14].

## 2. Quyết định tối ưu (Xóa 3 Index)
- **idx_content (Xóa):** Cột TEXT có kích thước quá lớn, việc tạo B-Tree Index làm phình to dung lượng vô ích[cite: 14]. Để tìm kiếm văn bản, nên sử dụng FULLTEXT INDEX[cite: 14].
- **idx_post_type & idx_is_visible (Xóa):** Hai cột này có Cardinality rất thấp (chỉ 2-3 giá trị phân biệt)[cite: 14]. Khi truy vấn, Query Optimizer thường chọn Full Table Scan thay vì dùng Index, khiến 2 Index này hoàn toàn vô dụng nhưng vẫn ngốn chi phí bảo trì[cite: 14].
- **idx_user_id & idx_created_at (Giữ lại):** Đây là các cột có độ phân biệt cao, mang tính cốt lõi để load Newsfeed (lọc bài viết theo user và sắp xếp thời gian mới nhất)[cite: 14].

## 3. Kết quả đối chiếu
Bằng việc loại bỏ 3 Index vô dụng, hệ thống đã cắt giảm được 3 thao tác cập nhật B-Tree thừa thãi cho mỗi lượt INSERT[cite: 14]. Dung lượng tổng của cột `Index_length` được giải phóng đáng kể, giúp RAM (Buffer Pool) có thêm không gian để cache các dữ liệu quan trọng hơn, cân bằng lại hiệu suất giữa thao tác Đọc và Ghi[cite: 14].